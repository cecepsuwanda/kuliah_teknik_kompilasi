// Berkas: src/token.c
#include "token.h"

const char *token_type_name(TokenType type) {
    switch (type) {
    case TOK_EOF:         return "EOF";
    case TOK_ERROR:       return "ERROR";

    case TOK_INT:         return "INT";
    case TOK_FLOAT:       return "FLOAT";
    case TOK_CHAR:        return "CHAR";
    case TOK_VOID:        return "VOID";
    case TOK_IF:          return "IF";
    case TOK_ELSE:        return "ELSE";
    case TOK_WHILE:       return "WHILE";
    case TOK_FOR:         return "FOR";
    case TOK_RETURN:      return "RETURN";
    case TOK_BREAK:       return "BREAK";
    case TOK_CONTINUE:    return "CONTINUE";
    case TOK_PRINT:       return "PRINT";

    case TOK_IDENT:       return "IDENT";
    case TOK_INT_LIT:     return "INT_LIT";
    case TOK_FLOAT_LIT:   return "FLOAT_LIT";
    case TOK_CHAR_LIT:    return "CHAR_LIT";
    case TOK_STRING_LIT:  return "STRING_LIT";

    case TOK_PLUS:        return "PLUS";
    case TOK_MINUS:       return "MINUS";
    case TOK_STAR:        return "STAR";
    case TOK_SLASH:       return "SLASH";
    case TOK_PERCENT:     return "PERCENT";
    case TOK_LT:          return "LT";
    case TOK_LE:          return "LE";
    case TOK_GT:          return "GT";
    case TOK_GE:          return "GE";
    case TOK_EQ:          return "EQ";
    case TOK_NE:          return "NE";
    case TOK_AND:         return "AND";
    case TOK_OR:          return "OR";
    case TOK_NOT:         return "NOT";
    case TOK_ASSIGN:      return "ASSIGN";

    case TOK_LPAREN:      return "LPAREN";
    case TOK_RPAREN:      return "RPAREN";
    case TOK_LBRACE:      return "LBRACE";
    case TOK_RBRACE:      return "RBRACE";
    case TOK_SEMI:        return "SEMI";
    case TOK_COMMA:       return "COMMA";

    default:              return "UNKNOWN";
    }
}
