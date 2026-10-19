// Berkas: src/ast.c
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

AstNode *ast_new(AstKind kind, Token token) {
    AstNode *node = (AstNode *)calloc(1, sizeof(AstNode));
    if (!node) {
        fprintf(stderr, "kehabisan memori saat membuat simpul AST\n");
        exit(1);
    }
    node->kind = kind;
    node->token = token;
    node->decl_type = TYPE_ERROR;
    node->left = NULL;
    node->right = NULL;
    node->children = NULL;
    node->next = NULL;
    return node;
}

void ast_add_child(AstNode *parent, AstNode *child) {
    AstNode *last;

    if (!parent || !child) {
        return;
    }
    if (!parent->children) {
        parent->children = child;
        return;
    }
    last = parent->children;
    while (last->next) {
        last = last->next;
    }
    last->next = child;
}

const char *ast_kind_name(AstKind kind) {
    switch (kind) {
    case AST_PROGRAM:    return "PROGRAM";
    case AST_FUNC:       return "FUNC";
    case AST_PARAM:      return "PARAM";
    case AST_BLOCK:      return "BLOCK";
    case AST_DECL:       return "DECL";
    case AST_ASSIGN:     return "ASSIGN";
    case AST_CALL:       return "CALL";
    case AST_IF:         return "IF";
    case AST_WHILE:      return "WHILE";
    case AST_FOR:        return "FOR";
    case AST_RETURN:     return "RETURN";
    case AST_BREAK:      return "BREAK";
    case AST_CONTINUE:   return "CONTINUE";
    case AST_PRINT:      return "PRINT";
    case AST_BINARY:     return "BINARY";
    case AST_UNARY:      return "UNARY";
    case AST_INT_LIT:    return "INT_LIT";
    case AST_FLOAT_LIT:  return "FLOAT_LIT";
    case AST_CHAR_LIT:   return "CHAR_LIT";
    case AST_STRING_LIT: return "STRING_LIT";
    case AST_IDENT:      return "IDENT";
    case AST_EXPR_STMT:  return "EXPR_STMT";
    case AST_EMPTY:      return "EMPTY";
    default:             return "UNKNOWN";
    }
}

static void indent_print(int indent) {
    int i;
    for (i = 0; i < indent; i++) {
        fputs("  ", stdout);
    }
}

void ast_print(FILE *out, const AstNode *node, int indent) {
    const AstNode *child;

    if (!node) {
        return;
    }

    indent_print(indent);
    fprintf(out, "%s", ast_kind_name(node->kind));
    if (node->token.length > 0) {
        fprintf(out, " %.*s",
                node->token.length, node->token.lexeme);
    }
    fputc('\n', out);

    if (node->left) {
        ast_print(out, node->left, indent + 1);
    }
    if (node->right) {
        ast_print(out, node->right, indent + 1);
    }
    for (child = node->children; child; child = child->next) {
        ast_print(out, child, indent + 1);
    }
}

void ast_free(AstNode *node) {
    AstNode *child;
    AstNode *next;

    if (!node) {
        return;
    }
    ast_free(node->left);
    ast_free(node->right);
    child = node->children;
    while (child) {
        next = child->next;
        ast_free(child);
        child = next;
    }
    free(node);
}
