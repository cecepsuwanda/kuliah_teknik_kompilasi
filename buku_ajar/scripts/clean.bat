@echo off
setlocal
pushd "%~dp0.."
for %%E in (aux log toc lof lot lol out bbl blg fls fdb_latexmk bcf xdv) do (
  del /s /q *.%%E >nul 2>&1
)
del /s /q *.synctex.gz >nul 2>&1
del /s /q *.run.xml >nul 2>&1
if exist build\main.pdf del /q build\main.pdf
if exist main.pdf del /q main.pdf
echo CLEAN OK
popd
exit /b 0
