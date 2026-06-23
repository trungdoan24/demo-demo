@echo off
setlocal enabledelayedexpansion
title CYBER CONTROL SYSTEM

:: ===== COLORS =====
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

set GREEN=%ESC%[32m
set CYAN=%ESC%[36m
set RED=%ESC%[31m
set YELLOW=%ESC%[33m
set RESET=%ESC%[0m

:: ================= MAIN LOOP =================
:main
cls
call :ui

echo.
echo %CYAN%[1] Deploy System
echo [2] Rollback System
echo [3] Exit%RESET%
echo.

set /p cmd=">> "

if "%cmd%"=="1" goto deploy
if "%cmd%"=="2" goto rollback
if "%cmd%"=="3" exit

goto main


:: ================= UI =================
:ui
echo %CYAN%====================================================
echo           🚀 CYBER DEPLOY CONTROL PANEL
echo ====================================================%RESET%

for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set branch=%%b
if "%branch%"=="" set branch=NO-GIT

for %%r in ("%cd%") do set repo=%%~nxr

echo.
echo %YELLOW% STATUS SYSTEM%RESET%
echo   🌿 Branch : %GREEN%%branch%%RESET%
echo   📁 Repo   : %repo%
echo   ⚡ Mode   : FORCE DEPLOY
echo   💾 Backup : ENABLED
echo %YELLOW%----------------------------------------------------%RESET%
goto :eof


:: ================= DEPLOY (HIDDEN COMMANDS) =================
:deploy
cls
echo %CYAN%Deploying system...%RESET%
timeout /t 1 >nul

:: backup commit
for /f "delims=" %%h in ('git rev-parse HEAD 2^>nul') do set lastcommit=%%h
echo %lastcommit% > .last_backup

echo %CYAN%Processing files...%RESET%
git add . >nul 2>&1

echo %CYAN%Saving commit...%RESET%
git commit -m "auto deploy" >nul 2>&1

echo %CYAN%Syncing server...%RESET%
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set branch=%%b
git push --force origin %branch% >nul 2>&1

echo.
echo %GREEN%✔ DEPLOY COMPLETE%RESET%
timeout /t 2 >nul
goto main


:: ================= ROLLBACK =================
:rollback
cls
echo %YELLOW%Rolling back system...%RESET%

if not exist .last_backup (
    echo %RED%No backup found%RESET%
    timeout /t 2 >nul
    goto main
)

set /p confirm=Confirm rollback (y/n): 
if /i not "%confirm%"=="y" goto main

set /p hash=<.last_backup

git reset --hard %hash% >nul 2>&1
git push --force origin HEAD >nul 2>&1

echo %GREEN%✔ ROLLBACK COMPLETE%RESET%
timeout /t 2 >nul
goto main