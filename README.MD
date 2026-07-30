I'm sharing a method for spoofing serial numbers in MTA:SA. It's my own method, developed based on publicly available projects. It's probably the only publicly available and free method available today, as I couldn't find a thread that would allow it. :firedevil:

[B][COLOR="Red"]The method definitely work, I checked it several times.
[/COLOR][/B]

If you managed to change your serial number, give me reputation in return 
[IMG]https://i.imgur.com/BW93jt2.gif[/IMG]

Below I am including all the sources I used:
[PHP]
Use temp-spoofer from my attachment because it is modified
[URL="https://www.unknowncheats.me/forum/anti-cheat-bypass/742461-windows-kernel-driver-temp-spoofer.html"]https://www.unknowncheats.me/forum/anti-cheat-bypass/742461-windows-kernel-driver-temp-spoofer.html[/URL]
github kdmapper
github MAC-Address-Spoofer
github HWIDInspector
and others
[/PHP]

Additional software required:
[CODE]
Python
Visual studio 2022
WDK and SDK 26100.6584 or other
[/CODE]

Advantages and disadvantages of the following method:
[CODE]
+ It does not require a disk format, although you can probably skip some steps in this method by formatting it.

+ Permanent, new SERIAL, you can freely set the random seed to generate a new one or keep the old one

+ It's free but time-consuming

- Requires creating a new user account and deleting the old account, as well as transferring AppData, which may cause problems

- There is no 100% certainty that this method removes all traces

- It requires some intermediate knowledge, for those who don't know much I think they will be able to handle the AI ​​chat.


[/CODE]

[B][COLOR="Red"]Dangers of this method:[/COLOR][/B]
[CODE]
- Post some user in original temp spoofer thread mentioned the possibility of system corruption, which requires formatting, but that likely relates to EFI spoofing, which is disabled by default in the spoofer solution. In any case, I didn't have this problem when spoofing a disk in a VM or locally, but take this as a warning.

- Possibility of damaging program data stored in the Appdata folder

- BSOD

Possible minor Windows errors. So far, I've encountered:

- A slow right-click context menu is caused by a program remaining in the registry that doesn't exist but was previously in appdata. This can be easily fixed with shellview.

- The Start Menu sometimes crashes, only if you loading a driver using kdmapper. You can still use the system after the crash, but without the Start Menu. It resolves after a restart.

- Windows accounts disappear upon login; you can only log in with the main account. This resolves after enabling a special administrator account and setting a password for that account in cmd.

- Trouble finding various options in the Start Menu. For example, I can't open Folder Options, but I can open them with Win+R.

- Most of these problems can probably be avoided by using a registry backup of the most important system keys.
[/CODE]

[COLOR="Lime"]
TODO[/COLOR]
[CODE]
- [B][COLOR="Red"]For some reason, sometimes the old serial number remains at the beginning until we connect to the server, this may mean that not all traces have been removed![/COLOR][/B]

- Find all the traces after using MTA, exact methods of obtaining the serial number through MTA so as not to make unnecessary steps

- Getting rid of unnecessary steps from the method?

- Fix registry and mac spoofing functions in temp-spoofer, add spoofing options like in HWIDInspector

- Introduce GPU spoofing capability for AMD and other parameters

- Creating one solution in exe format, spoofing the serial number with one click and the ability to set the serial

- Instead of using a spoofer, create code that can infect MTA and replace all serial numbers in packets and overwrite MTA functions that query the system for hardware identifiers 

- Check if this method will effectively avoid GLOBAL BAN in MTA, if not, find out why it doesn't work and fix it

- Modify the spoofer to make it undetectable


[/CODE]

[B][COLOR="DarkOrange"]DOWNLOAD[/COLOR][/B]: 
[url]https://www.unknowncheats.me/forum/downloads.php?do=file&id=56424[/url]
[COLOR="Lime"]INSTRUCTION:[/COLOR]
[SPOILER]
[CODE]Administrator permissions required
[COLOR="Red"][B]Disable all Windows Defender options, disable or remove your antivirus
In cmd as administrator, add your system drive to exclusions: powershell -Command "Add-MpPreference -ExclusionPath 'c:'"

From now on, close MTA and GTA SA and do not open them[/B][/COLOR]

Download the required software from req_soft.txt. Install PYTHON only on the new user profile.

Download, extract every downloaded program into the folder containing the file with the download link for that program:
 \spoof_method_release\Windows-MAC-Address-Spoofer-main\download.txt
 \spoof_method_release\HWIDInspector-main\download.txt
 \spoof_method_release\cleaning scripts\INSTALL_SUDO_BEFORE_CLEAN.txt
 \spoof_method_release\driver\x64\Release\download_kdmapper.txt REQUIRES COMPILATION, do it!

Compile the kdmapper solution, place the exe file into \spoof_method_release\driver\x64\Release
 Compile the \spoof_method_release\driver solution

I recommend opening the solution and changing the registry keys to your own names in main.cpp! It is best to use names of existing programs!

[BEFORE RUNNING BAT SCRIPTS, MAKE SURE THEY WILL WORK ON THE SYSTEM DRIVE AND ON THE DRIVE WHERE MTA FILES ARE LOCATED]

WIN + R > type cmd > ctrl + shift + enter > cd your_path\spoof_method_release\cleaning scripts
 You run the scripts by typing their name in cmd
  Type clean_mta.bat and wait for it to finish

Type samp_reg_remove.bat and wait for it to finish

(CAUTION: The script below deletes temporary data, which may contain data from programs you use!)

Type clear_temp_data.bat and wait for it to finish
 Delete the mtasa-1.6.exe installer files or any other MTA installer files in the folder where you save downloaded files

Press the WIN + R shortcut and type ms-settings:otherusers
 Click Add > I don't have this person's sign-in information... > Add a user without a Microsoft account
  > think of a new username > click on the new account in the list > Change account type > Administrator > OK

Press the WIN + R shortcut, type cmd, click ctrl + shift + enter, and type net user Administrator /active:yes
 ctrl + alt + delete, log out, log in to the new account, log out, and log in to the Administrator account

After logging into the administrator account, press win + r and type
 control folders > View > Hidden files and folders > Show hidden files... > Apply

CAUTION: The operations on AppData below may damage/delete data used by any programs on your system
 You do this at your OWN RISK. If you have any data that might be stored in AppData, back up the entire
  folder into an archive before the operation, though it may take a while.

Open the path system_drive\Users
 Go into the folder with your old account name, select everything you need except "AppData", and click CUT

Return to the Users folder, go into the folder with the new username, and paste all data there

Then return to your old user folder and go into the appdata folder. On the DESKTOP, create folders Local, LocalLow, Roaming

Then on the desktop, open each of the above folders, return to the appdata folder
 Sequentially perform the following operations for Local, LocalLow, Roaming
  Move folders with the names of the programs you care about to the folders on the desktop
   Meaning: files from the appdata/Local folder are moved to the Local folder on the desktop

From each folder, I recommend at least moving folders named:
 [anything with Microsoft in the name], VisualStudio, chrome/mozilla/other browser you use, AMD/ATI/NVIDIA,
  [names of programs you care about]

Then open the users/new_username folder and open or create the AppData folder if it does not exist
 Into AppData, paste all folders from the desktop: local, local low, roaming, and replace

Press WIN + R, type netplwiz, and click ctrl + shift + enter

[This step will delete all user data!]

Click on your old account in the list and then delete it

Return to the AppData folder, delete the folder with your old account name, and empty the recycle bin

Open regedit under the key HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
 In profile list, check the sub-keys and look at the ProfileImagePath parameter to see if the old account is present

Press WIN + R, type cmd, and click ctrl + shift + enter
 Type net user Administrator /active:no, restart the computer, and then log into the new account

Install some VPN or not if you already have one, it will come in handy later

It is best to remove the old GTA SA and install it so that the path looks like this: C:\Program Files (x86)\Rockstar Games\GTA San Andreas

Open regedit with the path HKEY_LOCAL_MACHINE\SOFTWARE, right-click SOFTWARE > New > Key > type name [YOUR_NAME]
 if you didn't change the name in main.cpp, type "changeme", create inside changeme/your_name a QWORD 64 named changemeSerialSeed/or your_name
  click Decimal, type a random string of digits with a maximum length of 10, this is your seed so that your data is not constantly random

Open spoof_method_release\HWIDInspector-main

type in cmd pip install -r requirements.py
 then open HWIDInspector.py, in the GUI click Restart as Admin
  in OverView at the very top, copy your original parameters if
  you want to be able to revert to them: MachineGuid, computer name, Installation id.
   Save your parameters in a safe place. Click generate GUID and apply changes,
   run random_name.bat, copy the generated name and paste it into computer name, click
    generate installationID, click rename Computer and set installationID, and close the program.

Open cmd as administrator, type getmac, copy your original addresses and save them in a safe file.
 open \spoof_method_release\Windows-MAC-Address-Spoofer-main\WMAS.bat as administrator, repeat for
  each NIC > Randomize MAC address and close.

Open regedit as administrator HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CI\Config
 Create DWORD 32-bit > name: VulnerableDriverBlocklistEnable > Value: 0

Open HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios

If the HypervisorEnforcedCodeIntegrity sub-key exists, open it; if not, create the HypervisorEnforcedCodeIntegrity sub-key in scenarios
 Open HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity
  Create DWORD 32-bit > name: Enabled > value: 0

Turn off the computer, then check in the BIOS if you have the Secure Boot option and disable it; if you don't have it, do nothing. Restart.

[CAUTION: IF THE DRIVER WORKS INCORRECTLY, IT MAY CAUSE SYSTEM CORRUPTION DURING DISK SPOOFING!]

Go to \spoof_method_release\driver\x64\Release, press win + r, type cmd, type in cmd cd ...\spoof_method_release\driver\x64\Release
 run: kdmapper_Release.exe WindowsDriver.sys. If you didn't get a BSOD and the driver loaded, check the registry

HKEY_LOCAL_MACHINE\SOFTWARE[your_name] in this key, the driver should create values with spoof status and the load status
 of the seed from which component data IDs are generated; it is important to have a fixed seed because we will have a fixed serial.

```
IF EVERYTHING WORKS, DELETE ALL KEYS EXCEPT THE KEY WITH YOUR SEED.

```

Run cmd as administrator and type:
 bcdedit /set testsigning on
  bcdedit /set nointegritychecks on

Go to \spoof_method_release\cleaning scripts, run clear_temp_data.bat as administrator.

Go to the main GTA SA folder, copy the file spoof_method_release\cleaning scripts\randomizer_gta_installation.bat into the main folder
 run it as administrator. When the script finishes, delete it.

[CAUTION: IF THE DRIVER WORKS INCORRECTLY, IT MAY CAUSE SYSTEM CORRUPTION DURING DISK SPOOFING!]

In C:\ProgramData, create a folder with the name of an existing program, e.g., dolby. Drop the file
 spoof_method_release\driver\x64\Release\WindowsDriver.sys into the folder and rename it to your name, e.g., dolby.sys.
  COME UP WITH A NAME
  Then run cmd as administrator and type
  sc create dolby binPath= "C:\ProgramData\dolby\dolby.sys" type= kernel start= auto

Go to the start menu, from now on hold SHIFT the entire time, click restart, the advanced startup menu will open
 Troubleshoot > Advanced options > Startup Settings > Restart
  wait for the computer to restart and then select the option DISABLE DRIVER SIGNATURE ENFORCEMENT

Check in the registry if the keys were created; if the spoofing statuses have a value of 1, it succeeded, this is almost the end.

Go to \spoof_method_release\cleaning scripts, run clear_temp_data.bat as administrator.
Go to \spoof_method_release\cleaning scripts, run emul_temp_data.bat as administrator.
 If Windows settings/disk cleanup open, close them.

Download [https://yogadns.com/download/YogaDNSSetup.exe]and install it
 Open the program and import the configuration \spoof_method_release\cleaning scripts\yoga.xml
  configuration > rules > check if MTA rules exist, disable them, and click OK.

Run the VPN and use it whenever you connect to MTA or launch MTA.
 Open a private browser window or use the Mullvad browser, download the MTA installer.
  Run YogaDNS, go to rules and check everything for MTA, click OK.
   Open cmd, type ping multitheftauto.com; if it doesn't respond, it's okay.

Install MTA normally, launch MTA. MTA crashes or closing without an error after seeing the menu may occur,
 launch MTA like this 3 times, don't worry. Then close all MTA-related programs.

Go to \spoof_method_release\cleaning scripts, run clean_mta.bat as administrator.
Go to \spoof_method_release\cleaning scripts, run clear_temp_data.bat as administrator.
Go to \spoof_method_release\cleaning scripts, run emul_temp_data.bat as administrator.
Go to the main GTA SA folder, copy the file spoof_method_release\cleaning scripts\randomizer_gta_installation.bat into the main folder
 Run the script as administrator and delete it.

Open cmd as administrator and type:
sc stop your_name
sc delete your_name
 bcdedit /set testsigning off
 bcdedit /set nointegritychecks off

Then delete the C:\ProgramData\your_name folder and restart the computer. If you cannot delete it, rename the folder and delete it after a restart. Restart the computer again.

Go to \spoof_method_release\driver\x64\Release, press win + r, type cmd, type in cmd cd ...\spoof_method_release\driver\x64\Release
 run: kdmapper_Release.exe your_driver.sys. From now on, whenever you intend to launch MTA, you must do this before launching it.

Turn on YogaDNS, make sure MTA is blocked. Install MTA and create a local server.
 after joining the server, open the console and type serial, the serial should change. Exit MTA.

Go to \spoof_method_release\cleaning scripts, run clean_mta.bat as administrator.
Go to \spoof_method_release\cleaning scripts, run clear_temp_data.bat as administrator.
Go to \spoof_method_release\cleaning scripts, run emul_temp_data.bat as administrator.
Go to the main GTA SA folder, copy the file spoof_method_release\cleaning scripts\randomizer_gta_installation.bat into the main folder
 Run the script as administrator and delete it.

Run YogaDNS, configuration > rules > disable all rules for MTA and click OK.
 Install MTA again, run the VPN, and you can safely enter servers on the internet.

By: thorus.m47k0j3bc4[/CODE]
[/SPOILER]