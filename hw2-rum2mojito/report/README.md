# hw2 report


|Field|Value|
|-:|:-|
|Name|石育瑋|
|ID|A073708|

## How much time did you spend on this project

4.5 hours.

## Project overview

#### Token
> 一開始要先宣告tokens，產出`parser.h`讓yacc與lex之間能夠串起來
- parser.y
```yacc
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
```

- scanner.l
> 在原本rule裡加上`return TOKEN`；以`,`為例，需要加上`return COMMA`給yacc，告知yacc token的類型
```lex
"," { TOKEN_CHAR(','); return COMMA; }
```
#### Grammar rule (Top-down)

- Program

```yacc
program_name: ID SEMICOLON program_start END
            ;

program_start: declaration_list program_function BEGIN_SIGN declaration_list statements END
             ;
```
> 依照spec給的框架，寫出整個program的規則，一開始會先輸入program name由一個1 identifier and 1 semicolon組成，接著會有variable declaration  and function declaration/definition sections，遇到一個begin sign後進入program body最後由end sign結束．

- Function

```yacc
function_declaration: ID ROUND_BRACKET_L args_list ROUND_BRACKET_R COLON scalar_type SEMICOLON
                    ;
function_definition: ID ROUND_BRACKET_L args_list ROUND_BRACKET_R COLON scalar_type function_body END
                   | ID ROUND_BRACKET_L args_list ROUND_BRACKET_R function_body END
                   ;
function_body: compound_statement
             ;
```

> function declaration 由 `identifier`, `(`, `arguments`, `)`, `:`, `return data type`, `;` 組成
> function definition 由 `identifier`, `(`, `arguments`, `)`, (`:` `retrun data type`| `epsilon`), `function body`, `END` 兩種不同的rule組成

- Data type & Declarations

```yacc
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
```
> data type主要由scalar跟const兩種，grammar組成比較簡單

- Statement

```yacc
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
compound_statement: BEGIN_SIGN declaration_list statements END
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
```

> statements 有7種
> 1. compound statement: 由`variables declaration` 與 `statements`組成
> 2. simple statement: 由`read`, `print` 組成
> 3. cinditional statement: 由`if`組成
> 4. while loop statement: 由keyword `while`組成
> 5. for loop statement: 由keyword `for`組成
> 6. retrun statement: 由`retrun`, `epression`組成
> 7. procedure call: function call

- Expressions

```yacc
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
          | NOT expression
          | SUB expression
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
```

> expression由基本的關係、運算子等等組成，再由spec敘述寫出grammar

## What is the hardest you think in this project

> 萬事起頭難，我覺得一開始會毫無頭緒，不知道要return token與不知道如何寫grammar，所以在這開頭就花了大量時間，等進入狀況後，就能很快寫出來~

## Feedback to T.A.s

> 我覺得測資可以從最點單的program structure開始，一步步引導，不然一開始就decalaration感覺沒辦法很快適應進入狀況\~這是我的一點點小意見\~
