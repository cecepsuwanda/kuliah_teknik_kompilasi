// Berkas: src/typecheck.c
#include <stdio.h>
#include <string.h>
#include "typecheck.h"
#include "types.h"
#include "error.h"

static int had_error = 0;

static void report(AstNode *node, const char *message) {
    error_at("<semantic>", node->token.line, node->token.column, message);
    had_error = 1;
}

static TypeKind check_expr(SymTab *table, AstNode *node);

static void check_children_expr(SymTab *table, AstNode *node) {
    AstNode *child;
    for (child = node->children; child; child = child->next) {
        check_expr(table, child);
    }
}

static TypeKind check_binary(SymTab *table, AstNode *node) {
    TypeKind left = check_expr(table, node->left);
    TypeKind right = check_expr(table, node->right);
    TokenType op = node->token.type;

    if (op == TOK_PLUS || op == TOK_MINUS ||
        op == TOK_STAR || op == TOK_SLASH || op == TOK_PERCENT) {
        if (!type_is_numeric(left) || !type_is_numeric(right)) {
            report(node, "operator aritmetika memerlukan operand numerik");
            return TYPE_ERROR;
        }
        return type_arith(left, right);
    }

    if (op == TOK_LT || op == TOK_LE || op == TOK_GT ||
        op == TOK_GE) {
        if (!type_is_numeric(left) || !type_is_numeric(right)) {
            report(node, "operator relasional memerlukan operand numerik");
            return TYPE_ERROR;
        }
        return TYPE_BOOL;
    }

    if (op == TOK_EQ || op == TOK_NE || op == TOK_AND ||
        op == TOK_OR) {
        return TYPE_BOOL;
    }

    return TYPE_ERROR;
}

static TypeKind check_expr(SymTab *table, AstNode *node) {
    if (!node) {
        return TYPE_ERROR;
    }

    switch (node->kind) {
    case AST_IDENT: {
        Symbol *symbol = symtab_lookup(table, node->token.lexeme,
                                       node->token.length);
        if (!symbol) {
            char message[256];
            snprintf(message, sizeof(message),
                     "identifier '%.*s' tidak dideklarasikan",
                     node->token.length, node->token.lexeme);
            report(node, message);
            return TYPE_ERROR;
        }
        return symbol->type;
    }

    case AST_INT_LIT:    return TYPE_INT;
    case AST_FLOAT_LIT:  return TYPE_FLOAT;
    case AST_CHAR_LIT:   return TYPE_CHAR;
    case AST_STRING_LIT: return TYPE_STRING;

    case AST_BINARY:
        return check_binary(table, node);

    case AST_UNARY: {
        TypeKind operand = check_expr(table, node->right);
        if (node->token.type == TOK_NOT) {
            return TYPE_BOOL;
        }
        if (!type_is_numeric(operand)) {
            report(node, "operator unary memerlukan operand numerik");
            return TYPE_ERROR;
        }
        return operand;
    }

    case AST_CALL: {
        Symbol *symbol = symtab_lookup(table, node->token.lexeme,
                                       node->token.length);
        check_children_expr(table, node);
        if (!symbol) {
            char message[256];
            snprintf(message, sizeof(message),
                     "fungsi '%.*s' tidak dideklarasikan",
                     node->token.length, node->token.lexeme);
            report(node, message);
            return TYPE_ERROR;
        }
        if (node->token.length == 5 &&
            strncmp(node->token.lexeme, "print", 5) == 0) {
            return TYPE_VOID;
        }
        return symbol->type;
    }

    case AST_ASSIGN: {
        Symbol *symbol = symtab_lookup(table, node->token.lexeme,
                                       node->token.length);
        TypeKind value = check_expr(table, node->left);
        if (!symbol) {
            char message[256];
            snprintf(message, sizeof(message),
                     "identifier '%.*s' tidak dideklarasikan",
                     node->token.length, node->token.lexeme);
            report(node, message);
            return TYPE_ERROR;
        }
        if (!type_assignable(symbol->type, value)) {
            char message[256];
            snprintf(message, sizeof(message),
                     "tidak dapat menetapkan %s ke %s",
                     type_name(value), type_name(symbol->type));
            report(node, message);
            return TYPE_ERROR;
        }
        return symbol->type;
    }

    default:
        return TYPE_ERROR;
    }
}

static void check_block(SymTab *table, AstNode *node) {
    AstNode *child;
    symtab_enter_scope(table);
    for (child = node->children; child; child = child->next) {
        if (child->kind == AST_DECL) {
            TypeKind init_type = TYPE_ERROR;
            if (child->children) {
                init_type = check_expr(table, child->children);
            }
            if (symtab_lookup_current(table, child->token.lexeme,
                                      child->token.length)) {
                char message[256];
                snprintf(message, sizeof(message),
                         "identifier '%.*s' sudah dideklarasikan",
                         child->token.length, child->token.lexeme);
                report(child, message);
            } else {
                symtab_define(table, child->token.lexeme,
                              child->token.length, child->decl_type,
                              SYM_VAR, child->token.line,
                              child->token.column);
            }
            if (child->children &&
                !type_assignable(child->decl_type, init_type)) {
                char message[256];
                snprintf(message, sizeof(message),
                         "tidak dapat menetapkan %s ke %s",
                         type_name(init_type),
                         type_name(child->decl_type));
                report(child, message);
            }
        } else if (child->kind == AST_BLOCK) {
            check_block(table, child);
        } else {
            check_expr(table, child);
            check_children_expr(table, child);
        }
    }
    symtab_leave_scope(table);
}

static void check_topdecl(SymTab *table, AstNode *node) {
    AstNode *child;

    if (node->kind != AST_FUNC) {
        check_expr(table, node);
        return;
    }

    if (symtab_lookup_current(table, node->token.lexeme,
                              node->token.length)) {
        char message[256];
        snprintf(message, sizeof(message),
                 "fungsi '%.*s' sudah dideklarasikan",
                 node->token.length, node->token.lexeme);
        report(node, message);
        return;
    }

    symtab_define(table, node->token.lexeme, node->token.length,
                  node->decl_type, SYM_FUNC, node->token.line,
                  node->token.column);

    symtab_enter_scope(table);
    for (child = node->children; child; child = child->next) {
        if (child->kind == AST_PARAM) {
            if (symtab_lookup_current(table, child->token.lexeme,
                                      child->token.length)) {
                char message[256];
                snprintf(message, sizeof(message),
                         "parameter '%.*s' sudah dideklarasikan",
                         child->token.length, child->token.lexeme);
                report(child, message);
            } else {
                symtab_define(table, child->token.lexeme,
                              child->token.length, child->decl_type,
                              SYM_PARAM, child->token.line,
                              child->token.column);
            }
        } else if (child->kind == AST_BLOCK) {
            check_block(table, child);
        }
    }
    symtab_leave_scope(table);
}

int typecheck_program(SymTab *table, AstNode *root) {
    AstNode *child;
    had_error = 0;
    for (child = root->children; child; child = child->next) {
        check_topdecl(table, child);
    }
    return had_error;
}
