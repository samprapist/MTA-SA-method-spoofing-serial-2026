@echo off
setlocal enabledelayedexpansion


set "SCRIPT_DIR=%~dp0"

set "GTA_DIR=!SCRIPT_DIR:~0,-1!"
:: ========================================================


net session >nul 2>&1
if %errorLevel% neq 0 (
    echo run by admin.
    pause
    exit /b
)


if not exist "!GTA_DIR!\gta_sa.exe" (
    echo [warning] not found gta_sa.exe!
    echo Location: !GTA_DIR!
    echo Make sure the script is located DIRECTLY in the game's main folder.
    echo.
    set /p "choice=You wanna start? [T/N]: "
    if /i "!choice!" neq "T" exit /b
)

echo Cleaning start, generate random metadata for GTA SA...
echo location: !GTA_DIR!
echo.

echo [1/5] Deleting old Windows registry entries...
reg delete "HKLM\SOFTWARE\Rockstar Games\Grand Theft Auto: San Andreas" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Rockstar Games\Grand Theft Auto: San Andreas" /f 2>nul
reg delete "HKCU\Software\Rockstar Games\Grand Theft Auto: San Andreas" /f 2>nul
reg delete "HKCU\Software\WOW6432Node\Rockstar Games\Grand Theft Auto: San Andreas" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{91EEAC4F-AB55-46D0-9A74-55FA3E63DA95}" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{91EEAC4F-AB55-46D0-9A74-55FA3E63DA95}" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "*gta_sa.exe*" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "*gta_sa.exe*" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "*gta_sa.exe*" /f 2>nul
reg delete "HKCU\Software\Microsoft\DirectPlay\Service Providers\Internet TCP/IP Connection For DirectPlay" /v "*gta_sa*" /f 2>nul

echo [2/5] Deleting old configuration and log files...
del /f /q /s "!GTA_DIR!\gta_sa.set" >nul 2>&1
del /f /q /s "!GTA_DIR!\*.log" >nul 2>&1
del /f /q /s "!GTA_DIR!\*.bak" >nul 2>&1
del /f /q /s "!GTA_DIR!\*.tmp" >nul 2>&1
del /f /q /s "!GTA_DIR!\crashdumps\*" >nul 2>&1

echo [3/5] Resetting file attributes and clearing NTFS streams (ADS)...
attrib -h -s -r "!GTA_DIR!" /s /d >nul 2>&1
attrib -h -s -r "!GTA_DIR!\*" /s >nul 2>&1


set "ENV_GTA_DIR=!GTA_DIR!"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path $env:ENV_GTA_DIR -Recurse | ForEach-Object { Unblock-File -Path $_.FullName; $streams = Get-Item $_.FullName -Stream * | Where-Object { $_.Stream -ne ':$DATA' }; foreach ($s in $streams) { Remove-Item -Path $_.FullName -Stream $s.Stream -Force -ErrorAction SilentlyContinue } }"

echo [4/5] Generating random, unique dates (Timestamps) for each file separately...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path $env:ENV_GTA_DIR -Recurse | ForEach-Object { $randHours = Get-Random -Minimum 0 -Maximum 5; $randMinutes = Get-Random -Minimum 0 -Maximum 60; $randSeconds = Get-Random -Minimum 0 -Maximum 60; $baseDate = (Get-Date '2005-06-10 11:00:00').AddHours($randHours).AddMinutes($randMinutes).AddSeconds($randSeconds); $_.CreationTime = $baseDate; $_.LastWriteTime = $baseDate; $_.LastAccessTime = $baseDate }"

echo [5/5] Installation emulation - generating new, random keys in the Registry..
for /f "delims=" %%a in ('powershell -NoProfile -Command "[guid]::NewGuid().ToString().ToUpper()"') do set "RANDOM_GUID=%%a"

reg add "HKLM\SOFTWARE\WOW6432Node\Rockstar Games\Grand Theft Auto: San Andreas\Settings" /v "InstallationID" /t REG_SZ /d "{%RANDOM_GUID%}" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Rockstar Games\Grand Theft Auto: San Andreas\Settings" /v "Installed" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Rockstar Games\Grand Theft Auto: San Andreas\Settings" /v "Path" /t REG_SZ /d "!GTA_DIR!" /f >nul 2>&1

set /a "RAND_SIZE=%RANDOM% %% 200 + 4600"
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "dt=%%a"
set "TODAY_DATE=%dt:~0,8%"

reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /v "DisplayName" /t REG_SZ /d "Grand Theft Auto: San Andreas" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /v "InstallLocation" /t REG_SZ /d "!GTA_DIR!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /v "DisplayVersion" /t REG_SZ /d "1.00" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /v "Publisher" /t REG_SZ /d "Rockstar Games" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /v "EstimatedSize" /t REG_DWORD /d %RAND_SIZE% /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Grand Theft Auto: San Andreas" /v "InstallDate" /t REG_SZ /d "%TODAY_DATE%" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\DirectPlay\Service Providers\Internet TCP/IP Connection For DirectPlay" /v "Grand Theft Auto: San Andreas" /t REG_BINARY /d 01000000 /f >nul 2>&1

echo.
echo ==============================================================
echo PROCESS SUCCESSFULLY COMPLETED!
echo The script automatically recognized the game folder and secured it.
echo The files have unique, randomized timestamps.
echo The system registry has been updated with fresh, random keys.
echo ========================================================
pause