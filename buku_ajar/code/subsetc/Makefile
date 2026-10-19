CC      = gcc
CFLAGS  = -std=c99 -Wall -Wextra -Wpedantic -g -Iinclude
LEXER   = build/lexer.exe
PARSER  = build/parser.exe
SEMANTIC = build/scc_semantic.exe
FINAL   = build/scc.exe

LEXER_SRC  = src/token.c src/error.c src/lexer.c src/main_lex.c
PARSER_SRC = src/token.c src/error.c src/lexer.c src/ast.c src/parser.c src/main_parse.c
SEMANTIC_SRC = src/token.c src/error.c src/lexer.c src/ast.c \
               src/parser.c src/types.c src/symtab.c src/typecheck.c \
               src/main_semantic.c
FINAL_SRC = src/token.c src/error.c src/lexer.c src/ast.c src/parser.c \
            src/types.c src/symtab.c src/typecheck.c src/validate.c \
            src/main.c

.PHONY: all lexer parser semantic final clean test

all: lexer parser semantic final

lexer: $(LEXER_SRC)
	@if not exist build mkdir build
	$(CC) $(CFLAGS) $(LEXER_SRC) -o $(LEXER)

parser: $(PARSER_SRC)
	@if not exist build mkdir build
	$(CC) $(CFLAGS) $(PARSER_SRC) -o $(PARSER)

semantic: $(SEMANTIC_SRC)
	@if not exist build mkdir build
	$(CC) $(CFLAGS) $(SEMANTIC_SRC) -o $(SEMANTIC)

final: $(FINAL_SRC)
	@if not exist build mkdir build
	$(CC) $(CFLAGS) $(FINAL_SRC) -o $(FINAL)

clean:
	@if exist build rmdir /s /q build

test: all
	@echo Jalankan scripts/run-tests.bat, run-parser-tests.bat,
	@echo run-semantic-tests.bat, dan run-final-tests.bat
