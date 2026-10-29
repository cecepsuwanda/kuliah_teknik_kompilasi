@echo off
setlocal
if "%~1"=="" (
  echo Penggunaan: build-pertemuan.bat NN
  exit /b 1
)
set NUM=%~1
pushd "%~dp0.."
if not exist build mkdir build
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build pertemuan-%NUM%.tex
if errorlevel 1 goto fail
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build pertemuan-%NUM%.tex
if errorlevel 1 goto fail
echo PERTEMUAN %NUM% OK
popd
exit /b 0
:fail
echo PERTEMUAN %NUM% GAGAL
popd
exit /b 1
