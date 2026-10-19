// Berkas: src/lexer.c
// Lexer tangan untuk Subset-C.

#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "lexer.h"
#include "error.h"

static int peek(const Lexer *lexer) {
    if (lexer->pos >= lexer->length) {
        return EOF;
    }
    return (unsigned char)lexer->source[lexer->pos];
}

static int peek_next(const Lexer *lexer) {
    if (lexer->pos + 1 >= lexer->length) {
        return EOF;
    }
    return (unsigned char)lexer->source[lexer->pos + 1];
}

static int advance(Lexer *lexer) {
    int ch;
    if (lexer->pos >= lexer->length) {
        return EOF;
    }
    ch = (unsigned char)lexer->source[lexer->pos++];
    if (ch == '\n') {
        lexer->line++;
        lexer->column = 1;
    } else {
        lexer->column++;
    }
    return ch;
}

static Token make_token(Lexer *lexer, TokenType type, size_t start,
                        int line, int column) {
    Token token;
    token.type = type;
    token.lexeme = lexer->source + start;
    token.length = (int)(lexer->pos - start);
    token.line = line;
    token.column = column;
    token.value.int_value = 0;
    return token;
}

static void skip_space(Lexer *lexer) {
    for (;;) {
        int ch = peek(lexer);

        if (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n') {
            advance(lexer);
            continue;
        }

        if (ch == '/' && peek_next(lexer) == '/') {
            advance(lexer);
            advance(lexer);
            while (peek(lexer) != EOF && peek(lexer) != '\n') {
                advance(lexer);
            }
            continue;
        }

        if (ch == '/' && peek_next(lexer) == '*') {
            int start_line = lexer->line;
            int start_column = lexer->column;
            int closed = 0;

            advance(lexer);
            advance(lexer);
            while (peek(lexer) != EOF) {
                if (peek(lexer) == '*' && peek_next(lexer) == '/') {
                    advance(lexer);
                    advance(lexer);
                    closed = 1;
                    break;
                }
                advance(lexer);
            }
            if (!closed) {
                error_at(lexer->filename, start_line, start_column,
                         "komentar blok tidak ditutup");
                lexer->had_error = 1;
            }
            continue;
        }

        break;
    }
}

static TokenType keyword_type(const char *text, int length) {
    static const struct {
        const char *word;
        TokenType type;
    } keywords[] = {
        {"int", TOK_INT},
        {"float", TOK_FLOAT},
        {"char", TOK_CHAR},
        {"void", TOK_VOID},
        {"if", TOK_IF},
        {"else", TOK_ELSE},
        {"while", TOK_WHILE},
        {"for", TOK_FOR},
        {"return", TOK_RETURN},
        {"break", TOK_BREAK},
        {"continue", TOK_CONTINUE},
        {"print", TOK_PRINT}
    };
    size_t i;

    for (i = 0; i < sizeof(keywords) / sizeof(keywords[0]); i++) {
        if ((int)strlen(keywords[i].word) == length &&
            strncmp(keywords[i].word, text, (size_t)length) == 0) {
            return keywords[i].type;
        }
    }
    return TOK_IDENT;
}

static int escape_value(int ch) {
    switch (ch) {
    case 'n':  return '\n';
    case 't':  return '\t';
    case 'r':  return '\r';
    case '\\': return '\\';
    case '\'': return '\'';
    case '"':  return '"';
    case '0':  return '\0';
    default:   return ch;
    }
}

void lexer_init(Lexer *lexer, const char *source, const char *filename) {
    lexer->source = source;
    lexer->length = strlen(source);
    lexer->pos = 0;
    lexer->line = 1;
    lexer->column = 1;
    lexer->filename = filename;
    lexer->had_error = 0;
}

Token lexer_next(Lexer *lexer) {
    int line;
    int column;
    size_t start;
    int ch;

    skip_space(lexer);

    line = lexer->line;
    column = lexer->column;
    start = lexer->pos;
    ch = peek(lexer);

    if (ch == EOF) {
        return make_token(lexer, TOK_EOF, start, line, column);
    }

    if (isalpha((unsigned char)ch) || ch == '_') {
        TokenType type;

        advance(lexer);
        while (isalnum((unsigned char)peek(lexer)) ||
               peek(lexer) == '_') {
            advance(lexer);
        }
        type = keyword_type(lexer->source + start,
                            (int)(lexer->pos - start));
        return make_token(lexer, type, start, line, column);
    }

    if (isdigit((unsigned char)ch)) {
        int is_float = 0;
        Token token;
        char buffer[64];
        int length;

        while (isdigit((unsigned char)peek(lexer))) {
            advance(lexer);
        }
        if (peek(lexer) == '.' &&
            isdigit((unsigned char)peek_next(lexer))) {
            is_float = 1;
            advance(lexer);
            while (isdigit((unsigned char)peek(lexer))) {
                advance(lexer);
            }
        }

        token = make_token(lexer,
                           is_float ? TOK_FLOAT_LIT : TOK_INT_LIT,
                           start, line, column);
        length = token.length < 63 ? token.length : 63;
        memcpy(buffer, token.lexeme, (size_t)length);
        buffer[length] = '\0';

        if (is_float) {
            token.value.float_value = strtod(buffer, NULL);
        } else {
            token.value.int_value = strtol(buffer, NULL, 10);
        }
        return token;
    }

    if (ch == '\'') {
        int value = 0;
        Token token;

        advance(lexer);
        if (peek(lexer) == '\\') {
            advance(lexer);
            if (peek(lexer) == EOF) {
                error_at(lexer->filename, line, column,
                         "literal karakter tidak lengkap");
                lexer->had_error = 1;
                return make_token(lexer, TOK_ERROR, start, line, column);
            }
            value = escape_value(peek(lexer));
            advance(lexer);
        } else if (peek(lexer) != EOF && peek(lexer) != '\'' &&
                   peek(lexer) != '\n') {
            value = peek(lexer);
            advance(lexer);
        } else {
            error_at(lexer->filename, line, column,
                     "literal karakter kosong");
            lexer->had_error = 1;
            return make_token(lexer, TOK_ERROR, start, line, column);
        }

        if (peek(lexer) != '\'') {
            error_at(lexer->filename, line, column,
                     "literal karakter tidak ditutup");
            lexer->had_error = 1;
            return make_token(lexer, TOK_ERROR, start, line, column);
        }
        advance(lexer);

        token = make_token(lexer, TOK_CHAR_LIT, start, line, column);
        token.value.char_value = value;
        return token;
    }

    if (ch == '"') {
        advance(lexer);
        while (peek(lexer) != EOF && peek(lexer) != '"' &&
               peek(lexer) != '\n') {
            if (peek(lexer) == '\\') {
                advance(lexer);
                if (peek(lexer) != EOF && peek(lexer) != '\n') {
                    advance(lexer);
                }
            } else {
                advance(lexer);
            }
        }
        if (peek(lexer) == '"') {
            advance(lexer);
            return make_token(lexer, TOK_STRING_LIT, start, line, column);
        }
        error_at(lexer->filename, line, column,
                 "string tidak ditutup");
        lexer->had_error = 1;
        return make_token(lexer, TOK_ERROR, start, line, column);
    }

    advance(lexer);

    switch (ch) {
    case '+': return make_token(lexer, TOK_PLUS, start, line, column);
    case '-': return make_token(lexer, TOK_MINUS, start, line, column);
    case '*': return make_token(lexer, TOK_STAR, start, line, column);
    case '/': return make_token(lexer, TOK_SLASH, start, line, column);
    case '%': return make_token(lexer, TOK_PERCENT, start, line, column);
    case '(': return make_token(lexer, TOK_LPAREN, start, line, column);
    case ')': return make_token(lexer, TOK_RPAREN, start, line, column);
    case '{': return make_token(lexer, TOK_LBRACE, start, line, column);
    case '}': return make_token(lexer, TOK_RBRACE, start, line, column);
    case ';': return make_token(lexer, TOK_SEMI, start, line, column);
    case ',': return make_token(lexer, TOK_COMMA, start, line, column);

    case '<':
        if (peek(lexer) == '=') {
            advance(lexer);
            return make_token(lexer, TOK_LE, start, line, column);
        }
        return make_token(lexer, TOK_LT, start, line, column);

    case '>':
        if (peek(lexer) == '=') {
            advance(lexer);
            return make_token(lexer, TOK_GE, start, line, column);
        }
        return make_token(lexer, TOK_GT, start, line, column);

    case '=':
        if (peek(lexer) == '=') {
            advance(lexer);
            return make_token(lexer, TOK_EQ, start, line, column);
        }
        return make_token(lexer, TOK_ASSIGN, start, line, column);

    case '!':
        if (peek(lexer) == '=') {
            advance(lexer);
            return make_token(lexer, TOK_NE, start, line, column);
        }
        return make_token(lexer, TOK_NOT, start, line, column);

    case '&':
        if (peek(lexer) == '&') {
            advance(lexer);
            return make_token(lexer, TOK_AND, start, line, column);
        }
        error_at(lexer->filename, line, column,
                 "operator '&' tidak dikenal");
        lexer->had_error = 1;
        return make_token(lexer, TOK_ERROR, start, line, column);

    case '|':
        if (peek(lexer) == '|') {
            advance(lexer);
            return make_token(lexer, TOK_OR, start, line, column);
        }
        error_at(lexer->filename, line, column,
                 "operator '|' tidak dikenal");
        lexer->had_error = 1;
        return make_token(lexer, TOK_ERROR, start, line, column);

    default:
        error_at(lexer->filename, line, column,
                 "karakter tidak dikenal");
        lexer->had_error = 1;
        return make_token(lexer, TOK_ERROR, start, line, column);
    }
}

void token_print(FILE *out, const Token *token) {
    if (token->type == TOK_EOF) {
        fprintf(out, "%d:%d EOF\n", token->line, token->column);
        return;
    }
    fprintf(out, "%d:%d %s %.*s\n",
            token->line, token->column,
            token_type_name(token->type),
            token->length, token->lexeme);
}
