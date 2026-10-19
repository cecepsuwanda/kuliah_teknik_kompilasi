%{
/* Berkas: src/parser.y
 * Grammar Bison untuk Subset-C (versi inti).
 * Membangun AST melalui semantic action.
 *
 * Build:
 *   bison -d -o build/parser.tab.c src/parser.y
 *   gcc -Iinclude -Ibuild build/parser.tab.c src/token.c \
 *       src/error.c src/lexer.c src/ast.c src/main_bison.c \
 *       -o build/scc
 */
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

void yyerror(const char *message);
int yylex(void);
%}

%code requires {
#include "ast.h"
}

%union {
    Token token;
    AstNode *node;
}

%token <token> T_INT T_FLOAT T_CHAR T_VOID
%token <token> T_IF T_ELSE T_WHILE T_FOR T_RETURN T_BREAK T_CONTINUE T_PRINT
%token <token> T_IDENT T_INT_LIT T_FLOAT_LIT T_CHAR_LIT T_STRING_LIT
%token <token> T_PLUS T_MINUS T_STAR T_SLASH T_PERCENT
%token <token> T_LT T_LE T_GT T_GE T_EQ T_NE T_AND T_OR T_NOT T_ASSIGN
%token <token> T_LPAREN T_RPAREN T_LBRACE T_RBRACE T_SEMI T_COMMA
%token <token> T_EOF

%type <node> program stmt_list stmt block assign_or_call
%type <node> expr logor logand equality relation additive term unary primary
%type <node> opt_expr args args_tail

%left T_OR
%left T_AND
%left T_EQ T_NE
%left T_LT T_LE T_GT T_GE
%left T_PLUS T_MINUS
%left T_STAR T_SLASH T_PERCENT
%right T_NOT UMINUS

%start program

%%

program
    : stmt_list T_EOF
        {
            $$ = ast_new(AST_PROGRAM, $2.token);
            AstNode *child = $1;
            while (child) {
                AstNode *next = child->next;
                child->next = NULL;
                ast_add_child($$, child);
                child = next;
            }
        }
    ;

stmt_list
    : %empty
        { $$ = NULL; }
    | stmt_list stmt
        {
            if ($1) {
                AstNode *last = $1;
                while (last->next) {
                    last = last->next;
                }
                last->next = $2;
                $$ = $1;
            } else {
                $$ = $2;
            }
        }
    ;

stmt
    : expr T_SEMI
        {
            $$ = ast_new(AST_EXPR_STMT, $2.token);
            ast_add_child($$, $1);
        }
    | T_IDENT T_ASSIGN expr T_SEMI
        {
            $$ = ast_new(AST_ASSIGN, $1.token);
            ast_add_child($$, $3);
        }
    | T_IDENT assign_or_call T_SEMI
        { $$ = $2; }
    | block
        { $$ = $1; }
    | T_IF T_LPAREN expr T_RPAREN stmt
        {
            $$ = ast_new(AST_IF, $1.token);
            ast_add_child($$, $3);
            ast_add_child($$, $5);
        }
    | T_IF T_LPAREN expr T_RPAREN stmt T_ELSE stmt
        {
            $$ = ast_new(AST_IF, $1.token);
            ast_add_child($$, $3);
            ast_add_child($$, $5);
            ast_add_child($$, $7);
        }
    | T_WHILE T_LPAREN expr T_RPAREN stmt
        {
            $$ = ast_new(AST_WHILE, $1.token);
            ast_add_child($$, $3);
            ast_add_child($$, $5);
        }
    | T_RETURN opt_expr T_SEMI
        {
            $$ = ast_new(AST_RETURN, $1.token);
            if ($2) {
                ast_add_child($$, $2);
            }
        }
    | T_PRINT T_LPAREN expr T_RPAREN T_SEMI
        {
            $$ = ast_new(AST_PRINT, $1.token);
            ast_add_child($$, $3);
        }
    | T_SEMI
        { $$ = ast_new(AST_EMPTY, $1.token); }
    ;

assign_or_call
    : T_ASSIGN expr
        {
            $$ = ast_new(AST_ASSIGN, $1.token);
            ast_add_child($$, $2);
        }
    | T_LPAREN args T_RPAREN
        {
            $$ = ast_new(AST_CALL, $1.token);
            AstNode *arg = $2;
            while (arg) {
                AstNode *next = arg->next;
                arg->next = NULL;
                ast_add_child($$, arg);
                arg = next;
            }
        }
    ;

block
    : T_LBRACE stmt_list T_RBRACE
        {
            $$ = ast_new(AST_BLOCK, $1.token);
            AstNode *child = $2;
            while (child) {
                AstNode *next = child->next;
                child->next = NULL;
                ast_add_child($$, child);
                child = next;
            }
        }
    ;

opt_expr
    : %empty { $$ = NULL; }
    | expr   { $$ = $1; }
    ;

expr    : logor        { $$ = $1; } ;
logor   : logand       { $$ = $1; }
        | logor T_OR logand
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        ;
logand  : equality     { $$ = $1; }
        | logand T_AND equality
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        ;
equality : relation    { $$ = $1; }
        | equality T_EQ relation
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | equality T_NE relation
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        ;
relation : additive    { $$ = $1; }
        | relation T_LT additive
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | relation T_LE additive
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | relation T_GT additive
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | relation T_GE additive
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        ;
additive : term        { $$ = $1; }
        | additive T_PLUS term
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | additive T_MINUS term
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        ;
term    : unary        { $$ = $1; }
        | term T_STAR unary
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | term T_SLASH unary
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        | term T_PERCENT unary
            {
                $$ = ast_new(AST_BINARY, $2.token);
                $$->left = $1;
                $$->right = $3;
            }
        ;
unary   : T_NOT unary
            {
                $$ = ast_new(AST_UNARY, $1.token);
                $$->right = $2;
            }
        | T_MINUS unary %prec UMINUS
            {
                $$ = ast_new(AST_UNARY, $1.token);
                $$->right = $2;
            }
        | T_PLUS unary
            {
                $$ = ast_new(AST_UNARY, $1.token);
                $$->right = $2;
            }
        | primary      { $$ = $1; }
        ;
primary : T_INT_LIT     { $$ = ast_new(AST_INT_LIT, $1.token); }
        | T_FLOAT_LIT   { $$ = ast_new(AST_FLOAT_LIT, $1.token); }
        | T_CHAR_LIT    { $$ = ast_new(AST_CHAR_LIT, $1.token); }
        | T_STRING_LIT  { $$ = ast_new(AST_STRING_LIT, $1.token); }
        | T_IDENT       { $$ = ast_new(AST_IDENT, $1.token); }
        | T_IDENT T_LPAREN args T_RPAREN
            {
                $$ = ast_new(AST_CALL, $1.token);
                AstNode *arg = $3;
                while (arg) {
                    AstNode *next = arg->next;
                    arg->next = NULL;
                    ast_add_child($$, arg);
                    arg = next;
                }
            }
        | T_LPAREN expr T_RPAREN
            { $$ = $2; }
        ;
args    : %empty { $$ = NULL; }
        | expr args_tail
            {
                $1->next = $2;
                $$ = $1;
            }
        ;
args_tail : %empty { $$ = NULL; }
        | T_COMMA expr args_tail
            {
                $2->next = $3;
                $$ = $2;
            }
        ;

%%

void yyerror(const char *message) {
    fprintf(stderr, "syntax error: %s\n", message);
}
