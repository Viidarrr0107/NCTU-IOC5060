#include "AST/FunctionInvocation.hpp"

// TODO
FunctionInvocationNode::FunctionInvocationNode(const uint32_t line,
    const uint32_t col,
    const char* f_name,
    std::vector<AstNode*> _expression_list)
    : ExpressionNode{ line, col }
    , name(f_name)
    , expression_list(_expression_list)
{
}

// TODO: You may use code snippets in AstDumper.cpp
void FunctionInvocationNode::print() {}

// void FunctionInvocationNode::visitChildNodes(AstNodeVisitor &p_visitor) {
//     // TODO
// }

void FunctionInvocationNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void FunctionInvocationNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    for (auto& var : expression_list) {
        var->accept(p_visitor);
    }
}
