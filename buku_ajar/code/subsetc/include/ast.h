// Berkas: include/ast.h
// Abstract Syntax Tree sederhana untuk Subset-C.

#ifndef SUBSETC_AST_H
#define SUBSETC_AST_H

#include <stdio.h>
#include "token.h"
#include "types.h"

typedef enum {
    AST_PROGRAM,
    AST_FUNC,
    AST_PARAM,
    AST_BLOCK,
    AST_DECL,
    AST_ASSIGN,
    AST_CALL,
    AST_IF,
    AST_WHILE,
    AST_FOR,
    AST_RETURN,
    AST_BREAK,
    AST_CONTINUE,
    AST_PRINT,
    AST_BINARY,
    AST_UNARY,
    AST_INT_LIT,
    AST_FLOAT_LIT,
    AST_CHAR_LIT,
    AST_STRING_LIT,
    AST_IDENT,
    AST_EXPR_STMT,
    AST_EMPTY
} AstKind;

typedef struct AstNode {
    AstKind kind;
    Token token;
    TypeKind decl_type;
    struct AstNode *left;
    struct AstNode *right;
    struct AstNode *children;
    struct AstNode *next;
} AstNode;

AstNode *ast_new(AstKind kind, Token token);
void ast_add_child(AstNode *parent, AstNode *child);
const char *ast_kind_name(AstKind kind);
void ast_print(FILE *out, const AstNode *node, int indent);
void ast_free(AstNode *node);

#endif /* SUBSETC_AST_H */
