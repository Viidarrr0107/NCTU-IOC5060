#include "AST/for.hpp"

// TODO
ForNode::ForNode(const uint32_t line, const uint32_t col,
    AstNode* _declaration,
    AstNode* _assignment,
    AstNode* _expression,
    AstNode* _compound_statement)
    : AstNode{ line, col }
    , declaration(_declaration)
    , assignment(_assignment)
    , expression(_expression)
    , compound_statement(_compound_statement)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void ForNode::print() {}

void ForNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void ForNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    declaration->accept(p_visitor);
    assignment->accept(p_visitor);
    expression->accept(p_visitor);
    compound_statement->accept(p_visitor);
}
