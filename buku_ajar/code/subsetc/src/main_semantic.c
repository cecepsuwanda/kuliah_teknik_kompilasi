// Berkas: src/main_semantic.c
// Driver parser + analisis semantik.

#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
#include "ast.h"
#include "symtab.h"
#include "typecheck.h"

static char *read_file(const char *path) {
    FILE *file;
    long size;
    char *buffer;

    file = fopen(path, "rb");
    if (!file) {
        return NULL;
    }
    fseek(file, 0, SEEK_END);
    size = ftell(file);
    rewind(file);
    buffer = (char *)malloc((size_t)size + 1);
    if (!buffer) {
        fclose(file);
        return NULL;
    }
    if (fread(buffer, 1, (size_t)size, file) != (size_t)size) {
        free(buffer);
        fclose(file);
        return NULL;
    }
    buffer[size] = '\0';
    fclose(file);
    return buffer;
}

int main(int argc, char **argv) {
    char *source;
    Parser parser;
    AstNode *program;
    SymTab table;
    int semantic_errors;

    if (argc != 2) {
        fprintf(stderr, "penggunaan: %s berkas.sc\n", argv[0]);
        return 2;
    }

    source = read_file(argv[1]);
    if (!source) {
        fprintf(stderr, "tidak dapat membaca %s\n", argv[1]);
        return 2;
    }

    parser_init(&parser, source, argv[1]);
    program = parser_program(&parser);

    if (parser.had_error || parser.lexer.had_error) {
        ast_free(program);
        free(source);
        return 1;
    }

    symtab_init(&table);
    semantic_errors = typecheck_program(&table, program);

    if (!semantic_errors) {
        ast_print(stdout, program, 0);
    }

    symtab_free(&table);
    ast_free(program);
    free(source);
    return semantic_errors ? 1 : 0;
}
