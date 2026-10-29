@echo off
setlocal

rem ============================================================
rem Build buku ajar Teknik Kompilasi (buku_ajar/main.tex)
rem Lintasan: pdflatex -> bibtex -> pdflatex -> pdflatex
rem ============================================================

set "ROOT=%~dp0"
set "BOOK_DIR=%ROOT%buku_ajar"
set "BUILD_DIR=%BOOK_DIR%\build"
set "OUTPUT_DIR=%ROOT%output"

if not exist "%BOOK_DIR%\main.tex" (
    echo ERROR: %BOOK_DIR%\main.tex tidak ditemukan.
    goto :end
)
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo ============================================================
echo Compiling Main Document (buku_ajar/main.tex)
echo ============================================================

pushd "%BOOK_DIR%"
set BIBINPUTS=%CD%

echo Stage 1: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build main.tex
if errorlevel 1 goto :failed

echo Stage 2: bibtex...
bibtex build\main

echo Stage 3: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build main.tex
if errorlevel 1 goto :failed

echo Stage 4: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build main.tex
if errorlevel 1 goto :failed

if exist "build\main.pdf" (
    copy /y "build\main.pdf" "main.pdf" >nul
    copy /y "build\main.pdf" "%OUTPUT_DIR%\buku_ajar_full.pdf" >nul
)
popd

echo.
echo BUILD OK
echo Final PDF: %OUTPUT_DIR%\buku_ajar_full.pdf
goto :end

:failed
popd
echo.
echo BUILD FAILED. Periksa buku_ajar\build\main.log untuk detail.

:end
pause
exit /b 0
