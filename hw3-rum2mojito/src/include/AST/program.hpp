#ifndef __AST_PROGRAM_NODE_H
#define __AST_PROGRAM_NODE_H

#include "AST/BinaryOperator.hpp"
#include "AST/CompoundStatement.hpp"
#include "AST/ConstantValue.hpp"
#include "AST/FunctionInvocation.hpp"
#include "AST/UnaryOperator.hpp"
#include "AST/VariableReference.hpp"
#include "AST/assignment.hpp"
#include "AST/ast.hpp"
#include "AST/decl.hpp"
#include "AST/expression.hpp"
#include "AST/for.hpp"
#include "AST/function.hpp"
#include "AST/if.hpp"
#include "AST/print.hpp"
#include "AST/read.hpp"
#include "AST/return.hpp"
#include "AST/variable.hpp"
#include "AST/while.hpp"

#include <vector>

class ProgramNode : public AstNode {
public:
    ProgramNode(const uint32_t line, const uint32_t col, const char* p_name,
        std::vector<AstNode*> _decl_list,
        std::vector<AstNode*> _function_list, AstNode* csn
        /* TODO: return type, declarations, functions,
                 *       compound statement */);
    ~ProgramNode() = default;

    // visitor pattern version: const char *getNameCString() const;
    const char* getNameCString() { return name.c_str(); }

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    const std::string name;

    // TODO: return type, declarations, functions, compound statement
    std::vector<AstNode*> decl_list;
    std::vector<AstNode*> function_list;
    const FunctionNode* function_node;
    AstNode* compound_statement_node;
};

#endif
