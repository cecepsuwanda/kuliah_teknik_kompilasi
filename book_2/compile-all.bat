@echo off
REM Batch file terpadu untuk compile buku lengkap atau per-bab
REM Author: Generated for buku ajar Teknik Kompilasi
REM Menggabungkan compile-all.bat dan compile-per-bab.bat

setlocal enabledelayedexpansion

set ROOT=%~dp0
cd /d "%ROOT%"

REM Membuat folder output jika belum ada
if not exist "output" mkdir output

if not exist "chapters" (
    echo ERROR: Folder chapters tidak ditemukan.
    pause
    exit /b 1
)

:menu
cls
echo ========================================
echo    BUKU AJAR TEKNIK KOMPILASI
echo    Compilation Script
echo ========================================
echo.
echo Pilih opsi:
echo.
echo   1. Compile Buku Lengkap (main.tex)
echo   2. Compile Per-Bab (pilih nomor bab)
echo   3. Compile Semua Bab (00-18)
echo   0. Keluar
echo.
set /p choice="Masukkan pilihan (0-3): "

if "%choice%"=="0" goto end
if "%choice%"=="1" goto compile_book
if "%choice%"=="2" goto compile_per_bab_menu
if "%choice%"=="3" goto compile_all_bab

echo.
echo Pilihan tidak valid!
pause
goto menu

:compile_book
cls
echo ========================================
echo Compiling Complete Book (main.tex)...
echo ========================================
echo.

set LATEXFILE=main

if not exist "%LATEXFILE%.tex" (
    echo ERROR: File %LATEXFILE%.tex tidak ditemukan!
    pause
    goto menu
)

echo [1/4] Running pdflatex (first pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"
if errorlevel 1 (
    echo ERROR: Compilation failed on first pass!
    pause
    goto menu
)

echo.
echo [2/4] Running bibtex...
bibtex "%LATEXFILE%"

echo.
echo [3/4] Running pdflatex (second pass for bibliography and TOC)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

echo.
echo [4/4] Running pdflatex (final pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

if errorlevel 1 (
    echo WARNING: Compilation had errors!
) else (
    echo.
    echo ========================================
    echo Compilation successful!
    echo ========================================
)

call :cleanup_main
echo.
echo Moving PDF to output folder...
if exist "%LATEXFILE%.pdf" (
    move /Y "%LATEXFILE%.pdf" "output\%LATEXFILE%.pdf" >nul
    echo Output file: output\%LATEXFILE%.pdf
) else (
    echo WARNING: PDF file not found!
)
echo.
pause
goto menu

:compile_per_bab_menu
cls
echo ========================================
echo    COMPILE PER-BAB
echo ========================================
echo.
echo Pilih bab yang akan dikompilasi:
echo   0   = Prakata (bab-00)
echo   1   = Bab 1
echo   2   = Bab 2
echo   ...
echo   18  = Bab 18
echo   q   = Kembali ke menu utama
echo.
set /p bab_choice="Masukkan nomor bab (0-18, atau q): "

if /i "%bab_choice%"=="q" goto menu

REM Validasi angka
set /a num=%bab_choice% 2>nul
if errorlevel 1 (
    echo Pilihan tidak valid.
    pause
    goto compile_per_bab_menu
)
if %num% lss 0 (
    echo Nomor bab harus >= 0.
    pause
    goto compile_per_bab_menu
)
if %num% gtr 18 (
    echo Nomor bab harus <= 18.
    pause
    goto compile_per_bab_menu
)

REM Format bab: 00, 01, ..., 18
if %num% lss 10 (
    set "bab_str=0%num%"
) else (
    set "bab_str=%num%"
)

set "TEXFILE=bab-!bab_str!.tex"
if not exist "chapters\!TEXFILE!" (
    echo ERROR: File chapters\!TEXFILE! tidak ditemukan.
    pause
    goto compile_per_bab_menu
)

echo.
echo Compiling chapters\!TEXFILE! ...
cd chapters
echo [1/2] pdflatex (pass 1)...
pdflatex -interaction=nonstopmode "!TEXFILE!"
if errorlevel 1 (
    cd ..
    echo ERROR: Kompilasi gagal.
    pause
    goto compile_per_bab_menu
)
echo [2/2] pdflatex (pass 2, untuk referensi)...
pdflatex -interaction=nonstopmode "!TEXFILE!" >nul 2>&1

REM Cleanup file sampingan di folder chapters
call :cleanup_chapter "!TEXFILE!"

cd ..

set "PDFFILE=chapters\bab-!bab_str!.pdf"
if exist "!PDFFILE!" (
    echo.
    echo Berhasil. Output: !PDFFILE!
    if not exist "output" mkdir output
    move /Y "!PDFFILE!" "output\bab-!bab_str!.pdf" >nul 2>&1
    if !errorlevel! equ 0 echo        Dipindahkan ke: output\bab-!bab_str!.pdf
) else (
    echo WARNING: File PDF tidak ditemukan.
)
echo.
pause
goto compile_per_bab_menu

:compile_all_bab
cls
echo ========================================
echo Kompilasi Semua Bab (00-18)...
echo ========================================
echo.
echo Ini akan mengcompile semua bab dari 00 sampai 18.
echo.
set /p confirm="Lanjutkan? (Y/N): "
if /i not "%confirm%"=="Y" goto menu

echo.
echo Kompilasi semua bab (00-18)...
if not exist "output" mkdir output
cd chapters
for %%i in (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18) do (
    if exist "bab-%%i.tex" (
        echo.
        echo --- bab-%%i ---
        pdflatex -interaction=nonstopmode "bab-%%i.tex" >nul 2>&1
        pdflatex -interaction=nonstopmode "bab-%%i.tex" >nul 2>&1
        
        REM Cleanup file sampingan untuk bab ini
        call :cleanup_chapter "bab-%%i.tex"
        
        if exist "bab-%%i.pdf" (
            move /Y "bab-%%i.pdf" "..\output\bab-%%i.pdf" >nul 2>&1
            echo   OK: bab-%%i.pdf (dipindahkan ke output)
        ) else (
            echo   GAGAL: bab-%%i
        )
    )
)
cd ..
echo.
echo ========================================
echo Selesai! Semua bab telah dicompile.
echo PDF ada di folder output\
echo ========================================
echo.
pause
goto menu

:cleanup_main
echo.
echo Cleaning up temporary files...
del /Q "%LATEXFILE%.aux" 2>nul
del /Q "%LATEXFILE%.log" 2>nul
del /Q "%LATEXFILE%.out" 2>nul
del /Q "%LATEXFILE%.toc" 2>nul
del /Q "%LATEXFILE%.lof" 2>nul
del /Q "%LATEXFILE%.lot" 2>nul
del /Q "%LATEXFILE%.bbl" 2>nul
del /Q "%LATEXFILE%.blg" 2>nul
del /Q "%LATEXFILE%.synctex.gz" 2>nul
del /Q "%LATEXFILE%.fdb_latexmk" 2>nul
del /Q "%LATEXFILE%.fls" 2>nul
del /Q "%LATEXFILE%.nav" 2>nul
del /Q "%LATEXFILE%.snm" 2>nul
del /Q "%LATEXFILE%.vrb" 2>nul
echo Temporary files cleaned up successfully!
exit /b

:cleanup_chapter
REM Cleanup file sampingan untuk kompilasi per-bab di folder chapters
REM Parameter: nama file .tex (misalnya "bab-01.tex")
set "TEXBASE=%~n1"
del /Q "%TEXBASE%.aux" 2>nul
del /Q "%TEXBASE%.log" 2>nul
del /Q "%TEXBASE%.out" 2>nul
del /Q "%TEXBASE%.toc" 2>nul
del /Q "%TEXBASE%.lof" 2>nul
del /Q "%TEXBASE%.lot" 2>nul
del /Q "%TEXBASE%.synctex.gz" 2>nul
del /Q "%TEXBASE%.fdb_latexmk" 2>nul
del /Q "%TEXBASE%.fls" 2>nul
del /Q "%TEXBASE%.nav" 2>nul
del /Q "%TEXBASE%.snm" 2>nul
del /Q "%TEXBASE%.vrb" 2>nul
exit /b

:end
echo.
echo Terima kasih!
endlocal
exit /b 0
