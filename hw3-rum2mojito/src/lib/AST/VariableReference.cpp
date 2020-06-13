#include "AST/VariableReference.hpp"

// TODO
VariableReferenceNode::VariableReferenceNode(const uint32_t line,
    const uint32_t col,
    const char* v_name,
    std::vector<AstNode*> arr_ref_list)
    : ExpressionNode{ line, col }
    , name(v_name)
    , expressions(arr_ref_list)
{
}

// TODO
// VariableReferenceNode::VariableReferenceNode(const uint32_t line,
//                                              const uint32_t col)
//     : ExpressionNode{line, col} {}

// TODO: You may use code snippets in AstDumper.cpp
void VariableReferenceNode::print() {}

// void VariableReferenceNode::visitChildNodes(AstNodeVisitor &p_visitor) {
//     // TODO
// }

void VariableReferenceNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void VariableReferenceNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    for (auto& decl : expressions) {
        decl->accept(p_visitor);
    }
}
