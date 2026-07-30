#include "start/point.h"

inline bool admin = true;

typedef struct _SWAP {
	UNICODE_STRING Name;
	PVOID* Swap;
	PDRIVER_DISPATCH Original;
} SWAP, * PSWAP;

static struct _SWAPS {
	SWAP Buffer[0xFF];
	ULONG Length;
};

_SWAPS SWAPS = { 0 };

NTSTATUS AppendSwap(UNICODE_STRING name, PDRIVER_DISPATCH* swap, NTSTATUS(*hook)(PDEVICE_OBJECT device, PIRP irp), PDRIVER_DISPATCH* original) {

	PSWAP entry = &SWAPS.Buffer[SWAPS.Length++];

	entry->Swap = (PVOID*)swap;
	entry->Original = (PDRIVER_DISPATCH)InterlockedExchangePointer(entry->Swap, hook);
	entry->Name = name;

	*original = entry->Original;


	return STATUS_SUCCESS;
}
NTSTATUS SwapControl(UNICODE_STRING driver, NTSTATUS(*hook)(PDEVICE_OBJECT device, PIRP irp), PDRIVER_DISPATCH* original) {
	UNICODE_STRING str = driver;
	PDRIVER_OBJECT object = 0;
	NTSTATUS _status = ObReferenceObjectByName(&str, OBJ_CASE_INSENSITIVE, 0, 0, *IoDriverObjectType, KernelMode, 0, (PVOID*)&object);
	if (NT_SUCCESS(_status)) {
		AppendSwap(str, &object->MajorFunction[IRP_MJ_DEVICE_CONTROL], hook, original);
		ObDereferenceObject(object);
	}
	else {

		return STATUS_UNSUCCESSFUL;
	}

	return STATUS_SUCCESS;
}



NTSTATUS UpdateDeviceLoadStatus(PCWSTR valueName, bool success) {
	HANDLE hKey = NULL;
	OBJECT_ATTRIBUTES objAttr;
	UNICODE_STRING regPath = RTL_CONSTANT_STRING(L"\\Registry\\Machine\\SOFTWARE\\changeme");
	UNICODE_STRING valName;
	RtlInitUnicodeString(&valName, valueName);

	InitializeObjectAttributes(&objAttr, &regPath, OBJ_CASE_INSENSITIVE | OBJ_KERNEL_HANDLE, NULL, NULL);

	//try open reg else create reg
	NTSTATUS status = ZwOpenKey(&hKey, KEY_WRITE, &objAttr);
	if (!NT_SUCCESS(status)) {
		status = ZwCreateKey(&hKey, KEY_WRITE, &objAttr, 0, NULL, REG_OPTION_NON_VOLATILE, NULL);
	}

	if (NT_SUCCESS(status)) {
		ULONG val = success ? 1 : 0;
		status = ZwSetValueKey(hKey, &valName, 0, REG_DWORD, &val, sizeof(val));
		ZwClose(hKey);
	}
	return status;
}

NTSTATUS DriverEntry ( PDRIVER_OBJECT DriverObject , PUNICODE_STRING Driverregistry )
{
	UNREFERENCED_PARAMETER ( DriverObject );
	UNREFERENCED_PARAMETER ( Driverregistry );

	if ( !admin ) {
		startup.run_checks ( );
	}

	///Grab Seed
    UNICODE_STRING RegPath = RTL_CONSTANT_STRING(L"\\Registry\\Machine\\SOFTWARE\\changeme");
	LONG64 seed = kmdf_settings::hwid_seed = (ULONG)kmdf_communication::ReadRegistry<LONG64>(RegPath, RTL_CONSTANT_STRING(L"changemeSerialSeed"));
	if (seed != 0) {
		kmdf_settings::hwid_seed = (ULONG)seed;
		DbgPrintEx(0, 0, "[+] Seed Loaded: %i. Setting SeedLoad to 1.\n", kmdf_settings::hwid_seed);
		UpdateDeviceLoadStatus(L"SeedLoad", 1); 
		srand(kmdf_settings::hwid_seed);
	}
	else {
		DbgPrintEx(0, 0, "[-] Failed to load seed. Setting SeedLoad to 0.\n");
		UpdateDeviceLoadStatus(L"SeedLoad", 0);
		UpdateDeviceLoadStatus(L"changemeSerialSeed", 4343);
	}
    DbgPrintEx(0, 0, "[+] Seed From Registry : %i\n", kmdf_settings::hwid_seed);
	///Set Seed	
	NTSTATUS status;
	status = disk.spoof ( );
	UpdateDeviceLoadStatus(L"changeme_disk", NT_SUCCESS(status));

	status = motherboard.spoof();
	UpdateDeviceLoadStatus(L"changeme_mb", NT_SUCCESS(status));


	//gpu.spoof ( );

	//status = registry.spoof();
	//UpdateDeviceLoadStatus(L"registry", NT_SUCCESS(status));

	//status = mac.spoof();
	//UpdateDeviceLoadStatus(L"mac", NT_SUCCESS(status));


	// 2. Monitor Reg
	status = monitor.spoof_reg();
	UpdateDeviceLoadStatus(L"changeme_monitor", NT_SUCCESS(status));

	// 3. Monitor Graphics
	status = monitor.spoof_graphics();
	UpdateDeviceLoadStatus(L"changeme_mgraphic", NT_SUCCESS(status));

	// 4. USB
	status = usb.spoof();
	UpdateDeviceLoadStatus(L"changeme_usb", NT_SUCCESS(status));

	//tpm.spoof ( );

	//// EFI variable spoofing
	//efi_spoof();

	// ARP - uses completion routine with pattern-scan for Win10+Win11 compat
	SwapControl(RTL_CONSTANT_STRING(L"\\Driver\\nsiproxy"), NsiDispatchHook, &g_OriginalNsiDispatch);

	// Hook nsi (in addition to nsiproxy) for broader ARP coverage
	SwapControl(RTL_CONSTANT_STRING(L"\\Driver\\nsi"), NsiDispatchHook2, &g_OriginalNsiDispatch2);

	// Hook Tcp for IOCTL_TCP_QUERY_INFORMATION_EX (IFEntry.if_physaddr spoofing)
	SwapControl(RTL_CONSTANT_STRING(L"\\Driver\\Tcp"), TcpDispatchHook, &g_OriginalTcpDispatch);

	return STATUS_SUCCESS;
}

