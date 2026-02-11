@echo off
setlocal

set "ROOT=%~dp0"
set "FILE=silabus-teknik-kompilasi"

echo ============================================================
echo Compiling %FILE%.tex
echo ============================================================

pdflatex -interaction=nonstopmode -halt-on-error "%FILE%.tex"
if errorlevel 1 goto :failed

REM Try to resolve citations
bibtex "%FILE%" 2>nul

pdflatex -interaction=nonstopmode -halt-on-error "%FILE%.tex"
pdflatex -interaction=nonstopmode -halt-on-error "%FILE%.tex"

echo.
echo Compilation successful!
goto :end

:failed
echo.
echo ERROR: Compilation failed.
goto :end

:end
echo.
pause
exit /b 0
