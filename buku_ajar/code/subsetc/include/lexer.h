// Berkas: include/lexer.h
// Antarmuka lexer tangan untuk Subset-C.

#ifndef SUBSETC_LEXER_H
#define SUBSETC_LEXER_H

#include <stddef.h>
#include <stdio.h>
#include "token.h"

typedef struct {
    const char *source;
    size_t length;
    size_t pos;
    int line;
    int column;
    const char *filename;
    int had_error;
} Lexer;

void lexer_init(Lexer *lexer, const char *source, const char *filename);
Token lexer_next(Lexer *lexer);
void token_print(FILE *out, const Token *token);

#endif /* SUBSETC_LEXER_H */
