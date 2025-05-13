@echo off
pushd %~dp0
"..\..\compiler\fteqcc64.exe"

echo.
choice /M "Run the game?"
if errorlevel 2 goto skip
"..\..\fteqw64.exe" -basedir ..\..\

:skip
popd
pause