#include "AST/while.hpp"

// TODO
WhileNode::WhileNode(const uint32_t line, const uint32_t col,
    AstNode* _expression,
    AstNode* _compound_statement)
    : AstNode{ line, col }
    , expression(_expression)
    , compound_statement(_compound_statement)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void WhileNode::print() {}

void WhileNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void WhileNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    expression->accept(p_visitor);
    compound_statement->accept(p_visitor);
}
