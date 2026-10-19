// Berkas: src/main_lex.c
// Driver untuk menguji lexer tangan.

#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"
#include "token.h"

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
    Lexer lexer;
    Token token;

    if (argc != 2) {
        fprintf(stderr, "penggunaan: %s berkas.sc\n", argv[0]);
        return 2;
    }

    source = read_file(argv[1]);
    if (!source) {
        fprintf(stderr, "tidak dapat membaca %s\n", argv[1]);
        return 2;
    }

    lexer_init(&lexer, source, argv[1]);
    for (;;) {
        token = lexer_next(&lexer);
        token_print(stdout, &token);
        if (token.type == TOK_EOF) {
            break;
        }
    }

    free(source);
    return lexer.had_error ? 1 : 0;
}
