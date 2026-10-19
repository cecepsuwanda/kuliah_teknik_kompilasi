// Berkas: src/main_parse.c
// Driver untuk menguji parser dan mencetak AST.

#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
#include "ast.h"

static char *read_file(const char *path) {
    FILE *file;
    long size;
    char *buffer;

    file = fopen(path, "rb");
    if (!file) {
        return NULL;
    }
    if (fseek(file, 0, SEEK_END) != 0) {
        fclose(file);
        return NULL;
    }
    size = ftell(file);
    if (size < 0) {
        fclose(file);
        return NULL;
    }
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

    if (!parser.had_error && !parser.lexer.had_error) {
        ast_print(stdout, program, 0);
    }

    ast_free(program);
    free(source);
    return (parser.had_error || parser.lexer.had_error) ? 1 : 0;
}
