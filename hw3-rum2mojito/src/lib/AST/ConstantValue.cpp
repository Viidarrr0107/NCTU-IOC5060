#include "AST/ConstantValue.hpp"

// TODO
ConstantValueNode::ConstantValueNode(const uint32_t line, const uint32_t col,
    char* c_name)
    : ExpressionNode{ line, col }
    , value(c_name)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void ConstantValueNode::print() {}

void ConstantValueNode::accept(AstDumper& p_visitor)
{
    p_visitor.visit(*this);
}

void ConstantValueNode::visitChildNodes(AstDumper& p_visitor)
{
}
