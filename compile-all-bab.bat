@echo off
setlocal enabledelayedexpansion

rem ============================================================
rem Build bab individual buku ajar Teknik Kompilasi
rem Output: output\chapter_NN.pdf
rem ============================================================

set "ROOT=%~dp0"
set "BOOK_DIR=%ROOT%buku_ajar"
set "CHAPTERS_DIR=%BOOK_DIR%\chapters"
set "OUTPUT_DIR=%ROOT%output"

if not exist "%CHAPTERS_DIR%" (
    echo ERROR: %CHAPTERS_DIR% tidak ditemukan.
    goto :end
)
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo ============================================================
echo Compiling Individual Chapters in buku_ajar/chapters
echo ============================================================

set FAILED=0

for /l %%i in (1,1,17) do (
    set "NUM=0%%i"
    set "NUM=!NUM:~-2!"
    set "CHAP_DIR=%CHAPTERS_DIR%\!NUM!"
    if exist "!CHAP_DIR!\chapter.tex" (
        echo.
        echo ------------------------------------------------------------
        echo Compiling chapter !NUM!...
        echo ------------------------------------------------------------
        pushd "!CHAP_DIR!"
        set BIBINPUTS=%BOOK_DIR%

        pdflatex -interaction=nonstopmode -halt-on-error -file-line-error chapter.tex
        if errorlevel 1 (
            echo ERROR compiling chapter !NUM!.
            set FAILED=1
        ) else (
            bibtex chapter
            pdflatex -interaction=nonstopmode -halt-on-error -file-line-error chapter.tex
            pdflatex -interaction=nonstopmode -halt-on-error -file-line-error chapter.tex
            if exist chapter.pdf (
                copy /y chapter.pdf "%OUTPUT_DIR%\chapter_!NUM!.pdf" >nul
            ) else (
                echo ERROR: chapter.pdf tidak dihasilkan untuk bab !NUM!.
                set FAILED=1
            )
        )
        popd
    )
)

echo.
if %FAILED%==1 (
    echo ADA BAB YANG GAGAL. Cek output\chapter_NN.pdf yang hilang.
) else (
    echo SEMUA BAB OK. PDF tersedia di folder output.
)

:end
pause
exit /b 0
