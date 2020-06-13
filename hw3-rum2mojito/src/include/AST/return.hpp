#ifndef __AST_RETURN_NODE_H
#define __AST_RETURN_NODE_H

#include "AST/ast.hpp"

class ReturnNode : public AstNode {
public:
    ReturnNode(const uint32_t line, const uint32_t col, AstNode* _expression
        /* TODO: expression */);
    ~ReturnNode() = default;

    void print() override;

    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: expression
    AstNode* expression;
};

#endif
