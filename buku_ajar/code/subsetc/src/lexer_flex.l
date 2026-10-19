%{
/* Berkas: src/lexer_flex.l
 * Lexer Subset-C dengan Flex. Kompilasi:
 *   flex -o build/lexer_flex.c src/lexer_flex.l
 *   gcc -Iinclude build/lexer_flex.c src/token.c src/error.c \
 *       -o build/lexer_flex
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "token.h"
#include "error.h"

static int had_error = 0;

#define YY_DECL int sc_lex(void)
%}

%option noyywrap nounput noinput yylineno

%{
static void report(const char *message) {
    error_at("<flex>", (int)yylineno, 1, message);
    had_error = 1;
}
%}

DIGIT   [0-9]
ID      [A-Za-z_][A-Za-z0-9_]*

%%

[ \t\r\n]+              { /* abaikan */ }

"//"[^\n]*              { /* komentar baris */ }

"/*"([^*]|\*+[^*/])*\*+"/" { /* komentar blok */ }

"int"                   { return TOK_INT; }
"float"                 { return TOK_FLOAT; }
"char"                  { return TOK_CHAR; }
"void"                  { return TOK_VOID; }
"if"                    { return TOK_IF; }
"else"                  { return TOK_ELSE; }
"while"                 { return TOK_WHILE; }
"for"                   { return TOK_FOR; }
"return"                { return TOK_RETURN; }
"break"                 { return TOK_BREAK; }
"continue"              { return TOK_CONTINUE; }
"print"                 { return TOK_PRINT; }

"<="                    { return TOK_LE; }
">="                    { return TOK_GE; }
"=="                    { return TOK_EQ; }
"!="                    { return TOK_NE; }
"&&"                    { return TOK_AND; }
"||"                    { return TOK_OR; }

"+"                     { return TOK_PLUS; }
"-"                     { return TOK_MINUS; }
"*"                     { return TOK_STAR; }
"/"                     { return TOK_SLASH; }
"%"                     { return TOK_PERCENT; }
"<"                     { return TOK_LT; }
">"                     { return TOK_GT; }
"!"                     { return TOK_NOT; }
"="                     { return TOK_ASSIGN; }
"("                     { return TOK_LPAREN; }
")"                     { return TOK_RPAREN; }
"{"                     { return TOK_LBRACE; }
"}"                     { return TOK_RBRACE; }
";"                     { return TOK_SEMI; }
","                     { return TOK_COMMA; }

{DIGIT}+"."{DIGIT}+     { return TOK_FLOAT_LIT; }
{DIGIT}+                { return TOK_INT_LIT; }

"'"([^'\\]|\\.)"'"     { return TOK_CHAR_LIT; }

"\""([^"\\]|\\.)*"\""   { return TOK_STRING_LIT; }

{ID}                    { return TOK_IDENT; }

.                       { report("karakter tidak dikenal");
                          return TOK_ERROR; }

%%

#ifdef FLEX_MAIN
int main(int argc, char **argv) {
    int token;
    if (argc != 2) {
        fprintf(stderr, "penggunaan: %s berkas.sc\n", argv[0]);
        return 2;
    }
    yyin = fopen(argv[1], "rb");
    if (!yyin) {
        perror(argv[1]);
        return 2;
    }
    while ((token = sc_lex()) != 0) {
        printf("FLEX %s %s\n", token_type_name((TokenType)token), yytext);
    }
    fclose(yyin);
    return had_error ? 1 : 0;
}
#endif
