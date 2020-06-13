#include "AST/print.hpp"

// TODO
PrintNode::PrintNode(const uint32_t line, const uint32_t col, AstNode* e)
    : AstNode{ line, col }
    , expression(e)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void PrintNode::print() {}

// void PrintNode::visitChildNodes(AstNodeVisitor &p_visitor) {
//     // TODO
// }

void PrintNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void PrintNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    expression->accept(p_visitor);
}
