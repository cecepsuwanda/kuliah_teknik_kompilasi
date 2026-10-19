@echo off
setlocal
pushd "%~dp0.."
if not exist build\main.log (
  echo Log tidak ditemukan. Jalankan build-all.bat terlebih dahulu.
  popd
  exit /b 1
)
echo === Overfull / Underfull ===
findstr /c:"Overfull" /c:"Underfull" build\main.log
echo.
echo === Undefined references / citations ===
findstr /i /c:"undefined" build\main.log
echo.
echo === Warnings ===
findstr /c:"Warning" build\main.log
echo.
echo === Selesai ===
popd
exit /b 0
