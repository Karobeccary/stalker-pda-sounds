@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows-scheme.ps1" -Remove
echo.
pause
