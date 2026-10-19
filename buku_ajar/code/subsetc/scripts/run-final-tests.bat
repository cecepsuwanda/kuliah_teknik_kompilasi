@echo off
setlocal
pushd "%~dp0.."
set FAILED=0

if not exist build\scc.exe (
  echo CLI final belum dibangun. Jalankan build.bat.
  popd
  exit /b 1
)

build\scc.exe tests\invalid\valid_loop.sc >nul 2>nul
if errorlevel 1 (
  echo GAGAL: valid_loop.sc seharusnya diterima
  set FAILED=1
) else (
  echo OK: valid_loop.sc
)

for %%F in (break_outside continue_outside missing_return) do (
  build\scc.exe "tests\invalid\%%F.sc" >nul 2>nul
  if errorlevel 1 (
    echo OK: %%F.sc ditolak
  ) else (
    echo GAGAL: %%F.sc seharusnya ditolak
    set FAILED=1
  )
)

if %FAILED%==1 (
  echo ADA TES VALIDASI YANG GAGAL
  popd
  exit /b 1
)
echo SEMUA TES VALIDASI LULUS
popd
exit /b 0
