#ifndef __AST_READ_NODE_H
#define __AST_READ_NODE_H

#include "AST/ast.hpp"

class ReadNode : public AstNode {
public:
    ReadNode(const uint32_t line, const uint32_t col, AstNode* ref
        /* TODO: variable reference */);
    ~ReadNode() = default;

    void print() override;

    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: variable reference
    AstNode* reference;
};

#endif
