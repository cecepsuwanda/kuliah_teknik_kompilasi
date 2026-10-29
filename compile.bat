@echo off
setlocal

rem ============================================================
rem Build silabus/RPS: rps_silabus/silabus-teknik-kompilasi.tex
rem Lintasan: pdflatex -> bibtex -> pdflatex -> pdflatex
rem ============================================================

set "ROOT=%~dp0"
set "FILE=silabus-teknik-kompilasi"
set "INPUT_DIR=%ROOT%rps_silabus"

if not exist "%INPUT_DIR%\%FILE%.tex" (
    echo ERROR: %INPUT_DIR%\%FILE%.tex tidak ditemukan.
    goto :end
)

echo ============================================================
echo Compiling %FILE%.tex
echo ============================================================

pushd "%INPUT_DIR%"

echo Stage 1: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error "%FILE%.tex"
if errorlevel 1 goto :failed

echo Stage 2: bibtex...
bibtex "%FILE%" 2>nul

echo Stage 3: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error "%FILE%.tex"
if errorlevel 1 goto :failed

echo Stage 4: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error "%FILE%.tex"
if errorlevel 1 goto :failed

echo.
echo Compilation successful: %INPUT_DIR%\%FILE%.pdf
goto :end

:failed
echo.
echo ERROR: Compilation failed. Periksa %INPUT_DIR%\%FILE%.log.

:end
popd
pause
exit /b 0
