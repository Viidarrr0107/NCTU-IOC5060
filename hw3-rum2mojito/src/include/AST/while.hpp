#ifndef __AST_WHILE_NODE_H
#define __AST_WHILE_NODE_H

#include "AST/ast.hpp"

class WhileNode : public AstNode {
public:
    WhileNode(const uint32_t line, const uint32_t col, AstNode* _expression,
        AstNode* _compound_statement
        /* TODO: expression, compound statement */);
    ~WhileNode() = default;

    void print() override;

    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: expression, compound statement
    AstNode* expression;
    AstNode* compound_statement;
};

#endif
