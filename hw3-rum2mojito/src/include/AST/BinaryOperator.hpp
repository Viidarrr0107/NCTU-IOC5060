#ifndef __AST_BINARY_OPERATOR_NODE_H
#define __AST_BINARY_OPERATOR_NODE_H

#include "AST/expression.hpp"

#include <memory>
#include <string>

class BinaryOperatorNode : public ExpressionNode {
public:
    BinaryOperatorNode(const uint32_t line, const uint32_t col,
        char* operator_name, AstNode* left_e, AstNode* right_e
        /* TODO: operator, expressions */);
    ~BinaryOperatorNode() = default;

    const char* get_name() { return name.c_str(); }

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: operator, expressions
    const std::string name;
    AstNode* left;
    AstNode* right;
};

#endif
