@echo off
setlocal enabledelayedexpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
set "random_string="
for /L %%i in (1,1,7) do (
    set /a "rand_idx=!random! %% 36"
    for %%j in (!rand_idx!) do set "random_string=!random_string!!chars:~%%j,1!"
)
set "computer_name=DESKTOP-!random_string!"
echo !computer_name!
pause
endlocal
pause