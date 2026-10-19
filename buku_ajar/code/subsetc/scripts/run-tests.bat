@echo off
setlocal
pushd "%~dp0.."
set FAILED=0

if not exist build\lexer.exe (
  echo Lexer belum dibangun. Jalankan build.bat terlebih dahulu.
  popd
  exit /b 1
)

for %%F in (tests\lexer\*.sc) do (
  echo [lexer] %%~nF
  build\lexer.exe "%%F" > "tests\lexer\%%~nF.out" 2> "tests\lexer\%%~nF.err"
  fc /b "tests\lexer\%%~nF.expected" "tests\lexer\%%~nF.out" >nul
  if errorlevel 1 (
    echo   GAGAL: keluaran berbeda dari %%F.expected
    set FAILED=1
  ) else (
    echo   OK
  )
)

if %FAILED%==1 (
  echo ADA TES YANG GAGAL
  popd
  exit /b 1
)
echo SEMUA TES LEXER LULUS
popd
exit /b 0
