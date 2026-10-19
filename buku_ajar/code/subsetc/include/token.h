// Berkas: include/token.h
// Definisi jenis token dan struktur Token untuk Subset-C.

#ifndef SUBSETC_TOKEN_H
#define SUBSETC_TOKEN_H

typedef enum {
    TOK_EOF = 0,
    TOK_ERROR,

    /* Kata kunci */
    TOK_INT,
    TOK_FLOAT,
    TOK_CHAR,
    TOK_VOID,
    TOK_IF,
    TOK_ELSE,
    TOK_WHILE,
    TOK_FOR,
    TOK_RETURN,
    TOK_BREAK,
    TOK_CONTINUE,
    TOK_PRINT,

    /* Identifier dan literal */
    TOK_IDENT,
    TOK_INT_LIT,
    TOK_FLOAT_LIT,
    TOK_CHAR_LIT,
    TOK_STRING_LIT,

    /* Operator */
    TOK_PLUS,
    TOK_MINUS,
    TOK_STAR,
    TOK_SLASH,
    TOK_PERCENT,
    TOK_LT,
    TOK_LE,
    TOK_GT,
    TOK_GE,
    TOK_EQ,
    TOK_NE,
    TOK_AND,
    TOK_OR,
    TOK_NOT,
    TOK_ASSIGN,

    /* Tanda baca */
    TOK_LPAREN,
    TOK_RPAREN,
    TOK_LBRACE,
    TOK_RBRACE,
    TOK_SEMI,
    TOK_COMMA
} TokenType;

typedef struct {
    TokenType type;
    const char *lexeme;
    int length;
    int line;
    int column;
    union {
        long int_value;
        double float_value;
        int char_value;
    } value;
} Token;

/* Nama token untuk keluaran diagnostik dan tes. */
const char *token_type_name(TokenType type);

#endif /* SUBSETC_TOKEN_H */
