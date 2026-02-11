@echo off
setlocal

set "ROOT=%~dp0"
set "BOOK_DIR=%ROOT%book_2"
set "OUTPUT_DIR=%ROOT%output"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo ============================================================
echo Compiling Main Document (book_2/main.tex)
echo ============================================================

pushd "%BOOK_DIR%"

REM Check for latexmk AND perl
where latexmk >nul 2>nul
if errorlevel 1 (
    echo Latexmk not found. Using pdflatex loop...
    goto :pdflatex_loop
) else (
    where perl >nul 2>nul
    if errorlevel 1 (
        echo Latexmk found but Perl is missing. Skipping latexmk.
        goto :pdflatex_loop
    ) else (
        echo Latexmk and Perl found. Using latexmk...
        latexmk -pdf -interaction=nonstopmode "main.tex"
        if errorlevel 1 (
            echo Latexmk failed. Falling back to pdflatex loop...
            goto :pdflatex_loop
        ) else (
            goto :success
        )
    )
)

:pdflatex_loop
echo Running Stage 1: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error "main.tex"
if errorlevel 1 goto :failed

echo Running Stage 2: biber/bibtex...
biber main || bibtex main

echo Running Stage 3: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error "main.tex"

echo Running Stage 4: pdflatex...
pdflatex -interaction=nonstopmode -halt-on-error "main.tex"
if errorlevel 1 goto :failed

:success
if exist "main.pdf" move /y "main.pdf" "%OUTPUT_DIR%\book_2_full.pdf"
popd
echo.
echo Operation Completed. Final PDF: %OUTPUT_DIR%\book_2_full.pdf
goto :end

:failed
popd
echo.
echo ERROR: Compilation failed.
goto :end

:end
echo.
pause
exit /b 0
