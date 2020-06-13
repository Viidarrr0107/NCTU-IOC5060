#ifndef __AST_CONSTANT_VALUE_NODE_H
#define __AST_CONSTANT_VALUE_NODE_H

#include "AST/expression.hpp"

class ConstantValueNode : public ExpressionNode {
public:
    ConstantValueNode(const uint32_t line, const uint32_t col, char* c_name
        /* TODO: constant value */);
    ~ConstantValueNode() = default;

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

    const char* get_value() { return value.c_str(); }

private:
    // TODO: constant value
    const std::string value;
};

#endif
