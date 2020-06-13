%{
#include "AST/ast.hpp"
#include "AST/program.hpp"
#include "AST/decl.hpp"
#include "AST/variable.hpp"
#include "AST/ConstantValue.hpp"
#include "AST/function.hpp"
#include "AST/CompoundStatement.hpp"
#include "AST/print.hpp"
#include "AST/expression.hpp"
#include "AST/BinaryOperator.hpp"
#include "AST/UnaryOperator.hpp"
#include "AST/FunctionInvocation.hpp"
#include "AST/VariableReference.hpp"
#include "AST/assignment.hpp"
#include "AST/read.hpp"
#include "AST/if.hpp"
#include "AST/while.hpp"
#include "AST/for.hpp"
#include "AST/return.hpp"
#include "AST/AstDumper.hpp"

#include <cassert>
#include <cstdlib>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <vector>
#include <stack>
#include <algorithm>

#define YYLTYPE yyltype

using namespace std;

typedef struct YYLTYPE {
    uint32_t first_line;
    uint32_t first_column;
    uint32_t last_line;
    uint32_t last_column;
} yyltype;

/* Declared by scanner.l */
extern uint32_t line_num;
extern char buffer[512];
extern FILE *yyin;
extern char *yytext;
/* End */

static AstNode *root;

extern "C" int yylex(void);
static void yyerror(const char *msg);
extern int yylex_destroy(void);

vector<AstNode*> decl_list_program;
vector<AstNode*> function_list_program;
vector<AstNode*> variable_list;
vector<AstNode*> decl_list_function;
vector<AstNode*> expression_list;
vector< vector<AstNode*> > decl_list_compound(10);
int compound_sp = 0;
vector<AstNode*> statement_list;
vector<AstNode*> arr_ref_list;
vector<char*> identifier_list;
vector<int> col;
AstNode *ast_node;
int col_local;
int is_program = 1;

int if_start_sp;
int if_end_sp;
int if_done = 0;
AstNode *tmp;
int i=0;

std::stack<AstNode*> statement_stack;
std::stack<int> statement_cnt_stack;

%}

%code requires {
    #include "AST/ast.hpp"
    #include "AST/program.hpp"
    #include "AST/decl.hpp"
    #include "AST/variable.hpp"
    #include "AST/ConstantValue.hpp"
    #include "AST/function.hpp"
    #include "AST/CompoundStatement.hpp"
    #include "AST/print.hpp"
    #include "AST/expression.hpp"
    #include "AST/BinaryOperator.hpp"
    #include "AST/UnaryOperator.hpp"
    #include "AST/FunctionInvocation.hpp"
    #include "AST/VariableReference.hpp"
    #include "AST/assignment.hpp"
    #include "AST/read.hpp"
    #include "AST/if.hpp"
    #include "AST/while.hpp"
    #include "AST/for.hpp"
    #include "AST/return.hpp"
    #include "AST/AstDumper.hpp"
}

    /* For yylval */
%union {
    /* basic semantic value */
    char *identifier;
    int int_literal;
    float float_val;
    
    AstNode *node;
    
    DeclNode *decl_node;
    VariableNode *variable_node;
    ConstantValueNode *constant_value_node;
    FunctionNode *function_node;
    CompoundStatementNode *compound_statement_node;
    PrintNode *print_node;
    ExpressionNode *expression_node;
    BinaryOperatorNode *binary_operator_node;
    UnaryOperatorNode *unary_operator_node;
    FunctionInvocationNode *function_invoction_node;
    VariableReferenceNode *variable_reference_node;
    AssignmentNode *assignment_node;
    ReadNode *read_node;
    IfNode *if_node;
    WhileNode *while_node;
    ForNode *for_node;
    ReturnNode *return_node;
};

%type <identifier> ProgramName ID VAR INTEGER REAL BOOLEAN STRING ScalarType Type LiteralConstant INT_LITERAL REAL_LITERAL StringAndBoolean ArrDecl ArrType STRING_LITERAL NegOrNot FunctionName ReturnType IdList
// %type <int_literal> INT REAL

%type <node> FunctionCall Return For Declaration Function FunctionDefinition FunctionDeclaration FormalArg CompoundStatement Simple Expression IntegerAndReal FunctionInvocation VariableReference ArrRefs Condition ElseOrNot ConditionStart While


    /* Delimiter */
%token COMMA SEMICOLON COLON
%token L_PARENTHESIS R_PARENTHESIS
%token L_BRACKET R_BRACKET

    /* Operator */
%token ASSIGN
%left OR
%left AND
%right NOT
%left LESS LESS_OR_EQUAL EQUAL GREATER GREATER_OR_EQUAL NOT_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%right UNARY_MINUS

    /* Keyword */
%token ARRAY BOOLEAN INTEGER REAL STRING
%token END BEGIN_ /* Use BEGIN_ since BEGIN is a keyword in lex */
%token DO ELSE FOR IF THEN WHILE
%token DEF OF TO RETURN VAR
%token FALSE TRUE
%token PRINT READ

    /* Identifier */
%token ID

    /* Literal */
%token INT_LITERAL
%token REAL_LITERAL
%token STRING_LITERAL

%%
    /*
       Program Units
                     */

Program:
    ProgramName SEMICOLON
    /* ProgramBody */
    DeclarationList FunctionList CompoundStatement
    /* End of ProgramBody */
    END {
        root = new ProgramNode(@1.first_line, @1.first_column,
                               $1, decl_list_program, function_list_program, $5);
        decl_list_program.clear();
        free($1);
    }
;

ProgramName:
    ID
;

DeclarationList:
    Epsilon {
        is_program = 0;
        compound_sp++;
    }
    |
    Declarations {
        is_program = 0;
        compound_sp++;
    }
;

Declarations:
    Declaration {
        if(is_program) {
            decl_list_program.push_back($1);
        } else {
            decl_list_compound[compound_sp].push_back($1);
        }
    }
    |
    Declarations Declaration {
        if(is_program) {
            decl_list_program.push_back($2);
        } else {
            decl_list_compound[compound_sp].push_back($2);
        }
    }
;

FunctionList:
    Epsilon
    |
    Functions
;

Functions:
    Function {
        function_list_program.push_back($1);
    }
    |
    Functions Function {
        function_list_program.push_back($2);
    }
;

Function:
    FunctionDeclaration {
        $$ = $1;
    }
    |
    FunctionDefinition {
        $$ = $1;
    }
;

FunctionDeclaration:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType SEMICOLON {
        $$ = new FunctionNode(@1.first_line, @1.first_column, $1, $5, decl_list_function);
        decl_list_function.clear();
    }
;

FunctionDefinition:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType
    CompoundStatement
    END {
        $$ = new FunctionNode(@1.first_line, @1.first_column, $1, $5, decl_list_function, $6);
        decl_list_function.clear();
    }
;

FunctionName:
    ID
;

FormalArgList:
    Epsilon
    |
    FormalArgs
;

FormalArgs:
    FormalArg {
        decl_list_function.push_back($1);
    }
    |
    FormalArgs SEMICOLON FormalArg {
        decl_list_function.push_back($3);
    }
;

FormalArg:
    IdList COLON Type {
        $$ = new DeclNode(@1.first_line, @1.first_column, identifier_list, col, $3);
        identifier_list.clear();
        col.clear();
    }
;

IdList:
    ID {
        identifier_list.push_back($1);
        col.push_back(@1.first_column);
        $$ = $1;
    }
    |
    IdList COMMA ID {
        identifier_list.push_back($3);
        col.push_back(@3.first_column);
    }
;

ReturnType:
    COLON ScalarType {
        $$ = $2;
    }
    |
    Epsilon {
        $$ = "void";
    }
;

    /*
       Data Types and Declarations
                                   */

Declaration:
    VAR IdList COLON Type SEMICOLON {
        $$ = new DeclNode(@1.first_line, @1.first_column, identifier_list, col, $4);
        identifier_list.clear();
        col.clear();
    }
    |
    VAR IdList COLON LiteralConstant SEMICOLON {
        $$ = new DeclNode(@1.first_line, @1.first_column, identifier_list, col, $4, ast_node);
        identifier_list.clear();
        col.clear();
    }
;

Type:
    ScalarType {
        $$ = $1;
    }
    |
    ArrType {
        $$ = $1;
    }
;

ScalarType:
    INTEGER {
        $$ = $1;
    }
    |
    REAL {
        $$ = $1;
    }
    |
    STRING {
        $$ = $1;
    }
    |
    BOOLEAN {
        $$ = $1;
    }
;

ArrType:
    ArrDecl ScalarType {
        char *tmp = (char*)malloc(sizeof(char) * 50);
        strcat(tmp, $2);
        strcat(tmp, " ");
        strcat(tmp, $1);
        $$ = tmp;
        // ast_node = new ConstantValueNode(@1.first_line, @1.first_column, $1);
    }
;

ArrDecl:
    ARRAY INT_LITERAL OF {
        char *tmp = (char*)malloc(sizeof(char) * 50);
        strcat(tmp, "[");
        strcat(tmp, $2);
        strcat(tmp, "]");
        $$ = tmp;
    }
    |
    ArrDecl ARRAY INT_LITERAL OF {
        char *tmp = (char*)malloc(sizeof(char) * 50);
        strcat(tmp, $1);
        strcat(tmp, "[");
        strcat(tmp, $3);
        strcat(tmp, "]");
        $$ = tmp;
    }
;

LiteralConstant:
    NegOrNot INT_LITERAL {
        $$ = "integer";
        char *tmp = (char*)malloc(sizeof(char) * 50);
        col_local = @2.first_column;
        if(strcmp($1, "-") == 0) {
            strcat(tmp, $1);
            col_local-=1;
        }
        strcat(tmp, $2);
        ast_node = new ConstantValueNode(@2.first_line, col_local, tmp);
    }
    |
    NegOrNot REAL_LITERAL{
        $$ = "real";
        char *tmp = (char*)malloc(sizeof(char) * 50);
        col_local = @2.first_column;
        if(strcmp($1, "-") == 0) {
            strcat(tmp, $1);
            col_local-=1;
        }
        strcat(tmp, $2);
        ast_node = new ConstantValueNode(@2.first_line, col_local, tmp);
    }
    |
    StringAndBoolean{
        $$ = $1;
        // ast_node = new ConstantValueNode(@1.first_line, @1.first_column, $1);
    }
;

NegOrNot:
    Epsilon {
        $$ = "";
    }
    |
    MINUS %prec UNARY_MINUS {
        $$ = "-";
    }
;

StringAndBoolean:
    STRING_LITERAL {
        $$ = "string";
        ast_node = new ConstantValueNode(@1.first_line, @1.first_column, $1);
    }
    |
    TRUE {
        $$ = "boolean";
        ast_node = new ConstantValueNode(@1.first_line, @1.first_column, "true");
    }
    |
    FALSE {
        $$ = "boolean";
        ast_node = new ConstantValueNode(@1.first_line, @1.first_column, "false");
    }
;

IntegerAndReal:
    INT_LITERAL {
        char *tmp = (char*)malloc(sizeof(char) * 50);
        col_local = @1.first_column;
        strcat(tmp, $1);
        $$ = new ConstantValueNode(@1.first_line, col_local, tmp);
    }
    |
    REAL_LITERAL {
        char *tmp = (char*)malloc(sizeof(char) * 50);
        col_local = @1.first_column;
        strcat(tmp, $1);
        $$ = new ConstantValueNode(@1.first_line, col_local, tmp);
    }
;

    /*
       Statements
                  */

Statement:
    CompoundStatement {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
        
        decl_list_compound[compound_sp].clear();
    }
    |
    Simple {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
    }
    |
    Condition {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
    }
    |
    While {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
    }
    |
    For {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
    }
    |
    Return {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
    }
    |
    FunctionCall {
        // statement_list.push_back($1);
        statement_cnt_stack.top()++;
        statement_stack.push($1);
    }
;

CompoundStatement:
    CompoundStatementStart
    StatementList
    END {
        // compound_sp++;
        compound_sp--;
        for(i=0; i<statement_cnt_stack.top(); i++) {
            statement_list.push_back(statement_stack.top());
            statement_stack.pop();
        }
        std::reverse(statement_list.begin(), statement_list.end());

        $$ = new CompoundStatementNode(@1.first_line, @1.first_column, decl_list_compound[compound_sp], statement_list);
        decl_list_compound[compound_sp].clear();
        statement_list.clear();
        
        statement_cnt_stack.pop();
    }
;

CompoundStatementStart:
    BEGIN_
    DeclarationList {
        statement_cnt_stack.push(0);
    }
;

Simple:
    VariableReference ASSIGN Expression SEMICOLON {
        $$ = new AssignmentNode(@2.first_line, @2.first_column, $1, $3);
    }
    |
    PRINT Expression SEMICOLON {
        $$ = new PrintNode(@1.first_line, @1.first_column, $2);
    }
    |
    READ VariableReference SEMICOLON {
        $$ = new ReadNode(@1.first_line, @1.first_column, $2);
    }
;

VariableReference:
    ID ArrRefList {
        $$ = new VariableReferenceNode(@1.first_line, @1.first_column, $1, arr_ref_list);
        arr_ref_list.clear();
    }
;

ArrRefList:
    Epsilon
    |
    ArrRefs
;

ArrRefs:
    L_BRACKET Expression R_BRACKET {
        arr_ref_list.push_back($2);
    }
    |
    ArrRefs L_BRACKET Expression R_BRACKET {
        arr_ref_list.push_back($3);
    }
;

Condition:
    ConditionStart
    CompoundStatement
    ElseOrNot
    ConditionEnd {
        $$ = new IfNode(@1.first_line, @1.first_column, $1, $2, $3);
    }
;

// int if_start_sp;
// int if_end_sp;
// int if_done = 0;

ConditionStart:
    IF Expression THEN {
        $$ = $2;
        if_start_sp = statement_list.size();
    }
;

ConditionEnd:
    END IF {
        if_end_sp = statement_list.size();
        for(i = 0; i<if_end_sp-if_start_sp; i++) {
            statement_list.pop_back();
        }
    }
;

ElseOrNot:
    ELSE
    CompoundStatement {
        $$ = $2;
    }
    |
    Epsilon {
        $$ = NULL;
    }
;

While:
    WHILE Expression DO
    CompoundStatement
    END DO {
        $$ = new WhileNode(@1.first_line, @1.first_column, $2, $4);
    }
;

For:
    FOR ID ASSIGN INT_LITERAL TO INT_LITERAL DO
    CompoundStatement
    END DO {
        //arr_ref_list.push_back((AstNode*)new ConstantValueNode(@6.first_line, @6.first_column, $4));
        $$ = new ForNode(@1.first_line, @1.first_column, 
                        (AstNode*)new DeclNode(@2.first_line, @2.first_column, $2, "integer"),
                        (AstNode*)new AssignmentNode(@3.first_line, @3.first_column, 
                            (AstNode*)new VariableReferenceNode(@2.first_line, @2.first_column, $2, arr_ref_list), 
                            (AstNode*)new ConstantValueNode(@4.first_line, @4.first_column, $4)),
                        (AstNode*)new ConstantValueNode(@6.first_line, @6.first_column, $6),
                        (AstNode*)$8);
    }
;

Return:
    RETURN Expression SEMICOLON {
        $$ = new ReturnNode(@1.first_line, @1.first_column, $2);
    }
;

FunctionCall:
    FunctionInvocation SEMICOLON {
        $$ = $1;
    }
;

FunctionInvocation:
    ID L_PARENTHESIS ExpressionList R_PARENTHESIS {
        $$ = new FunctionInvocationNode(@1.first_line, @1.first_column, $1, expression_list);
        expression_list.clear();
    }
;

ExpressionList:
    Epsilon
    |
    Expressions
;

Expressions:
    Expression {
        expression_list.push_back($1);
    }
    |
    Expressions COMMA Expression {
        expression_list.push_back($3);
    }
;

StatementList:
    Epsilon
    |
    Statements
;

Statements:
    Statement
    |
    Statements Statement
;

Expression:
    L_PARENTHESIS Expression R_PARENTHESIS {
        $$ = $2;
    }
    |
    MINUS Expression %prec UNARY_MINUS {
        $$ = new UnaryOperatorNode(@1.first_line, @1.first_column, "neg", $2);
    }
    |
    Expression MULTIPLY Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "*", $1, $3);
    }
    |
    Expression DIVIDE Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "/", $1, $3);
    }
    |
    Expression MOD Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "mod", $1, $3);
    }
    |
    Expression PLUS Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "+", $1, $3);
    }
    |
    Expression MINUS Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "-", $1, $3);
    }
    |
    Expression LESS Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "<", $1, $3);
    }
    |
    Expression LESS_OR_EQUAL Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "<=", $1, $3);
    }
    |
    Expression GREATER Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, ">", $1, $3);
    }
    |
    Expression GREATER_OR_EQUAL Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, ">=", $1, $3);
    }
    |
    Expression EQUAL Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "=", $1, $3);
    }
    |
    Expression NOT_EQUAL Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "<>", $1, $3);
    }
    |
    NOT Expression {
        $$ = new UnaryOperatorNode(@1.first_line, @1.first_column, "not", $2);
    }
    |
    Expression AND Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "and", $1, $3);
    }
    |
    Expression OR Expression {
        $$ = new BinaryOperatorNode(@2.first_line, @2.first_column, "or", $1, $3);
    }
    |
    IntegerAndReal {
        $$ = $1;
    }
    |
    StringAndBoolean {
        $$ = ast_node;
    }
    |
    VariableReference {
        $$ = $1;
    }
    |
    FunctionInvocation {
        $$ = $1;
    }
;

    /*
       misc
            */
Epsilon:
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
            line_num, buffer, yytext);
    exit(-1);
}

int main(int argc, const char *argv[]) {
    assert(argc >= 2 && "Usage: ./parser <filename> [--dump-ast]\n");

    yyin = fopen(argv[1], "r");
    assert(yyin != NULL && "fopen() fails.\n");
    statement_cnt_stack.push(0);

    yyparse();

    if (argc > 2 && strcmp(argv[2], "--dump-ast") == 0) {
        AstDumper ast_d;
        // root->print();
        root->accept(ast_d);
    }

    printf("\n"
           "|--------------------------------|\n"
           "|  There is no syntactic error!  |\n"
           "|--------------------------------|\n");

    delete root;
    fclose(yyin);
    yylex_destroy();
    return 0;

    // FOR IdList ASSIGN LiteralConstant TO INT_LITERAL DO
}
