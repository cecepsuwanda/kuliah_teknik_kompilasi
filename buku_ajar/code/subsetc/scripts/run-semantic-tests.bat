@echo off
setlocal
pushd "%~dp0.."
set FAILED=0

if not exist build\scc_semantic.exe (
  echo Driver semantik belum dibangun. Jalankan build.bat.
  popd
  exit /b 1
)

build\scc_semantic.exe tests\semantic\valid.sc >nul 2>nul
if errorlevel 1 (
  echo GAGAL: valid.sc seharusnya diterima
  set FAILED=1
) else (
  echo OK: valid.sc
)

for %%F in (undeclared redeclared typemismatch) do (
  build\scc_semantic.exe "tests\semantic\%%F.sc" >nul 2>nul
  if errorlevel 1 (
    echo OK: %%F.sc ditolak
  ) else (
    echo GAGAL: %%F.sc seharusnya ditolak
    set FAILED=1
  )
)

if %FAILED%==1 (
  echo ADA TES SEMANTIK YANG GAGAL
  popd
  exit /b 1
)
echo SEMUA TES SEMANTIK LULUS
popd
exit /b 0
