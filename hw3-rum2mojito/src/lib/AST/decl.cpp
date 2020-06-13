#include "AST/decl.hpp"

// TODO
DeclNode::DeclNode(const uint32_t line, const uint32_t col,
    std::vector<char*> identifiers,
    std::vector<int> cols,
    char* type)
    : AstNode{ line, col }
{
    for (int i = 0; i < identifiers.size(); i++) {
        variables.push_back(new VariableNode(line, cols[i], identifiers[i], type));
    }
}

DeclNode::DeclNode(const uint32_t line, const uint32_t col,
    std::vector<char*> identifiers,
    std::vector<int> cols,
    char* type,
    AstNode* consts)
    : AstNode{ line, col }
{
    for (int i = 0; i < identifiers.size(); i++) {
        variables.push_back(new VariableNode(line, cols[i], identifiers[i], type, consts));
    }
}

DeclNode::DeclNode(const uint32_t line, const uint32_t col,
    char* identifiers,
    char* type)
    : AstNode{ line, col }
{
    for (int i = 0; i < 1; i++) {
        variables.push_back(new VariableNode(line, col, identifiers, type, NULL));
    }
}

// TODO
//DeclNode::DeclNode(const uint32_t line, const uint32_t col)
//    : AstNode{line, col} {}

// TODO: You may use code snippets in AstDumper.cpp
void DeclNode::print() {}

void DeclNode::accept(AstDumper& p_visitor)
{
    p_visitor.visit(*this);
}

void DeclNode::visitChildNodes(AstDumper& p_visitor)
{
    // TODO
    for (auto& var : variables) {
        var->accept(p_visitor);
    }
}
