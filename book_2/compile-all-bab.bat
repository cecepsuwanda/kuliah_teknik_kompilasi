@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT=%~dp0"
set "CHAPTER_DIR=%ROOT%chapters"
set "OUTPUT_DIR=%ROOT%output"

cd /d "%ROOT%"
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:menu
cls
echo ========================================
echo    KOMPILASI SATU BAB KE PDF
echo ========================================
echo.
echo Pilih bab yang ingin dikompilasi:
echo.

REM Tampilkan menu
set "n=0"
for /l %%i in (0,1,18) do (
    set /a n+=1
    if %%i lss 10 (
        set "bab=0%%i"
    ) else (
        set "bab=%%i"
    )
    echo   [!n!] Bab !bab!
)

echo.
echo   [0] Keluar
echo.
echo ========================================
set /p pilihan="Pilih nomor: "

if "%pilihan%"=="" goto menu
if "%pilihan%"=="0" exit /b 0

REM Validasi dan konversi
set /a num=%pilihan% 2>nul
if errorlevel 1 goto menu
if %num% lss 1 goto menu
if %num% gtr 19 goto menu

REM Konversi ke nomor bab
set /a bab_num=%num%-1
if %bab_num% lss 10 (
    set "bab=0%bab_num%"
) else (
    set "bab=%bab_num%"
)

set "NAME=bab-!bab!"
if not exist "%CHAPTER_DIR%\!NAME!.tex" (
    echo ERROR: !NAME!.tex tidak ditemukan.
    pause
    goto menu
)

REM Kompilasi
echo.
echo Compiling !NAME!...
echo.

pushd "%CHAPTER_DIR%"

pdflatex -interaction=nonstopmode "!NAME!.tex" >nul 2>&1
if exist "!NAME!.aux" biber "!NAME!" >nul 2>&1
pdflatex -interaction=nonstopmode "!NAME!.tex" >nul 2>&1
pdflatex -interaction=nonstopmode "!NAME!.tex" >nul 2>&1
pdflatex -interaction=nonstopmode "!NAME!.tex" >nul 2>&1

REM Pindahkan PDF ke output
if exist "!NAME!.pdf" (
    move /Y "!NAME!.pdf" "%OUTPUT_DIR%\!NAME!.pdf" >nul
    echo Berhasil: !NAME!.pdf
    echo Output: %OUTPUT_DIR%\!NAME!.pdf
) else (
    echo GAGAL: !NAME!.pdf tidak ditemukan
)

REM Cleanup
del /Q "!NAME!.aux" "!NAME!.log" "!NAME!.out" "!NAME!.toc" "!NAME!.lof" "!NAME!.lot" "!NAME!.synctex.gz" "!NAME!.fdb_latexmk" "!NAME!.fls" "!NAME!.nav" "!NAME!.snm" "!NAME!.vrb" "!NAME!.bbl" "!NAME!.blg" "!NAME!.bcf" "!NAME!.run.xml" 2>nul

popd

echo.
pause
goto menu
