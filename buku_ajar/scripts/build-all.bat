@echo off
setlocal
pushd "%~dp0.."
if not exist build mkdir build
set BIBINPUTS=%CD%
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build main.tex
if errorlevel 1 goto fail
bibtex build\main
if errorlevel 1 goto fail
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build main.tex
if errorlevel 1 goto fail
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build main.tex
if errorlevel 1 goto fail
copy /y build\main.pdf main.pdf >nul
echo BUILD OK
popd
exit /b 0
:fail
echo BUILD FAILED
popd
exit /b 1
