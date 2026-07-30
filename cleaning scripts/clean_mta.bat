@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script must be run AS ADMINISTRATOR!
    echo Right-click the file and select 'Run as administrator'.
    echo.
    pause
    exit /b
)

echo WARNING: This will remove all settings, registry entries, and MTA files (including hidden ones).
echo Please close MTA, the launcher, and the game before continuing.
pause

echo.
echo [1/5] Removing registry entries...
reg delete "HKLM\SOFTWARE\WOW6432Node\Multi Theft Auto: San Andreas All" /f 2>nul
reg delete "HKLM\SOFTWARE\Multi Theft Auto: San Andreas All" /f 2>nul
reg delete "HKCU\SOFTWARE\Multi Theft Auto: San Andreas All" /f 2>nul
reg delete "HKCU\SOFTWARE\WOW6432Node\Multi Theft Auto: San Andreas All" /f 2>nul
reg delete "HKCR\mtasa" /f 2>nul
reg delete "HKLM\SOFTWARE\Classes\mtasa" /f 2>nul
reg delete "HKCU\SOFTWARE\Classes\mtasa" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MTA San Andreas 1.6" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MTA San Andreas 1.6" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MTA:SA 1.6" /f 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MTA San Andreas 1.6" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID2\{871C5380-42A0-1069-A2EA-08002B30309D}\ShellFolder" /f 2>nul

echo.
echo [1/5] Removing registry entries monitored by MTA/FairPlay (anti-tamper) and error logs...
sc stop FairplayKD >nul 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Services\FairplayKD" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\FairplayKD" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\gta_sa.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\Multi Theft Auto.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Multi Theft Auto.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gta_sa.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\proxy_sa.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Multi Theft Auto.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gta_sa.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\proxy_sa.exe" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CLSID2\{871C5380-42A0-1069-A2EA-08002B30309D}" /f 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CLSID2\{871C5380-42A0-1069-A2EA-08002B30309D}" /f 2>nul

echo.
echo [1/5] Dynamically clearing file activity traces (BAM and PCA)...
:: Dynamic removal from BAM for all users instead of one hardcoded SID
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings' | ForEach-Object { $path = $_.Name.Replace('HKEY_LOCAL_MACHINE', 'HKLM'); Get-ItemProperty $_.PSPath | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -match 'MTA' -or $_.Name -match 'gta_sa' -or $_.Name -match 'mtasa' } | ForEach-Object { Remove-ItemProperty -Path $path -Name $_.Name -Force -ErrorAction SilentlyContinue } }"
:: Cleaning the Program Compatibility Assistant (PCA) store
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "*MTA*" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "*gta_sa*" /f 2>nul

echo.
echo [2/5] Removing hidden/system attributes from MTA folders...
for %%D in (
    "%ProgramFiles(x86)%\MTA San Andreas 1.6"
    "%ProgramFiles%\MTA San Andreas 1.6"
    "%LOCALAPPDATA%\MTA San Andreas 1.6"
    "%APPDATA%\MTA San Andreas 1.6"
    "%USERPROFILE%\Documents\MTA San Andreas 1.6"
    "%ProgramData%\MTA San Andreas 1.6"
    "%ProgramData%\MTA San Andreas All"
    "%LOCALAPPDATA%\VirtualStore\Program Files (x86)\MTA San Andreas 1.6"
    "%LOCALAPPDATA%\VirtualStore\Program Files\MTA San Andreas 1.6"
    "%TEMP%\MTA"
) do (
    if exist "%%~D" (
        echo   - clearing attributes in: %%~D
        attrib -h -s -r "%%~D" /s /d 2>nul
        attrib -h -s -r "%%~D\*" /s 2>nul
    )
)

echo.
echo [3/5] Removing temporary installer folders, files, and DirectX data...
for %%D in (
    "%ProgramFiles(x86)%\MTA San Andreas 1.6"
    "%ProgramFiles%\MTA San Andreas 1.6"
    "%LOCALAPPDATA%\MTA San Andreas 1.6"
    "%APPDATA%\MTA San Andreas 1.6"
    "%USERPROFILE%\Documents\MTA San Andreas 1.6"
    "%ProgramData%\MTA San Andreas 1.6"
    "%ProgramData%\MTA San Andreas All"
    "%LOCALAPPDATA%\VirtualStore\Program Files (x86)\MTA San Andreas 1.6"
    "%LOCALAPPDATA%\VirtualStore\Program Files\MTA San Andreas 1.6"
    "%TEMP%\MTA"
    "C:\Windows\msdownld.tmp"
) do (
    if exist "%%~D" (
        echo   - removing: %%~D
        rmdir /s /q "%%~D" 2>nul
    )
)

:: Cleaning up leftover nsaXXXX.tmp files in user temp and INetCache
del /f /q /s "%TEMP%\nsa*.tmp" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.cab" >nul 2>&1

echo.
echo [4/5] Cleaning Prefetch files (Windows application launch logs)...
del /f /q "%SystemRoot%\Prefetch\MULTITHEFT*" >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\MTA*" >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\GTA_SA*" >nul 2>&1

echo.
echo [5/5] Removing hidden NTFS streams (ADS) NT/NT2 from APPDATA...
echo   (streams only, NOT the entire Roaming folder)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$roaming=$env:APPDATA; $src='[DllImport(\"kernel32.dll\", CharSet=CharSet.Unicode, SetLastError=true)] public static extern bool DeleteFile(string lpFileName);'; $t=Add-Type -MemberDefinition $src -Name 'Kernel32' -Namespace 'Win32' -PassThru -ErrorAction SilentlyContinue; foreach ($s in @('NT','NT2')) { $p=$roaming+':'+$s; if ($t -and $t::DeleteFile($p)) { Write-Host ('  Deleted '+$p) } else { Write-Host ('  Not found or failed: '+$p) } }"

echo.
echo Done. MTA traces have been completely cleared. You can now perform a clean installation.
pause