#include "AST/if.hpp"

// TODO
IfNode::IfNode(const uint32_t line, const uint32_t col,
    AstNode* _expression,
    AstNode* _compoumd_statement1,
    AstNode* _compound_statement2)
    : AstNode{ line, col }
    , expression(_expression)
    , compound_statement1(_compoumd_statement1)
    , compound_statement2(_compound_statement2)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void IfNode::print() {}

void IfNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void IfNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    expression->accept(p_visitor);
    compound_statement1->accept(p_visitor);
    if (compound_statement2) {
        compound_statement2->accept(p_visitor);
    }
}