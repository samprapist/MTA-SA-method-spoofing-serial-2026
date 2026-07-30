@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Run this script AS ADMINISTRATOR!
    pause
    exit /b
)

echo ========================================================
echo   NATURAL NOISE GENERATOR AND ACTIVITY EMULATION
echo ========================================================
echo The script will generate random logs, temporary files, prefetch
echo entries, and fill the DNS cache with natural domains.
echo.
pause

:: Arrays with application names for simulation
set "app[0]=Discord"
set "app[1]=Spotify"
set "app[2]=WinRAR"
set "app[3]=VLC"
set "app[4]=Steam"
set "app[5]=Google\Chrome"
set "app[6]=GIMP 2"
set "app[7]=Notepad++"
set "apps_count=8"

echo [1/4] Creating random structural folders and temporary files...

:: Generating a random number of operations (from 10 to 20)
set /a "loops=%RANDOM% %% 11 + 10"

for /l %%i in (1,1,%loops%) do (
    :: Randomly picking an application from the pool
    set /a "r=%RANDOM% %% apps_count"
    for %%v in (!r!) do set "current_app=!app[%%v]!"
    
    :: Randomly generating a file type and unique ID
    set "rand_id=!RANDOM!"
    
    :: 1. Creating junk in AppData\Local and Roaming
    if not exist "%LOCALAPPDATA%\!current_app!" mkdir "%LOCALAPPDATA%\!current_app!" 2>nul
    if not exist "%APPDATA%\!current_app!" mkdir "%APPDATA%\!current_app!" 2>nul
    
    echo Cache data !RANDOM! > "%LOCALAPPDATA%\!current_app!\cache_%%i_!rand_id!.dat" 2>nul
    echo Update log at !TIME! > "%LOCALAPPDATA%\!current_app!\update_!rand_id!.log" 2>nul
    echo [Settings]^nUser=!RANDOM! > "%APPDATA%\!current_app!\config_!rand_id!.cfg" 2>nul
    
    :: 2. Creating junk in Temp
    echo temp_data_!RANDOM! > "%TEMP%\~df!rand_id!.tmp" 2>nul
    echo installer_log_!rand_id! > "%TEMP%\install_!current_app:\=_!_!rand_id!.log" 2>nul
)
echo   -[OK] Generated mock AppData and Temp files.

echo.
echo [2/4] Emulating process activity (Generating BAM entries)...
echo   (This may take a moment because we are emulating brief executions)

:: We create a temporary, harmless executable file in Temp with a modified name
copy /y "%SystemRoot%\System32\ping.exe" "%TEMP%\UpdateRunner.exe" >nul
"%TEMP%\UpdateRunner.exe" 127.0.0.1 -n 2 >nul
del /f /q "%TEMP%\UpdateRunner.exe" >nul

copy /y "%SystemRoot%\System32\timeout.exe" "%TEMP%\winrar_installer.exe" >nul
"%TEMP%\winrar_installer.exe" 2 >nul
del /f /q "%TEMP%\winrar_installer.exe" >nul

copy /y "%SystemRoot%\System32\ping.exe" "%TEMP%\discord_setup.exe" >nul
"%TEMP%\discord_setup.exe" 127.0.0.1 -n 2 >nul
del /f /q "%TEMP%\discord_setup.exe" >nul

echo   -[OK] Implemented mock background process calls.

echo.
echo [3/4] Generating natural Windows Prefetch files...
copy /y "%SystemRoot%\System32\werfault.exe" "%TEMP%\WerFault.exe" >nul
"%TEMP%\WerFault.exe" --help >nul 2>&1
del /f /q "%TEMP%\WerFault.exe" >nul

:: We call standard system programs that every user runs
start /b cleanmgr.exe /sagedrun:1 >nul 2>&1
start /b msconfig.exe /? >nul 2>&1

echo   -[OK] Generated fresh noise in the Prefetch directory.

echo.
echo [4/4] Emulating network history (Generating DNS Cache entries)...
echo   (Sending queries to popular domains...)

:: List of common and safe domains that every system and user visits
set "domains=google.com www.google.com facebook.com youtube.com microsoft.com windowsupdate.com github.com discord.com spotify.com live.com netflix.com wikipedia.org cdn.discordapp.com accounts.google.com twitch.tv steampowered.com"

:: Loop querying each domain using nslookup (fast and doesn't send unnecessary ICMP packets)
for %%d in (%domains%) do (
    nslookup %%d >nul 2>&1
)

echo   -[OK] DNS Cache has been naturally populated with entries.
echo.
echo ========================================================
echo   PROCESS FINISHED. SYSTEM LOOKS NATURALLY USED.
echo ========================================================
pause