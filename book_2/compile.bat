@echo off
REM Batch file untuk compile LaTeX ke PDF dan membersihkan file temporary
REM Author: Generated for silabus-teknik-kompilasi.tex

echo ========================================
echo Compiling LaTeX document to PDF...
echo ========================================
echo.

REM Set nama file LaTeX (tanpa ekstensi .tex)
set LATEXFILE=silabus-teknik-kompilasi

REM Cek apakah file LaTeX ada
if not exist "%LATEXFILE%.tex" (
    echo ERROR: File %LATEXFILE%.tex tidak ditemukan!
    echo Pastikan file berada di direktori yang sama dengan script ini.
    pause
    exit /b 1
)

REM Compile LaTeX ke PDF (2 kali untuk memastikan referensi dan TOC ter-update)
echo [1/2] Running pdflatex (first pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

if errorlevel 1 (
    echo.
    echo ERROR: Compilation failed on first pass!
    echo Check the .log file for errors.
    pause
    exit /b 1
)

echo.
echo [2/2] Running pdflatex (second pass for references)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

if errorlevel 1 (
    echo.
    echo WARNING: Compilation had errors on second pass!
    echo Check the .log file for warnings.
) else (
    echo.
    echo ========================================
    echo Compilation successful!
    echo ========================================
)

echo.
echo Cleaning up temporary files...
REM Hapus file-file temporary yang dihasilkan kompilasi LaTeX
del /Q "%LATEXFILE%.aux" 2>nul
del /Q "%LATEXFILE%.log" 2>nul
del /Q "%LATEXFILE%.out" 2>nul
del /Q "%LATEXFILE%.toc" 2>nul
del /Q "%LATEXFILE%.lof" 2>nul
del /Q "%LATEXFILE%.lot" 2>nul
del /Q "%LATEXFILE%.bbl" 2>nul
del /Q "%LATEXFILE%.blg" 2>nul
del /Q "%LATEXFILE%.fdb_latexmk" 2>nul
del /Q "%LATEXFILE%.fls" 2>nul
del /Q "%LATEXFILE%.synctex.gz" 2>nul
del /Q "%LATEXFILE%.nav" 2>nul
del /Q "%LATEXFILE%.snm" 2>nul
del /Q "%LATEXFILE%.vrb" 2>nul
del /Q "%LATEXFILE%.bcf" 2>nul
del /Q "%LATEXFILE%.run.xml" 2>nul
del /Q "%LATEXFILE%.idx" 2>nul
del /Q "%LATEXFILE%.ilg" 2>nul
del /Q "%LATEXFILE%.ind" 2>nul
del /Q "%LATEXFILE%.lol" 2>nul

echo Temporary files cleaned up successfully!
echo.
echo Output file: %LATEXFILE%.pdf
echo.
pause
