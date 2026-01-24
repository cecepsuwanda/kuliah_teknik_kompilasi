@echo off
REM Menghapus semua file sampingan hasil kompilasi LaTeX ke PDF
REM Menghapus secara recursive di semua folder dan subfolder
REM Jalankan dari folder book_2 (root proyek)

setlocal enabledelayedexpansion

echo.
echo ========================================
echo    Hapus File Sampingan Kompilasi
echo    (LaTeX auxiliary files - Recursive)
echo ========================================
echo.

set ROOT=%~dp0
cd /d "%ROOT%"

REM Buat log file untuk mencatat file yang dihapus
set LOGFILE=clean-aux-log.txt
set LOGPATH=%ROOT%%LOGFILE%

REM Hapus log file lama jika ada (kecuali yang sedang dibuat)
if exist "%LOGPATH%" del /Q "%LOGPATH%" 2>nul

echo [INFO] Log file: %LOGFILE%
echo [INFO] Mulai menghapus file sampingan...
echo.
echo ======================================== > "%LOGPATH%"
echo    LOG HAPUS FILE SAMPINGAN KOMPILASI >> "%LOGPATH%"
echo    Tanggal: %date% %time% >> "%LOGPATH%"
echo ======================================== >> "%LOGPATH%"
echo. >> "%LOGPATH%"

REM Counter untuk menghitung file yang dihapus
set /a COUNT=0

REM --- Hapus file .aux di semua folder dan subfolder ---
echo [1/8] Mencari dan menghapus file .aux...
for /r %%F in (*.aux) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file .log di semua folder dan subfolder ---
echo [2/8] Mencari dan menghapus file .log...
for /r %%F in (*.log) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file .out di semua folder dan subfolder ---
echo [3/8] Mencari dan menghapus file .out...
for /r %%F in (*.out) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file .toc di semua folder dan subfolder ---
echo [4/8] Mencari dan menghapus file .toc...
for /r %%F in (*.toc) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file .lof di semua folder dan subfolder ---
echo [5/8] Mencari dan menghapus file .lof...
for /r %%F in (*.lof) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file .lot di semua folder dan subfolder ---
echo [6/8] Mencari dan menghapus file .lot...
for /r %%F in (*.lot) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file .bbl dan .blg di semua folder dan subfolder ---
echo [7/8] Mencari dan menghapus file .bbl dan .blg...
for /r %%F in (*.bbl *.blg) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM --- Hapus file lainnya (.synctex.gz, .fdb_latexmk, .fls, .nav, .snm, .vrb) ---
echo [8/8] Mencari dan menghapus file lainnya...
for /r %%F in (*.synctex.gz *.fdb_latexmk *.fls *.nav *.snm *.vrb) do (
    if exist "%%F" (
        echo   Menghapus: %%F >> "%LOGPATH%"
        del /Q "%%F" 2>nul
        if !errorlevel! equ 0 set /a COUNT+=1
    )
)

REM Tulis summary ke log
echo. >> "%LOGPATH%"
echo ======================================== >> "%LOGPATH%"
echo Total file yang dihapus: !COUNT! >> "%LOGPATH%"
echo Selesai pada: %date% %time% >> "%LOGPATH%"
echo ======================================== >> "%LOGPATH%"

echo.
echo ========================================
echo Selesai!
echo Total file yang dihapus: !COUNT!
echo.
echo Log file tersimpan di: %LOGFILE%
echo (File .tex, .bib, .pdf TIDAK dihapus.)
echo.
pause

endlocal
