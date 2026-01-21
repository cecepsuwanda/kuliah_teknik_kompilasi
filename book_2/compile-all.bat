@echo off
REM Batch file terpadu untuk compile buku lengkap atau per bab
REM Author: Generated for buku ajar Teknik Kompilasi

REM Membuat folder output jika belum ada
if not exist "output" mkdir output

:menu
cls
echo ========================================
echo    BUKU AJAR TEKNIK KOMPILASI
echo    Compilation Script
echo ========================================
echo.
echo Pilih opsi:
echo.
echo   1. Compile Buku Lengkap (main.tex)
echo   2. Compile Semua Bab (1-16) Sekaligus
echo   3. Compile Range Bab (misalnya: 1-5, 3-10)
echo.
echo   --- Compile Per Bab (Satu-satu) ---
echo   4. Compile Bab 1 (Standalone)
echo   5. Compile Bab 2 (Standalone)
echo   6. Compile Bab 3 (Standalone)
echo   7. Compile Bab 4 (Standalone)
echo   8. Compile Bab 5 (Standalone)
echo   9. Compile Bab 6 (Standalone)
echo  10. Compile Bab 7 (Standalone)
echo  11. Compile Bab 8 (Standalone)
echo  12. Compile Bab 9 (Standalone)
echo  13. Compile Bab 10 (Standalone)
echo  14. Compile Bab 11 (Standalone)
echo  15. Compile Bab 12 (Standalone)
echo  16. Compile Bab 13 (Standalone)
echo  17. Compile Bab 14 (Standalone)
echo  18. Compile Bab 15 (Standalone)
echo  19. Compile Bab 16 (Standalone)
echo   0. Keluar
echo.
set /p choice="Masukkan pilihan (0-19): "

if "%choice%"=="0" goto end
if "%choice%"=="1" goto compile_book
if "%choice%"=="2" goto compile_all_bab
if "%choice%"=="3" goto compile_range_bab
if "%choice%"=="4" goto compile_bab1
if "%choice%"=="5" goto compile_bab2
if "%choice%"=="6" goto compile_bab3
if "%choice%"=="7" goto compile_bab4
if "%choice%"=="8" goto compile_bab5
if "%choice%"=="9" goto compile_bab6
if "%choice%"=="10" goto compile_bab7
if "%choice%"=="11" goto compile_bab8
if "%choice%"=="12" goto compile_bab9
if "%choice%"=="13" goto compile_bab10
if "%choice%"=="14" goto compile_bab11
if "%choice%"=="15" goto compile_bab12
if "%choice%"=="16" goto compile_bab13
if "%choice%"=="17" goto compile_bab14
if "%choice%"=="18" goto compile_bab15
if "%choice%"=="19" goto compile_bab16

echo.
echo Pilihan tidak valid!
pause
goto menu

:compile_book
cls
echo ========================================
echo Compiling Complete Book (main.tex)...
echo ========================================
echo.

set LATEXFILE=main

if not exist "%LATEXFILE%.tex" (
    echo ERROR: File %LATEXFILE%.tex tidak ditemukan!
    pause
    goto menu
)

echo [1/4] Running pdflatex (first pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"
if errorlevel 1 (
    echo ERROR: Compilation failed on first pass!
    pause
    goto menu
)

echo.
echo [2/4] Running bibtex...
bibtex "%LATEXFILE%"

echo.
echo [3/4] Running pdflatex (second pass for bibliography and TOC)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

echo.
echo [4/4] Running pdflatex (final pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

if errorlevel 1 (
    echo WARNING: Compilation had errors!
) else (
    echo.
    echo ========================================
    echo Compilation successful!
    echo ========================================
)

call :cleanup_main
echo.
echo Moving PDF to output folder...
if exist "%LATEXFILE%.pdf" (
    move /Y "%LATEXFILE%.pdf" "output\%LATEXFILE%.pdf" >nul
    echo Output file: output\%LATEXFILE%.pdf
) else (
    echo WARNING: PDF file not found!
)
echo.
pause
goto menu

:compile_all_bab
cls
echo ========================================
echo Compiling All Chapters (1-16)...
echo ========================================
echo.
echo Ini akan mengcompile semua bab dari 1 sampai 16.
echo.
set /p confirm="Lanjutkan? (Y/N): "
if /i not "%confirm%"=="Y" goto menu

set /a total=16
set /a count=0

for /l %%i in (1,1,16) do (
    set /a count+=1
    echo.
    echo [%count%/%total%] Compiling Bab %%i...
    call :compile_bab_auto %%i
)

echo.
echo ========================================
echo Selesai! Semua bab telah dicompile.
echo ========================================
echo.
pause
goto menu

:compile_range_bab
cls
echo ========================================
echo Compile Range Bab
echo ========================================
echo.
echo Masukkan range bab yang ingin dicompile.
echo Contoh: 1-5 (akan compile bab 1, 2, 3, 4, 5)
echo         3-10 (akan compile bab 3 sampai 10)
echo.
set /p range="Masukkan range (format: start-end): "

REM Parse range
for /f "tokens=1,2 delims=-" %%a in ("%range%") do (
    set start=%%a
    set end=%%b
)

REM Validate
if "%start%"=="" (
    echo ERROR: Format tidak valid!
    pause
    goto menu
)
if "%end%"=="" (
    echo ERROR: Format tidak valid! Gunakan format: start-end
    pause
    goto menu
)

REM Check if start and end are numbers
set /a test_start=%start% 2>nul
if errorlevel 1 (
    echo ERROR: Start harus berupa angka!
    pause
    goto menu
)
set /a test_end=%end% 2>nul
if errorlevel 1 (
    echo ERROR: End harus berupa angka!
    pause
    goto menu
)

REM Check range validity
if %start% lss 1 (
    echo ERROR: Start harus >= 1
    pause
    goto menu
)
if %end% gtr 16 (
    echo ERROR: End harus <= 16
    pause
    goto menu
)
if %start% gtr %end% (
    echo ERROR: Start harus <= End
    pause
    goto menu
)

echo.
echo Akan mengcompile bab %start% sampai %end%
set /p confirm="Lanjutkan? (Y/N): "
if /i not "%confirm%"=="Y" goto menu

set /a total=%end%-%start%+1
set /a count=0

for /l %%i in (%start%,1,%end%) do (
    set /a count+=1
    echo.
    echo [%count%/%total%] Compiling Bab %%i...
    call :compile_bab_auto %%i
)

echo.
echo ========================================
echo Selesai! Bab %start% sampai %end% telah dicompile.
echo ========================================
echo.
pause
goto menu

:compile_bab_auto
REM Helper function untuk compile bab secara otomatis
REM Parameter: %1 = nomor bab (1-16)
setlocal enabledelayedexpansion

set /a bab_num=%1
if %bab_num% lss 10 (
    set bab_str=0%bab_num%
) else (
    set bab_str=%bab_num%
)

cd chapters

set LATEXFILE=bab-!bab_str!-standalone

if not exist "!LATEXFILE!.tex" (
    echo   ERROR: File !LATEXFILE!.tex tidak ditemukan!
    cd ..
    exit /b
)

echo   [1/4] Running pdflatex (first pass)...
pdflatex -interaction=nonstopmode "!LATEXFILE!.tex" >nul 2>&1
if errorlevel 1 (
    echo   ERROR: Compilation failed on first pass!
    cd ..
    exit /b
)

echo   [2/4] Running bibtex...
bibtex "!LATEXFILE!" >nul 2>&1

echo   [3/4] Running pdflatex (second pass)...
pdflatex -interaction=nonstopmode "!LATEXFILE!.tex" >nul 2>&1

echo   [4/4] Running pdflatex (final pass)...
pdflatex -interaction=nonstopmode "!LATEXFILE!.tex" >nul 2>&1

if errorlevel 1 (
    echo   WARNING: Compilation had errors!
) else (
    echo   Bab %bab_num% compiled successfully!
)

call :cleanup_bab_auto "!LATEXFILE!"

if exist "!LATEXFILE!.pdf" (
    move /Y "!LATEXFILE!.pdf" "..\output\!LATEXFILE!.pdf" >nul 2>&1
    echo   PDF moved to output folder
)

cd ..
endlocal
exit /b

:cleanup_bab_auto
REM Cleanup untuk compile otomatis
set LATEXFILE=%~1
del /Q "%LATEXFILE%.aux" 2>nul
del /Q "%LATEXFILE%.log" 2>nul
del /Q "%LATEXFILE%.out" 2>nul
del /Q "%LATEXFILE%.toc" 2>nul
del /Q "%LATEXFILE%.bbl" 2>nul
del /Q "%LATEXFILE%.blg" 2>nul
del /Q "%LATEXFILE%.synctex.gz" 2>nul
del /Q "%LATEXFILE%.fdb_latexmk" 2>nul
del /Q "%LATEXFILE%.fls" 2>nul
exit /b

:compile_bab1
call :compile_bab "01" "Bab 1"
goto menu

:compile_bab2
call :compile_bab "02" "Bab 2"
goto menu

:compile_bab3
call :compile_bab "03" "Bab 3"
goto menu

:compile_bab4
call :compile_bab "04" "Bab 4"
goto menu

:compile_bab5
call :compile_bab "05" "Bab 5"
goto menu

:compile_bab6
call :compile_bab "06" "Bab 6"
goto menu

:compile_bab7
call :compile_bab "07" "Bab 7"
goto menu

:compile_bab8
call :compile_bab "08" "Bab 8"
goto menu

:compile_bab9
call :compile_bab "09" "Bab 9"
goto menu

:compile_bab10
call :compile_bab "10" "Bab 10"
goto menu

:compile_bab11
call :compile_bab "11" "Bab 11"
goto menu

:compile_bab12
call :compile_bab "12" "Bab 12"
goto menu

:compile_bab13
call :compile_bab "13" "Bab 13"
goto menu

:compile_bab14
call :compile_bab "14" "Bab 14"
goto menu

:compile_bab15
call :compile_bab "15" "Bab 15"
goto menu

:compile_bab16
call :compile_bab "16" "Bab 16"
goto menu

:compile_bab
cls
echo ========================================
echo Compiling %~2 (Standalone)...
echo ========================================
echo.

cd chapters

set LATEXFILE=bab-%~1-standalone

if not exist "%LATEXFILE%.tex" (
    echo ERROR: File %LATEXFILE%.tex tidak ditemukan!
    cd ..
    pause
    exit /b
)

echo [1/4] Running pdflatex (first pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"
if errorlevel 1 (
    echo ERROR: Compilation failed on first pass!
    cd ..
    pause
    exit /b
)

echo.
echo [2/4] Running bibtex...
bibtex "%LATEXFILE%"

echo.
echo [3/4] Running pdflatex (second pass for bibliography)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

echo.
echo [4/4] Running pdflatex (final pass)...
pdflatex -interaction=nonstopmode "%LATEXFILE%.tex"

if errorlevel 1 (
    echo WARNING: Compilation had errors!
) else (
    echo.
    echo ========================================
    echo Compilation successful!
    echo ========================================
)

call :cleanup_bab
echo.
echo Moving PDF to output folder...
if exist "%LATEXFILE%.pdf" (
    move /Y "%LATEXFILE%.pdf" "..\output\%LATEXFILE%.pdf" >nul
    echo Output file: output\%LATEXFILE%.pdf
) else (
    echo WARNING: PDF file not found!
)
cd ..
echo.
pause
exit /b

:cleanup_main
echo.
echo Cleaning up temporary files...
del /Q "%LATEXFILE%.aux" 2>nul
del /Q "%LATEXFILE%.log" 2>nul
del /Q "%LATEXFILE%.out" 2>nul
del /Q "%LATEXFILE%.toc" 2>nul
del /Q "%LATEXFILE%.lof" 2>nul
del /Q "%LATEXFILE%.lot" 2>nul
del /Q "%LATEXFILE%.bbl" 2>nul
del /Q "%LATEXFILE%.blg" 2>nul
del /Q "%LATEXFILE%.synctex.gz" 2>nul
del /Q "%LATEXFILE%.fdb_latexmk" 2>nul
del /Q "%LATEXFILE%.fls" 2>nul
del /Q "%LATEXFILE%.nav" 2>nul
del /Q "%LATEXFILE%.snm" 2>nul
del /Q "%LATEXFILE%.vrb" 2>nul
echo Temporary files cleaned up successfully!
exit /b

:cleanup_bab
echo.
echo Cleaning up temporary files...
del /Q "%LATEXFILE%.aux" 2>nul
del /Q "%LATEXFILE%.log" 2>nul
del /Q "%LATEXFILE%.out" 2>nul
del /Q "%LATEXFILE%.toc" 2>nul
del /Q "%LATEXFILE%.bbl" 2>nul
del /Q "%LATEXFILE%.blg" 2>nul
del /Q "%LATEXFILE%.synctex.gz" 2>nul
del /Q "%LATEXFILE%.fdb_latexmk" 2>nul
del /Q "%LATEXFILE%.fls" 2>nul
echo Temporary files cleaned up successfully!
exit /b

:end
echo.
echo Terima kasih!
exit /b 0