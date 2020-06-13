#ifndef __AST_UNARY_OPERATOR_NODE_H
#define __AST_UNARY_OPERATOR_NODE_H

#include "AST/expression.hpp"

#include <string>

class UnaryOperatorNode : public ExpressionNode {
public:
    UnaryOperatorNode(const uint32_t line, const uint32_t col,
        char* operator_name, AstNode* right_e
        /* TODO: operator, expression */);
    ~UnaryOperatorNode() = default;

    const char* get_name() { return name.c_str(); }

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: operator, expression
    const std::string name;
    AstNode* right;
};

#endif
