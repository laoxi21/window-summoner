@echo off
chcp 65001 >nul

REM Read version from version.txt
for /f "delims=" %%a in (data\version.txt) do set version=%%a

REM Check if Ahk2Exe exists
if exist "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" (
    set AHK2EXE="C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
) else if exist "C:\Program Files (x86)\AutoHotkey\Compiler\Ahk2Exe.exe" (
    set AHK2EXE="C:\Program Files (x86)\AutoHotkey\Compiler\Ahk2Exe.exe"
) else (
    echo Ahk2Exe not found. Please install AutoHotkey from https://www.autohotkey.com/
    exit /b 1
)

REM Find AutoHotkey binary
if exist "C:\Program Files\AutoHotkey\ahk_h v2.1-alpha.7\AutoHotkey64.exe" (
    set AHKBIN="C:\Program Files\AutoHotkey\ahk_h v2.1-alpha.7\AutoHotkey64.exe"
) else (
    REM Try to find any AutoHotkey64.exe
    for /r "C:\Program Files\AutoHotkey" %%i in (AutoHotkey64.exe) do (
        if exist "%%i" set AHKBIN="%%i"
    )
    if not defined AHKBIN (
        echo AutoHotkey64.exe not found. Please install AutoHotkey v2.
        exit /b 1
    )
)

REM Create version directory in release
if not exist "release" mkdir release
rmdir /s /q "release\%version%" 2>nul
mkdir "release\%version%"
mkdir "release\%version%\data"

REM Copy data folder (excluding config.json)
xcopy data "release\%version%\data\" /e /i /y >nul
del "release\%version%\data\config.json" 2>nul

REM Compile
%AHK2EXE% /in "app.ahk" /icon "data\icon.ico" /out "release\%version%\window-summoner.exe" /bin %AHKBIN%

if exist "release\%version%\window-summoner.exe" (
    echo.
    echo Build successful: release\%version%\window-summoner.exe
) else (
    echo.
    echo Build FAILED.
    exit /b 1
)

REM Optional: compress to zip using Bandizip if available
if exist "C:\Program Files\Bandizip\Bandizip.exe" (
    "C:\Program Files\Bandizip\Bandizip.exe" c -y -r "release\%version%.zip" "release\%version%"
    if exist "release\%version%.zip" (
        echo Zip created: release\%version%.zip
    )
) else (
    echo.
    echo Bandizip not found. Skipping zip.
    echo To enable zip, install Bandizip from https://en.bandisoft.com/bandizip/
)
