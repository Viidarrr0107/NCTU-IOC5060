%{
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "error.h"

extern int32_t LineNum;   /* declared in scanner.l */
extern char Buffer[512];  /* declared in scanner.l */
extern FILE *yyin;        /* declared by lex */
extern char *yytext;      /* declared by lex */

extern int yylex(void); 
static void yyerror(const char *msg);
%}

// identifier
%token ID
%token VAR

// delimiter
%token SEMICOLON // ;
%token COLON // :
%token COMMA // ,
%token ROUND_BRACKET_L  ROUND_BRACKET_R // ()
%token SQUARE_BRACKET_L SQUARE_BRACKET_R // []
%token CURLY_BRACKET_L  CURLY_BRACKET_R // {}

// operator
%token ADD SUB MULTIPLY DIVIDE MOD 
%token ASSIGN GT GE LT LE EQ NE
%token AND NOT OR

// keyword
%token ARRAY BEGIN_SIGN BOOLEAN DEF DO ELSE END FALSE FOR
%token INTEGER IF OF PRINT READ REAL STRING THEN TO TRUE
%token RETURN WHILE

// integer decimal/octal
%token INT_VAL INT_OCT_VAL

// float
%token FLOAT_VAL

// scientific
%token SCIENTIFIC_VAL

// string
%token STRING_VAL

%start program_name

%left SUB

%%

program_name: ID SEMICOLON program_start END
            ;

program_start: declaration_list program_function BEGIN_SIGN declaration_list statements END
             ;
program_function: function_declaration program_function
                | function_definition program_function
                | /*epsilon*/
                ;
compound_statement: BEGIN_SIGN declaration_list statements END
                  ;
statements: PRINT expression SEMICOLON statements
          | PRINT variable_reference SEMICOLON statements
          | READ variable_reference SEMICOLON statements
          | ID ROUND_BRACKET_L procedure_call ROUND_BRACKET_R SEMICOLON statements
          | variable_reference ASSIGN expression SEMICOLON statements
          | condition_statements statements
          | compound_statement statements
          | RETURN expression SEMICOLON
          | /*epsilon*/
          ;
condition_statements: if_statement
                    | while_statement
                    | for_statement
                    ;
if_statement: IF expression THEN compound_statement ELSE compound_statement END IF
            | IF expression THEN compound_statement END IF
            ;
while_statement: WHILE expression DO compound_statement END DO
               ;
for_statement: FOR ID ASSIGN INT_VAL TO INT_VAL DO compound_statement END DO
             ;
variable_reference: ID
                  | ID SQUARE_BRACKET_L expression SQUARE_BRACKET_R
                  ;
expression: expression ADD expression
          | expression SUB expression
          | expression MULTIPLY expression
          | expression DIVIDE expression
          | expression MOD expression
          | expression EQ expression
          | expression GT expression
          | expression GE expression
          | expression LT expression
          | expression LE expression
          | expression NE expression
          | expression AND expression
          | expression OR expression
          | NOT sub_expression
          | SUB sub_expression
          | data_val
          | type
          | variable_reference
          | ROUND_BRACKET_L expression ROUND_BRACKET_R
          | CURLY_BRACKET_L expression CURLY_BRACKET_R
          | ID ROUND_BRACKET_L procedure_call ROUND_BRACKET_R
          ;
sub_expression: sub_expression ADD expression
          | sub_expression SUB expression
          | sub_expression MULTIPLY expression
          | sub_expression DIVIDE expression
          | sub_expression MOD expression
          | sub_expression EQ expression
          | sub_expression GT expression
          | sub_expression GE expression
          | sub_expression LT expression
          | sub_expression LE expression
          | sub_expression NE expression
          | sub_expression AND expression
          | sub_expression OR expression
          | data_val
          | type
          | variable_reference
          | ROUND_BRACKET_L expression ROUND_BRACKET_R
          | CURLY_BRACKET_L expression CURLY_BRACKET_R
          | ID ROUND_BRACKET_L procedure_call ROUND_BRACKET_R
          ;
procedure_call: _function_invocation
              | /*epsilon*/
              ;
_function_invocation: expression
                    | expression COMMA _function_invocation
                    ;
function_declaration: ID ROUND_BRACKET_L args_list ROUND_BRACKET_R COLON scalar_type SEMICOLON
                    ;
function_definition: ID ROUND_BRACKET_L args_list ROUND_BRACKET_R COLON scalar_type function_body END
                   | ID ROUND_BRACKET_L args_list ROUND_BRACKET_R function_body END
                   ;
function_body: compound_statement
             ;
args_list: args COLON scalar_type
         | /*epsilon*/
         ;
args: ID COMMA args 
    | ID
    ;
declaration_list: declaration declaration_list 
                | /*epsilon*/
                ;
type: data 
    | ARRAY INT_VAL OF type
    ;
data: scalar_type 
    | data_val
    ;
scalar_type: INTEGER 
           | STRING 
           | BOOLEAN 
           | REAL
           ;
data_val: INT_VAL 
        | SCIENTIFIC_VAL 
        | FLOAT_VAL 
        | STRING_VAL 
        | INT_OCT_VAL
        | TRUE 
        | FALSE
        ;
identifier_list: identifier COMMA identifier_list 
               | identifier
               ;
declaration: VAR identifier_list COLON type SEMICOLON
           ;
identifier: ID
          ;

%%

void yyerror(const char *msg) {
    fprintf(stderr,
            "\n"
            "|-----------------------------------------------------------------"
            "---------\n"
            "| Error found in Line #%d: %s\n"
            "|\n"
            "| Unmatched token: %s\n"
            "|-----------------------------------------------------------------"
            "---------\n",
            LineNum, Buffer, yytext);
    exit(-1);
}

int main(int argc, const char *argv[]) {
    CHECK(argc == 2, "Usage: ./parser <filename>\n");

    FILE *fp = fopen(argv[1], "r");

    CHECK(fp != NULL, "fopen() fails.\n");
    yyin = fp;
    yyparse();

    printf("\n"
           "|--------------------------------|\n"
           "|  There is no syntactic error!  |\n"
           "|--------------------------------|\n");
    return 0;
}
