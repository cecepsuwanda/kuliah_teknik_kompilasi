@echo off
setlocal
echo ============================================================
echo Menghapus file sampingan hasil kompilasi LaTeX...
echo ============================================================

pushd "%~dp0"

echo Menghapus file auxiliaury secara rekursif...
for %%E in (aux bbl blg bcf out toc lof lot fls fdb_latexmk nav snm vrb idx ilg ind acn acr alg glg glo gls ist xdy run.xml synctex pdfsync synctex.gz) do (
    del /s /q "*.%%E" 2>nul
)

popd

echo.
echo Pembersihan selesai!
pause
exit /b 0
