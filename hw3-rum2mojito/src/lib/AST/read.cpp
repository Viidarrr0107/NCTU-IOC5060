#include "AST/read.hpp"

// TODO
ReadNode::ReadNode(const uint32_t line, const uint32_t col, AstNode* ref)
    : AstNode{ line, col }
    , reference(ref)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void ReadNode::print() {}

void ReadNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void ReadNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    reference->accept(p_visitor);
}
