@echo off
setlocal
if "%~1"=="" (
  echo Penggunaan: build-chapter.bat NN [/bib]
  exit /b 1
)
pushd "%~dp0..\chapters\%~1"
if not exist chapter.tex (
  echo Berkas chapter.tex tidak ditemukan di chapters\%~1
  popd
  exit /b 1
)
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error chapter.tex
if errorlevel 1 goto fail
if /I "%~2"=="/bib" (
  bibtex chapter
  if errorlevel 1 goto fail
)
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error chapter.tex
if errorlevel 1 goto fail
echo CHAPTER %~1 OK
popd
exit /b 0
:fail
echo CHAPTER %~1 FAILED
popd
exit /b 1
