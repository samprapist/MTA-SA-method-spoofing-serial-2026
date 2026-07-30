@echo off
setlocal enabledelayedexpansion
title Comprehensive System and DNS Memory Cleaning

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Run this script AS ADMINISTRATOR ^(Right click -> Run as administrator^).
    pause
    exit /b
)

:: --- WARNING AND CHOICE SECTION ---
cls
echo =======================================================================
echo                           !!! WARNING !!!
echo =======================================================================
echo  This script will perform a deep cleaning of system temporary files.
echo.
echo  Before we begin, decide on cleaning LOGS and ERROR DUMPS (DMP).
echo  If your PC has crashed recently, these files might be needed 
echo  by a technician or yourself to diagnose the cause of the failure (BSOD).
echo =======================================================================
echo.


pause
cls

echo ========================================================
echo   STARTING FILE AND NETWORK HISTORY CLEANING
echo ========================================================
echo.

echo [1/7] Cleaning user Temp folder...
del /f /q /s "%TEMP%\*" >nul 2>&1
for /d %%p in ("%TEMP%\*") do rmdir /s /q "%%p" >nul 2>&1

echo [2/7] Cleaning general system Temp folder...
del /f /q /s "%SystemRoot%\Temp\*" >nul 2>&1
for /d %%p in ("%SystemRoot%\Temp\*") do rmdir /s /q "%%p" >nul 2>&1

echo [3/7] Cleaning updates and installers cache...
del /f /q /s "%SystemRoot%\ccmcache\*" >nul 2>&1
del /f /q /s "%SystemRoot%\msdownld.tmp\*" >nul 2>&1
for /d %%p in ("%SystemRoot%\msdownld.tmp\*") do rmdir /s /q "%%p" >nul 2>&1

echo [4/7] Cleaning Windows Update cache (SoftwareDistribution)...
net stop wuauserv >nul 2>&1
del /f /q /s "%SystemRoot%\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%p in ("%SystemRoot%\SoftwareDistribution\Download\*") do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1




echo [7/7] Cleaning DNS cache and resetting connections...
ipconfig /flushdns >nul 2>&1
ipconfig /registerdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1

echo [5/7] Cleaning logs and error reports (Forced file zeroing)...

    :: 1. Defining the path to the NSudo Launcher\x64 subfolder relative to the script location
    set "NSUDO_DIR=%~dp0NSudo Launcher\x64"
    set "NSUDO_PATH="

    if exist "%NSUDO_DIR%\NSudoLC.exe" (
        set "NSUDO_PATH=%NSUDO_DIR%\NSudoLC.exe"
    ) else if exist "%NSUDO_DIR%\NSudoLG.exe" (
        set "NSUDO_PATH=%NSUDO_DIR%\NSudoLG.exe"
    )

    :: 2. If NSudo is found, we zero out the content of locked log files
    if defined NSUDO_PATH (
        echo [INFO] NSudo found. Zeroing locked log streams...
        
        :: Stopping known diagnostic sessions
        "%NSUDO_PATH%" -U:T -P:E cmd /c "logman stop WaaSMedicTrace -ets >nul 2>&1"
        "%NSUDO_PATH%" -U:T -P:E cmd /c "net stop TrustedInstaller >nul 2>&1"
        
        :: Zeroing the stubborn CBS.log
        "%NSUDO_PATH%" -U:T -P:E cmd /c "break > C:\Windows\Logs\CBS\CBS.log" >nul 2>&1
        
        :: Aggressively zeroing and removing waasmedic folder contents via PowerShell as TI
        "%NSUDO_PATH%" -U:T -P:E powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem 'C:\Windows\Logs\waasmedic\*' -Include *.etl,*.log -ErrorAction SilentlyContinue | ForEach-Object { try { Clear-Content $_.FullName -Force -ErrorAction Stop; Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue } catch { } }" >nul 2>&1
    ) else (
        echo [WARNING] NSudo not found.
    )

    :: 3. Smart cleaning of remaining files (ignores phantom files removed by the kernel)
    set "REPORT=%USERPROFILE%\Desktop\blocked_files.txt"
    if exist "%REPORT%" del "%REPORT%"
    set "TARGETS='%windir%\Logs', '%LOCALAPPDATA%\CrashDumps', '%ProgramData%\Microsoft\Windows\WER'"

    powershell -NoProfile -ExecutionPolicy Bypass -Command "$targets = @(%TARGETS%); $blocked = @(); foreach ($folder in $targets) { if (Test-Path $folder) { Get-ChildItem -Path $folder -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $path = $_.FullName; try { if (Test-Path $path) { Remove-Item $path -Force -ErrorAction Stop } } catch { if (Test-Path $path) { try { $len = (Get-Item $path).Length; if ($len -gt 0) { $blocked += \"$path - LOCKED\" } } catch { $blocked += \"$path - LOCKED\" } } } } } }; if ($blocked.Count -gt 0) { $blocked | Out-File -FilePath '%REPORT%' -Encoding UTF8 }"

    if exist "%REPORT%" (echo [INFO] Done. Check the blocked_files.txt file on the Desktop.) else (echo [INFO] Success! All logs and dmp files have been removed.)

)
echo.

echo.
echo ========================================================
echo   CLEANING FINISHED!
echo   Temporary files and DNS history have been removed.
echo ========================================================
pause