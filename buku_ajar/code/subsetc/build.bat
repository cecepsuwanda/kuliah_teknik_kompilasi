@echo off
setlocal
pushd "%~dp0"
where gcc >nul 2>&1
if errorlevel 1 (
  echo GCC tidak ditemukan. Pasang MinGW-w64 atau gunakan WSL.
  echo Proyek tetap dapat dibaca dan ditinjau secara statis.
  popd
  exit /b 1
)
if not exist build mkdir build

echo [1/2] lexer
gcc -std=c99 -Wall -Wextra -Wpedantic -g -Iinclude ^
    src\token.c src\error.c src\lexer.c src\main_lex.c ^
    -o build\lexer.exe
if errorlevel 1 goto fail

echo [2/3] parser
gcc -std=c99 -Wall -Wextra -Wpedantic -g -Iinclude ^
    src\token.c src\error.c src\lexer.c src\ast.c src\parser.c ^
    src\main_parse.c -o build\parser.exe
if errorlevel 1 goto fail

echo [3/4] semantic
gcc -std=c99 -Wall -Wextra -Wpedantic -g -Iinclude ^
    src\token.c src\error.c src\lexer.c src\ast.c src\parser.c ^
    src\types.c src\symtab.c src\typecheck.c src\main_semantic.c ^
    -o build\scc_semantic.exe
if errorlevel 1 goto fail

echo [4/4] final
gcc -std=c99 -Wall -Wextra -Wpedantic -g -Iinclude ^
    src\token.c src\error.c src\lexer.c src\ast.c src\parser.c ^
    src\types.c src\symtab.c src\typecheck.c src\validate.c ^
    src\main.c -o build\scc.exe
if errorlevel 1 goto fail

echo BUILD OK: build\lexer.exe, build\parser.exe, build\scc_semantic.exe, build\scc.exe
popd
exit /b 0

:fail
echo BUILD GAGAL
popd
exit /b 1
