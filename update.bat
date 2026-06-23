@echo off
setlocal enabledelayedexpansion
title CYBER DEPLOY SYSTEM v2

:: ================= COLORS =================
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

set GREEN=%ESC%[32m
set CYAN=%ESC%[36m
set RED=%ESC%[31m
set YELLOW=%ESC%[33m
set RESET=%ESC%[0m

:: ================= MAIN LOOP =================
:main
cls
call :header
call :status

echo.
echo %CYAN%COMMAND CENTER%RESET%
echo   [1] Deploy (FORCE + BACKUP)
echo   [2] Rollback last backup
echo   [3] Exit
echo.

set /p cmd=">> "

if "%cmd%"=="1" goto deploy
if "%cmd%"=="2" goto rollback
if "%cmd%"=="3" exit

echo %RED%Invalid command%RESET%
timeout /t 1 >nul
goto main


:: ================= HEADER =================
:header
echo %CYAN%====================================================
echo           🚀 CYBER DEPLOY SYSTEM v2
echo        FORCE + BACKUP + ROLLBACK READY
echo ====================================================%RESET%
goto :eof


:: ================= STATUS =================
:status
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set branch=%%b
if "%branch%"=="" set branch=no-git

for %%r in ("%cd%") do set repo=%%~nxr

echo.
echo %YELLOW%---------------- SYSTEM STATUS ----------------%RESET%
echo   🌿 Branch : %GREEN%%branch%%RESET%
echo   📁 Repo   : %repo%
echo   ⚡ Mode   : FORCE DEPLOY
echo   💾 Backup : ENABLED
echo %YELLOW%----------------------------------------------%RESET%
goto :eof


:: ================= DEPLOY =================
:deploy
echo.
echo %CYAN%[1] Staging files...%RESET%
git add . >nul

:: ===== backup commit hash =====
for /f "delims=" %%h in ('git rev-parse HEAD') do set lastcommit=%%h
echo %lastcommit% > .last_backup

echo %CYAN%[2] Committing...%RESET%
git commit -m "auto backup + update" >nul

echo %CYAN%[3] FORCE PUSH...%RESET%
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set branch=%%b

git push --force origin %branch% >nul

echo.
echo %GREEN%======================================
echo        DEPLOY SUCCESS (FORCE)
echo   Backup commit: %lastcommit%
echo ======================================%RESET%

pause
goto main


:: ================= ROLLBACK =================
:rollback
echo.
if not exist .last_backup (
    echo %RED%No backup found%RESET%
    pause
    goto main
)

set /p confirm=Rollback to last backup? (y/n): 
if /i not "%confirm%"=="y" goto main

set /p hash=<.last_backup

echo %CYAN%Reverting to %hash%...%RESET%

git reset --hard %hash%
git push --force origin HEAD >nul

echo.
echo %GREEN%ROLLBACK COMPLETE%RESET%
pause
goto main