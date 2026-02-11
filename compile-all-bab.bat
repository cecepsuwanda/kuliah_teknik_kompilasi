@echo off
setlocal enabledelayedexpansion

set "ROOT=%~dp0"
set "CHAPTER_DIR=%ROOT%book_2\chapters"
set "OUTPUT_DIR=%ROOT%output"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo ============================================================
echo Compiling Individual Chapters in book_2/chapters
echo ============================================================

pushd "%CHAPTER_DIR%"

for %%F in (bab-*.tex) do (
    set "FILE_NAME=%%~nF"
    echo.
    echo ------------------------------------------------------------
    echo Compiling !FILE_NAME!...
    echo ------------------------------------------------------------
    
    pdflatex -interaction=nonstopmode -halt-on-error "%%F"
    if !errorlevel! equ 0 (
        REM Use biber for newer chapters, fall back to bibtex if necessary
        biber "!FILE_NAME!" || bibtex "!FILE_NAME!"
        pdflatex -interaction=nonstopmode -halt-on-error "%%F"
        pdflatex -interaction=nonstopmode -halt-on-error "%%F"
        
        if exist "!FILE_NAME!.pdf" (
            echo Moving !FILE_NAME!.pdf to output...
            move /y "!FILE_NAME!.pdf" "%OUTPUT_DIR%\!FILE_NAME!.pdf"
        )
    ) else (
        echo ERROR compiling !FILE_NAME!.
    )
)

popd

echo.
echo Operation Completed. Check the output folder for PDFs.
pause
exit /b 0
