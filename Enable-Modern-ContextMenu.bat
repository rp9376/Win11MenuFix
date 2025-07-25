@echo off
title Windows 11 Modern Context Menu Restore
color 0E

:: ================================================================================
:: Windows 11 Modern Context Menu Restore Script
:: ================================================================================
:: Description: Restores the modern simplified right-click context menu in Windows 11
:: Date: July 2025
:: Companion script to: Win11-Classic-ContextMenu-Restore.bat
:: ================================================================================

echo.
echo ================================================================================
echo                   Windows 11 Modern Context Menu Restore
echo ================================================================================
echo.
echo This script will restore the modern Windows 11 simplified context menu
echo by removing the registry modification and restarting Windows Explorer.
echo.
echo This will undo the changes made by the Classic Context Menu Restore script.
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul
echo.

:: BatchGotAdmin - Request administrator privileges if needed
:: Source: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
echo Checking for administrator privileges...

REM Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM If error flag set, we do not have admin privileges
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    echo.
    goto UACPrompt
) else ( 
    echo Administrator privileges confirmed.
    echo.
    goto gotAdmin 
)

:UACPrompt
    echo Creating UAC elevation script...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    REM Script will restart with admin privileges
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: ================================================================================
:: Registry Restoration Section
:: ================================================================================
:: This removes the registry key that was added to disable Windows 11 context menu

echo Checking if classic context menu modification exists...
reg query "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" >nul 2>&1

if %errorlevel% EQU 0 (
    echo Classic context menu modification detected.
    echo Proceeding with restoration...
    echo.
) else (
    echo No classic context menu modification found.
    echo The modern context menu may already be active.
    echo.
    echo Press any key to continue anyway or Ctrl+C to cancel...
    pause >nul
    echo.
)

REM Create backup before removal (safety measure)
echo Creating registry backup before restoration...
REM Generate timestamp for unique filename
for /f "tokens=1-3 delims=:." %%a in ('echo %time%') do set timestamp=%%a%%b%%c
set timestamp=%timestamp: =0%
reg export "HKCU\Software\Classes\CLSID" "%temp%\context_menu_restore_backup_%date:~-4,4%_%date:~-10,2%_%date:~-7,2%_%timestamp%.reg" >nul 2>&1
if %errorlevel% EQU 0 (
    echo Registry backup created successfully at: %temp%\context_menu_restore_backup_%date:~-4,4%_%date:~-10,2%_%date:~-7,2%_%timestamp%.reg
) else (
    echo Warning: Could not create registry backup.
)
echo.

REM Remove the registry modification
echo Removing classic context menu registry modification...
echo Registry Key: HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}
echo.

reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

if %errorlevel% EQU 0 (
    echo Registry modification removal successful!
    echo The modern Windows 11 context menu has been restored.
) else (
    echo Warning: Registry key may not have existed or could not be removed.
    echo This might mean the modern context menu is already active.
)
echo.

echo Restarting Windows Explorer to apply changes...
echo Warning: This will close all open File Explorer windows.
echo.
timeout /t 3 /nobreak >nul

REM More graceful Explorer restart
taskkill /F /IM explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe

echo.
echo ================================================================================
echo                              Operation Complete!
echo ================================================================================
echo.
echo The modern Windows 11 simplified context menu has been restored.
echo You should now see the simplified right-click menu with "Show more options".
echo.
echo You may need to restart any open applications to see the changes.
echo.
echo To switch back to the classic menu, run:
echo Win11-Classic-ContextMenu-Restore.bat
echo.
echo Press any key to exit...
pause >nul
exit /b 0
