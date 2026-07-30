
echo [1/4] Removing master configuration keys...
reg delete "HKLM\SOFTWARE\Rockstar Games\GTA San Andreas\Installation" /v "EXE Path" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Rockstar Games\GTA San Andreas\Installation" /v "EXE Path" /f >nul 2>&1
reg delete "HKCU\Software\SAMP" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\SAMP" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\SAMP" /f >nul 2>&1



echo [2/4] Deleting uninstaller entries...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SA-MP" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SA-MP" /f >nul 2>&1


echo [3/4] Removing network protocol bindings (samp://)...
reg delete "HKCR\samp" /f >nul 2>&1
reg delete "HKCU\Software\Classes\samp" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\samp" /f >nul 2>&1


echo [4/4] Clearing traces in the system (AppCompatFlags)...
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "*samp.exe*" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "*samp.exe*" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "*samp.exe*" /f >nul 2>&1