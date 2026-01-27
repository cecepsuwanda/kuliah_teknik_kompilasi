%{
#include "simplec.tab.h"
#include <string.h>
%}

%%
"int"       { return INT; }
"float"     { return FLOAT; }
"print"     { return PRINT; }
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.strval = strdup(yytext);
    return IDENTIFIER;
}
[0-9]+      { yylval.intval = atoi(yytext); return NUMBER; }
[0-9]+\.[0-9]+ { yylval.dval = atof(yytext); return FLOAT_LITERAL; }
[ \t\n]     { /* skip */ }
"="         { return ASSIGN; }
";"         { return SEMICOLON; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULTIPLY; }
"/"         { return DIVIDE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
.           { return yytext[0]; }
%%

int yywrap() { return 1; }
