@echo off
for /f "delims=" %%i in ('schtasks /run /tn "Test"') do Set VrTemp=%%i

echo %VrTemp%
set "StrCmp=Op�ration r�ussi"
if not x%VrTemp:"%StrCmp%"=%==x%VrTemp% echo It contains %StrCmp%

