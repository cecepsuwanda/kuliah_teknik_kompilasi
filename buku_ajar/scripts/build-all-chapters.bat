@echo off
setlocal enabledelayedexpansion
set FAILED=0
for /l %%i in (1,1,17) do (
  set NUM=0%%i
  set NUM=!NUM:~-2!
  if exist "%~dp0..\chapters\!NUM!\chapter.tex" (
    call "%~dp0build-chapter.bat" !NUM!
    if errorlevel 1 set FAILED=1
  )
)
if %FAILED%==1 (
  echo ADA BAB YANG GAGAL
  exit /b 1
)
echo SEMUA BAB OK
exit /b 0
