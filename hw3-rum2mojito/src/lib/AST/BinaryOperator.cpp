#include "AST/BinaryOperator.hpp"

// TODO
BinaryOperatorNode::BinaryOperatorNode(const uint32_t line, const uint32_t col,
    char* operator_name,
    AstNode* left_e,
    AstNode* right_e)
    : ExpressionNode{ line, col }
    , name(operator_name)
    , left(left_e)
    , right(right_e)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void BinaryOperatorNode::print() {}

// void BinaryOperatorNode::visitChildNodes(AstNodeVisitor &p_visitor) {
//     // TODO
// }

void BinaryOperatorNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void BinaryOperatorNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    left->accept(p_visitor);
    right->accept(p_visitor);
}
