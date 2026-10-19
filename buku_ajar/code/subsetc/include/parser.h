// Berkas: include/parser.h
// Recursive descent parser untuk Subset-C.

#ifndef SUBSETC_PARSER_H
#define SUBSETC_PARSER_H

#include "lexer.h"
#include "ast.h"

typedef struct {
    Lexer lexer;
    Token current;
    int had_error;
} Parser;

void parser_init(Parser *parser, const char *source,
                 const char *filename);
AstNode *parser_program(Parser *parser);

#endif /* SUBSETC_PARSER_H */
