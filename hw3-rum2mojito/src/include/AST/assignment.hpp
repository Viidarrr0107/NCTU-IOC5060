#ifndef __AST_ASSIGNMENT_NODE_H
#define __AST_ASSIGNMENT_NODE_H

#include "AST/ast.hpp"

class AssignmentNode : public AstNode {
public:
    AssignmentNode(const uint32_t line, const uint32_t col, AstNode* ref,
        AstNode* exp
        /* TODO: variable reference, expression */);
    ~AssignmentNode() = default;

    void print() override;

    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: variable reference, expression
    AstNode* reference;
    AstNode* expression;
};

#endif
