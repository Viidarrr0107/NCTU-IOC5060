#include "AST/UnaryOperator.hpp"

// TODO
UnaryOperatorNode::UnaryOperatorNode(const uint32_t line, const uint32_t col,
    char* operator_name,
    AstNode* right_e)
    : ExpressionNode{ line, col }
    , right(right_e)
    , name(operator_name)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void UnaryOperatorNode::print() {}

// void UnaryOperatorNode::visitChildNodes(AstNodeVisitor &p_visitor) {
//     // TODO
// }

void UnaryOperatorNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void UnaryOperatorNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    right->accept(p_visitor);
}
