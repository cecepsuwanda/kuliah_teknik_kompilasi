@echo off
setlocal enabledelayedexpansion
set FAILED=0
for %%i in (01 02 03 04 05 06 07 09 10 11 12 13 14 15) do (
  call "%~dp0build-pertemuan.bat" %%i
  if errorlevel 1 set FAILED=1
)
if %FAILED%==1 (
  echo ADA PERTEMUAN YANG GAGAL
  exit /b 1
)
echo SEMUA PERTEMUAN OK
exit /b 0
