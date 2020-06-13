#include "AST/assignment.hpp"

// TODO
AssignmentNode::AssignmentNode(const uint32_t line, const uint32_t col,
    AstNode* ref,
    AstNode* exp)
    : AstNode{ line, col }
    , reference(ref)
    , expression(exp)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void AssignmentNode::print() {}

void AssignmentNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void AssignmentNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    reference->accept(p_visitor);
    if (expression) {
        expression->accept(p_visitor);
    }
}
