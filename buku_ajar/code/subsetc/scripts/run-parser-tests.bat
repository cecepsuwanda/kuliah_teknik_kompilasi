@echo off
setlocal
pushd "%~dp0.."
set FAILED=0

if not exist build\parser.exe (
  echo Parser belum dibangun. Jalankan build.bat terlebih dahulu.
  popd
  exit /b 1
)

build\parser.exe tests\parser\valid.sc >nul 2>nul
if errorlevel 1 (
  echo GAGAL: valid.sc seharusnya diterima
  set FAILED=1
) else (
  echo OK: valid.sc
)

build\parser.exe tests\parser\invalid.sc >nul 2>nul
if errorlevel 1 (
  echo OK: invalid.sc ditolak
) else (
  echo GAGAL: invalid.sc seharusnya ditolak
  set FAILED=1
)

build\parser.exe tests\parser\expr.sc >nul 2>nul
if errorlevel 1 (
  echo GAGAL: expr.sc seharusnya diterima
  set FAILED=1
) else (
  echo OK: expr.sc
)

if %FAILED%==1 (
  echo ADA TES PARSER YANG GAGAL
  popd
  exit /b 1
)
echo SEMUA TES PARSER LULUS
popd
exit /b 0
