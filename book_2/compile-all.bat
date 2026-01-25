@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ========================================
REM BUILD SYSTEM BUKU AJAR LATEX
REM ========================================

set "ROOT=%~dp0"
set "CHAPTER_DIR=%ROOT%chapters"
set "OUTPUT_DIR=%ROOT%output"

cd /d "%ROOT%" || exit /b 1

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
if not exist "%CHAPTER_DIR%" (
    echo ERROR: Folder chapters tidak ditemukan.
    pause
    exit /b 1
)

REM =====================================================
REM MENU
REM =====================================================
:menu
cls
echo ========================================
echo    BUKU AJAR TEKNIK KOMPILASI
echo ========================================
echo 1. Compile Buku Lengkap (main.tex)
echo 2. Compile Per-Bab
echo 3. Compile Semua Bab (00-18)
echo 0. Keluar
echo ========================================
set /p choice="Pilih (0-3): "

if "%choice%"=="0" goto end
if "%choice%"=="1" goto compile_book
if "%choice%"=="2" goto compile_one
if "%choice%"=="3" goto compile_all

echo Pilihan tidak valid.
pause
goto menu

REM =====================================================
REM COMPILE BUKU LENGKAP
REM =====================================================
:compile_book
cls
set "FILE=main"

if not exist "%FILE%.tex" (
    echo ERROR: %FILE%.tex tidak ditemukan.
    pause
    goto menu
)

call :compile_latex "%ROOT%" "%FILE%"
call :move_pdf "%ROOT%" "%FILE%"
pause
goto menu

REM =====================================================
REM COMPILE SATU BAB
REM =====================================================
:compile_one
cls
set "bab_choice="
set /p bab_choice="Masukkan nomor bab (0-18) atau q: "

if /i "!bab_choice!"=="q" goto menu

REM validasi angka
echo(!bab_choice! | findstr /r "^[0-9][0-9]*$" >nul || (
    echo Input tidak valid.
    pause
    goto compile_one
)

set /a num=!bab_choice!

if !num! lss 0 goto invalid_input
if !num! gtr 18 goto invalid_input

REM format dua digit
if !num! lss 10 (
    set "bab=0!num!"
) else (
    set "bab=!num!"
)

set "NAME=bab-!bab!"

if not exist "%CHAPTER_DIR%\!NAME!.tex" (
    echo ERROR: !NAME!.tex tidak ditemukan.
    pause
    goto compile_one
)

call :compile_latex "%CHAPTER_DIR%" "!NAME!"
call :move_pdf "%CHAPTER_DIR%" "!NAME!"
pause
goto compile_one

:invalid_input
echo Input harus angka 0-18.
pause
goto compile_one

REM =====================================================
REM COMPILE SEMUA BAB
REM =====================================================
:compile_all
cls
set SUCCESS=0
set FAIL=0

for %%i in (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18) do (
    set "NAME=bab-%%i"
    if exist "%CHAPTER_DIR%\!NAME!.tex" (
        echo ========================================
        echo Compiling !NAME!
        call :compile_latex "%CHAPTER_DIR%" "!NAME!"
        if exist "%CHAPTER_DIR%\!NAME!.pdf" (
            call :move_pdf "%CHAPTER_DIR%" "!NAME!"
            set /a SUCCESS+=1
        ) else (
            echo ERROR: !NAME! gagal dikompilasi
            set /a FAIL+=1
        )
    ) else (
        echo SKIP: !NAME!.tex tidak ditemukan
    )
)

echo ========================================
echo SELESAI
echo Berhasil: !SUCCESS!
echo Gagal   : !FAIL!
echo Output  : %OUTPUT_DIR%
echo ========================================
pause
goto menu

REM =====================================================
REM SUBROUTINE: COMPILE LATEX
REM =====================================================
:compile_latex
set "DIR=%~1"
set "BASE=%~2"

pushd "%DIR%" || exit /b 1

echo ----------------------------------------
echo Compiling %BASE%.tex

echo [PASS 1] pdflatex...
pdflatex -interaction=nonstopmode "%BASE%.tex"

if exist "%BASE%.aux" (
    echo [BIBER] running...
    biber "%BASE%"
)

echo [PASS 2] pdflatex...
pdflatex -interaction=nonstopmode "%BASE%.tex"

echo [PASS 3] pdflatex...
pdflatex -interaction=nonstopmode "%BASE%.tex"

echo [PASS 4] pdflatex...
pdflatex -interaction=nonstopmode "%BASE%.tex"

call :cleanup "%BASE%"

popd
exit /b 0

REM =====================================================
REM SUBROUTINE: MOVE PDF
REM =====================================================
:move_pdf
set "DIR=%~1"
set "BASE=%~2"

if exist "%DIR%\%BASE%.pdf" (
    move /Y "%DIR%\%BASE%.pdf" "%OUTPUT_DIR%\%BASE%.pdf" >nul
    echo OK: %BASE%.pdf -> output
) else (
    echo WARNING: %BASE%.pdf tidak ditemukan
)
exit /b 0

REM =====================================================
REM SUBROUTINE: CLEANUP FILE TEMP
REM =====================================================
:cleanup
set "BASE=%~1"
del /Q "%BASE%.aux" "%BASE%.log" "%BASE%.out" "%BASE%.toc" "%BASE%.lof" "%BASE%.lot" ^
       "%BASE%.synctex.gz" "%BASE%.fdb_latexmk" "%BASE%.fls" "%BASE%.nav" "%BASE%.snm" "%BASE%.vrb" ^
       "%BASE%.bbl" "%BASE%.blg" "%BASE%.bcf" "%BASE%.run.xml" 2>nul
exit /b 0

:end
endlocal
exit /b 0
