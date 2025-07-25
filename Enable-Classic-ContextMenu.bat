@echo off
title Windows 11 Context Menu Fix
color 0B

:: ================================================================================
:: Windows 11 Classic Context Menu Restore Script
:: ================================================================================
:: Description: Restores the classic right-click context menu in Windows 11
:: Date: July 2025
:: ================================================================================

echo.
echo ================================================================================
echo                    Windows 11 Classic Context Menu Restore
echo ================================================================================
echo.
echo This script will restore the classic Windows right-click context menu
echo by modifying the Windows registry and restarting Windows Explorer.
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
:: Registry Modification Section
:: ================================================================================
:: Source: https://windowsreport.com/windows-11-right-click-show-all-options/
:: Registry Key: Disables Windows 11 simplified context menu handler

echo Applying registry modification to restore classic context menu...
echo Registry Key: HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32
echo.

REM Create backup of current registry state (optional safety measure)
echo Creating registry backup...
REM Generate timestamp for unique filename
for /f "tokens=1-3 delims=:." %%a in ('echo %time%') do set timestamp=%%a%%b%%c
set timestamp=%timestamp: =0%
reg export "HKCU\Software\Classes\CLSID" "%temp%\context_menu_backup_%date:~-4,4%_%date:~-10,2%_%date:~-7,2%_%timestamp%.reg" >nul 2>&1
if %errorlevel% EQU 0 (
    echo Registry backup created successfully at: %temp%\context_menu_backup_%date:~-4,4%_%date:~-10,2%_%date:~-7,2%_%timestamp%.reg
) else (
    echo Warning: Could not create registry backup.
)
echo.

REM Apply the registry modification
echo Modifying registry...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /d "" /f

if %errorlevel% EQU 0 (
    echo Registry modification successful!
) else (
    echo Error: Registry modification failed!
    echo Please ensure you have the necessary permissions.
    pause
    exit /b 1
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
echo The classic Windows context menu has been restored.
echo You may need to restart any open applications to see the changes.
echo.
echo To reverse this change, delete the following registry key:
echo HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}
echo.
echo Press any key to exit...
pause >nul
exit /b 0