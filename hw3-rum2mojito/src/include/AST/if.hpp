#ifndef __AST_IF_NODE_H
#define __AST_IF_NODE_H

#include "AST/ast.hpp"

class IfNode : public AstNode {
public:
    IfNode(const uint32_t line, const uint32_t col, AstNode* _expression,
        AstNode* _compoumd_statement1, AstNode* _compound_statement2
        /* TODO: expression, compound statement, compound statement */);
    ~IfNode() = default;

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: expression, compound statement, compound statement
    AstNode *expression, *compound_statement1, *compound_statement2;
};

#endif
