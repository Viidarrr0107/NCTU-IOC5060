#ifndef __AST_PRINT_NODE_H
#define __AST_PRINT_NODE_H

#include "AST/ast.hpp"

class PrintNode : public AstNode {
public:
    PrintNode(const uint32_t line, const uint32_t col, AstNode* e
        /* TODO: expression */);
    ~PrintNode() = default;

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: expression
    AstNode* expression;
};

#endif
