// Berkas: src/parser.c
// Recursive descent parser untuk subset Subset-C.

#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
#include "error.h"

static void advance(Parser *parser) {
    parser->current = lexer_next(&parser->lexer);
}

static int check(const Parser *parser, TokenType type) {
    return parser->current.type == type;
}

static int match(Parser *parser, TokenType type) {
    if (check(parser, type)) {
        advance(parser);
        return 1;
    }
    return 0;
}

static void error(Parser *parser, const char *message) {
    error_at(parser->lexer.filename, parser->current.line,
             parser->current.column, message);
    parser->had_error = 1;
}

static Token expect(Parser *parser, TokenType type,
                    const char *message) {
    Token token = parser->current;
    if (check(parser, type)) {
        advance(parser);
        return token;
    }
    error(parser, message);
    return token;
}

static void synchronize(Parser *parser) {
    while (!check(parser, TOK_EOF) &&
           !check(parser, TOK_SEMI) &&
           !check(parser, TOK_RBRACE)) {
        advance(parser);
    }
    if (check(parser, TOK_SEMI)) {
        advance(parser);
    }
}

static int is_type(TokenType type) {
    return type == TOK_INT || type == TOK_FLOAT ||
           type == TOK_CHAR || type == TOK_VOID;
}

static TypeKind type_from_token(TokenType type) {
    switch (type) {
    case TOK_INT:   return TYPE_INT;
    case TOK_FLOAT: return TYPE_FLOAT;
    case TOK_CHAR:  return TYPE_CHAR;
    case TOK_VOID:  return TYPE_VOID;
    default:        return TYPE_ERROR;
    }
}

static AstNode *parse_block(Parser *parser);
static AstNode *parse_stmt(Parser *parser);
static AstNode *parse_expr(Parser *parser);

static AstNode *parse_expr_level(Parser *parser,
                                 AstNode *(*next)(Parser *),
                                 const TokenType *operators,
                                 int count) {
    AstNode *left = next(parser);

    for (;;) {
        int i;
        int found = 0;
        Token op;

        for (i = 0; i < count; i++) {
            if (check(parser, operators[i])) {
                found = 1;
                break;
            }
        }
        if (!found) {
            break;
        }

        op = parser->current;
        advance(parser);

        {
            AstNode *right = next(parser);
            AstNode *node = ast_new(AST_BINARY, op);
            node->left = left;
            node->right = right;
            left = node;
        }
    }
    return left;
}

static AstNode *parse_primary(Parser *parser) {
    Token token = parser->current;

    if (check(parser, TOK_INT_LIT) || check(parser, TOK_FLOAT_LIT) ||
        check(parser, TOK_CHAR_LIT) || check(parser, TOK_STRING_LIT)) {
        AstKind kind = AST_INT_LIT;
        if (token.type == TOK_FLOAT_LIT) {
            kind = AST_FLOAT_LIT;
        } else if (token.type == TOK_CHAR_LIT) {
            kind = AST_CHAR_LIT;
        } else if (token.type == TOK_STRING_LIT) {
            kind = AST_STRING_LIT;
        }
        advance(parser);
        return ast_new(kind, token);
    }

    if (check(parser, TOK_IDENT)) {
        AstNode *node;
        advance(parser);
        if (match(parser, TOK_LPAREN)) {
            node = ast_new(AST_CALL, token);
            if (!check(parser, TOK_RPAREN)) {
                ast_add_child(node, parse_expr(parser));
                while (match(parser, TOK_COMMA)) {
                    ast_add_child(node, parse_expr(parser));
                }
            }
            expect(parser, TOK_RPAREN, "diharapkan ')'");
            return node;
        }
        return ast_new(AST_IDENT, token);
    }

    if (match(parser, TOK_LPAREN)) {
        AstNode *node = parse_expr(parser);
        expect(parser, TOK_RPAREN, "diharapkan ')'");
        return node;
    }

    error(parser, "diharapkan ekspresi");
    advance(parser);
    return ast_new(AST_IDENT, token);
}

static AstNode *parse_unary(Parser *parser) {
    if (check(parser, TOK_NOT) || check(parser, TOK_MINUS) ||
        check(parser, TOK_PLUS)) {
        Token op = parser->current;
        AstNode *node;
        advance(parser);
        node = ast_new(AST_UNARY, op);
        node->right = parse_unary(parser);
        return node;
    }
    return parse_primary(parser);
}

static AstNode *parse_term(Parser *parser) {
    static const TokenType ops[] = {
        TOK_STAR, TOK_SLASH, TOK_PERCENT
    };
    return parse_expr_level(parser, parse_unary, ops, 3);
}

static AstNode *parse_additive(Parser *parser) {
    static const TokenType ops[] = {TOK_PLUS, TOK_MINUS};
    return parse_expr_level(parser, parse_term, ops, 2);
}

static AstNode *parse_relation(Parser *parser) {
    static const TokenType ops[] = {
        TOK_LT, TOK_LE, TOK_GT, TOK_GE
    };
    return parse_expr_level(parser, parse_additive, ops, 4);
}

static AstNode *parse_equality(Parser *parser) {
    static const TokenType ops[] = {TOK_EQ, TOK_NE};
    return parse_expr_level(parser, parse_relation, ops, 2);
}

static AstNode *parse_logand(Parser *parser) {
    static const TokenType ops[] = {TOK_AND};
    return parse_expr_level(parser, parse_equality, ops, 1);
}

static AstNode *parse_logor(Parser *parser) {
    static const TokenType ops[] = {TOK_OR};
    return parse_expr_level(parser, parse_logand, ops, 1);
}

static AstNode *parse_expr(Parser *parser) {
    return parse_logor(parser);
}

static AstNode *parse_decl(Parser *parser) {
    Token type_token = parser->current;
    AstNode *node;
    Token name;

    advance(parser);
    name = expect(parser, TOK_IDENT, "diharapkan nama variabel");
    node = ast_new(AST_DECL, name);
    node->decl_type = type_from_token(type_token.type);

    if (match(parser, TOK_ASSIGN)) {
        ast_add_child(node, parse_expr(parser));
    }
    return node;
}

static AstNode *parse_if(Parser *parser) {
    AstNode *node = ast_new(AST_IF, parser->current);

    advance(parser);
    expect(parser, TOK_LPAREN, "diharapkan '(' setelah if");
    ast_add_child(node, parse_expr(parser));
    expect(parser, TOK_RPAREN, "diharapkan ')' setelah kondisi");
    ast_add_child(node, parse_stmt(parser));
    if (match(parser, TOK_ELSE)) {
        ast_add_child(node, parse_stmt(parser));
    }
    return node;
}

static AstNode *parse_while(Parser *parser) {
    AstNode *node = ast_new(AST_WHILE, parser->current);

    advance(parser);
    expect(parser, TOK_LPAREN, "diharapkan '(' setelah while");
    ast_add_child(node, parse_expr(parser));
    expect(parser, TOK_RPAREN, "diharapkan ')' setelah kondisi");
    ast_add_child(node, parse_stmt(parser));
    return node;
}

static AstNode *parse_for(Parser *parser) {
    AstNode *node = ast_new(AST_FOR, parser->current);

    advance(parser);
    expect(parser, TOK_LPAREN, "diharapkan '(' setelah for");

    if (!check(parser, TOK_SEMI)) {
        ast_add_child(node, parse_expr(parser));
    }
    expect(parser, TOK_SEMI, "diharapkan ';' pada for");

    if (!check(parser, TOK_SEMI)) {
        ast_add_child(node, parse_expr(parser));
    }
    expect(parser, TOK_SEMI, "diharapkan ';' pada for");

    if (!check(parser, TOK_RPAREN)) {
        ast_add_child(node, parse_expr(parser));
    }
    expect(parser, TOK_RPAREN, "diharapkan ')' pada for");
    ast_add_child(node, parse_stmt(parser));
    return node;
}

static AstNode *parse_id_stmt(Parser *parser) {
    Token name = parser->current;
    AstNode *node;

    advance(parser);

    if (match(parser, TOK_ASSIGN)) {
        node = ast_new(AST_ASSIGN, name);
        ast_add_child(node, parse_expr(parser));
        return node;
    }

    if (match(parser, TOK_LPAREN)) {
        node = ast_new(AST_CALL, name);
        if (!check(parser, TOK_RPAREN)) {
            ast_add_child(node, parse_expr(parser));
            while (match(parser, TOK_COMMA)) {
                ast_add_child(node, parse_expr(parser));
            }
        }
        expect(parser, TOK_RPAREN, "diharapkan ')'");
        return node;
    }

    error(parser, "diharapkan '=' atau '(' setelah identifier");
    return ast_new(AST_IDENT, name);
}

static AstNode *parse_stmt(Parser *parser) {
    Token token = parser->current;

    if (is_type(token.type)) {
        AstNode *node = parse_decl(parser);
        expect(parser, TOK_SEMI, "diharapkan ';' setelah deklarasi");
        return node;
    }

    if (check(parser, TOK_LBRACE)) {
        return parse_block(parser);
    }

    if (check(parser, TOK_IF)) {
        return parse_if(parser);
    }

    if (check(parser, TOK_WHILE)) {
        return parse_while(parser);
    }

    if (check(parser, TOK_FOR)) {
        return parse_for(parser);
    }

    if (check(parser, TOK_RETURN)) {
        AstNode *node = ast_new(AST_RETURN, token);
        advance(parser);
        if (!check(parser, TOK_SEMI)) {
            ast_add_child(node, parse_expr(parser));
        }
        expect(parser, TOK_SEMI, "diharapkan ';' setelah return");
        return node;
    }

    if (check(parser, TOK_BREAK)) {
        AstNode *node = ast_new(AST_BREAK, token);
        advance(parser);
        expect(parser, TOK_SEMI, "diharapkan ';' setelah break");
        return node;
    }

    if (check(parser, TOK_CONTINUE)) {
        AstNode *node = ast_new(AST_CONTINUE, token);
        advance(parser);
        expect(parser, TOK_SEMI, "diharapkan ';' setelah continue");
        return node;
    }

    if (check(parser, TOK_PRINT)) {
        AstNode *node = ast_new(AST_PRINT, token);
        advance(parser);
        expect(parser, TOK_LPAREN, "diharapkan '(' setelah print");
        ast_add_child(node, parse_expr(parser));
        expect(parser, TOK_RPAREN, "diharapkan ')' setelah print");
        expect(parser, TOK_SEMI, "diharapkan ';' setelah print");
        return node;
    }

    if (check(parser, TOK_SEMI)) {
        advance(parser);
        return ast_new(AST_EMPTY, token);
    }

    if (check(parser, TOK_IDENT)) {
        AstNode *node = parse_id_stmt(parser);
        expect(parser, TOK_SEMI, "diharapkan ';' setelah pernyataan");
        return node;
    }

    {
        AstNode *node = ast_new(AST_EXPR_STMT, token);
        ast_add_child(node, parse_expr(parser));
        expect(parser, TOK_SEMI, "diharapkan ';' setelah ekspresi");
        return node;
    }
}

static AstNode *parse_block(Parser *parser) {
    AstNode *node = ast_new(AST_BLOCK, parser->current);

    expect(parser, TOK_LBRACE, "diharapkan '{'");
    while (!check(parser, TOK_RBRACE) && !check(parser, TOK_EOF)) {
        AstNode *stmt = parse_stmt(parser);
        ast_add_child(node, stmt);
        if (parser->had_error) {
            synchronize(parser);
        }
    }
    expect(parser, TOK_RBRACE, "diharapkan '}'");
    return node;
}

static AstNode *parse_topdecl(Parser *parser) {
    Token type_token = parser->current;
    Token name;
    AstNode *node;

    if (!is_type(type_token.type)) {
        error(parser, "diharapkan tipe pada deklarasi");
        advance(parser);
        return NULL;
    }

    advance(parser);
    name = expect(parser, TOK_IDENT, "diharapkan nama fungsi");
    node = ast_new(AST_FUNC, name);
    node->decl_type = type_from_token(type_token.type);

    expect(parser, TOK_LPAREN, "diharapkan '('");
    if (!check(parser, TOK_RPAREN)) {
        if (is_type(parser->current.type)) {
            Token param_type = parser->current;
            Token param_name;
            advance(parser);
            param_name = expect(parser, TOK_IDENT,
                                "diharapkan nama parameter");
            {
                AstNode *param = ast_new(AST_PARAM, param_name);
                param->decl_type = type_from_token(param_type.type);
                ast_add_child(node, param);
            }
            while (match(parser, TOK_COMMA)) {
                if (is_type(parser->current.type)) {
                    param_type = parser->current;
                    advance(parser);
                }
                param_name = expect(parser, TOK_IDENT,
                                    "diharapkan nama parameter");
                {
                    AstNode *param = ast_new(AST_PARAM, param_name);
                    param->decl_type = type_from_token(param_type.type);
                    ast_add_child(node, param);
                }
            }
        }
    }
    expect(parser, TOK_RPAREN, "diharapkan ')'");

    if (check(parser, TOK_LBRACE)) {
        ast_add_child(node, parse_block(parser));
    } else {
        expect(parser, TOK_SEMI, "diharapkan '{' atau ';'");
    }
    return node;
}

void parser_init(Parser *parser, const char *source,
                 const char *filename) {
    lexer_init(&parser->lexer, source, filename);
    parser->had_error = 0;
    parser->current = lexer_next(&parser->lexer);
}

AstNode *parser_program(Parser *parser) {
    AstNode *program = ast_new(AST_PROGRAM, parser->current);

    while (!check(parser, TOK_EOF)) {
        AstNode *decl = parse_topdecl(parser);
        if (decl) {
            ast_add_child(program, decl);
        }
        if (parser->had_error) {
            synchronize(parser);
        }
    }
    return program;
}
