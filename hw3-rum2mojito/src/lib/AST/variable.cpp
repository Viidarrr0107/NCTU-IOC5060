#include "AST/variable.hpp"

// TODO
VariableNode::VariableNode(const uint32_t line, const uint32_t col,
    char* v_name,
    char* v_type)
    : AstNode{ line, col }
    , name(v_name)
    , type(v_type)
{
}

VariableNode::VariableNode(const uint32_t line, const uint32_t col,
    char* v_name,
    char* v_type,
    AstNode* _consts)
    : AstNode{ line, col }
    , name(v_name)
    , type(v_type)
    , consts(_consts)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void VariableNode::print() {}

// void VariableNode::visitChildNodes(AstNodeVisitor &p_visitor) {
//     // TODO
// }

void VariableNode::accept(AstDumper& p_visitor)
{
    p_visitor.visit(*this);
}

void VariableNode::visitChildNodes(AstDumper& p_visitor)
{
    if (consts) {
        consts->accept(p_visitor);
    }
}
