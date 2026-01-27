%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
void yyerror(const char *s);

typedef struct {
    char *name;
    int type;  /* 0 = int, 1 = float */
    union {
        int intval;
        double dval;
    } value;
} Symbol;

Symbol symbols[100];
int sym_count = 0;
%}

%union {
    int intval;
    double dval;
    char *strval;
}

%token <intval> NUMBER
%token <dval> FLOAT_LITERAL
%token <strval> IDENTIFIER
%token INT FLOAT PRINT ASSIGN SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN

%left PLUS MINUS
%left MULTIPLY DIVIDE

%type <dval> expr

%%
program:
    /* empty */
  | program statement
  ;

statement:
    declaration SEMICOLON
  | assignment SEMICOLON
  | print_stmt SEMICOLON
  ;

declaration:
    INT IDENTIFIER {
        symbols[sym_count].name = strdup($2);
        symbols[sym_count].type = 0;
        sym_count++;
        printf("Declared int variable: %s\n", $2);
    }
  | FLOAT IDENTIFIER {
        symbols[sym_count].name = strdup($2);
        symbols[sym_count].type = 1;
        sym_count++;
        printf("Declared float variable: %s\n", $2);
    }
  ;

assignment:
    IDENTIFIER ASSIGN expr {
        printf("Assigning %g to %s\n", $3, $1);
    }
  ;

print_stmt:
    PRINT expr {
        printf("Print: %g\n", $2);
    }
  ;

expr:
    NUMBER { $$ = (double)$1; }
  | FLOAT_LITERAL { $$ = $1; }
  | IDENTIFIER { $$ = 0.0; /* simplified lookup */ }
  | expr PLUS expr { $$ = $1 + $3; }
  | expr MINUS expr { $$ = $1 - $3; }
  | expr MULTIPLY expr { $$ = $1 * $3; }
  | expr DIVIDE expr {
        if ($3 == 0.0) {
            yyerror("Division by zero");
            $$ = 0.0;
        } else {
            $$ = $1 / $3;
        }
    }
  | LPAREN expr RPAREN { $$ = $2; }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(void) {
    printf("Simple C Parser - Enter statements (Ctrl+D to exit)\n");
    yyparse();
    return 0;
}
