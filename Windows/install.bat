
# link everything
SET mypath=%~dp0
mklink /D  %USERPROFILE%\Documents\WindowsPowerShell %mypath:~0, -1%\WindowsPowerShell
pause 