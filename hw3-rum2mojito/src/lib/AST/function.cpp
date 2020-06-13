#include "AST/function.hpp"

// TODO
FunctionNode::FunctionNode(const uint32_t line, const uint32_t col,
    char* f_name, char* f_return,
    std::vector<AstNode*> _decl_list)
    : AstNode{ line, col }
    , name(f_name)
    , return_type(f_return)
    , declarations(_decl_list)
{
}

FunctionNode::FunctionNode(const uint32_t line, const uint32_t col,
    char* f_name, char* f_return,
    std::vector<AstNode*> _decl_list,
    AstNode* _compound)
    : AstNode{ line, col }
    , name(f_name)
    , return_type(f_return)
    , declarations(_decl_list)
    , compound(_compound)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void FunctionNode::print() {}

void FunctionNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void FunctionNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    for (auto& decl : declarations) {
        decl->accept(p_visitor);
    }

    if (compound) {
        compound->accept(p_visitor);
    }
}
