#include "AST/CompoundStatement.hpp"

// TODO
CompoundStatementNode::CompoundStatementNode(const uint32_t line,
    const uint32_t col,
    std::vector<AstNode*> _declarations,
    std::vector<AstNode*> _statements)
    : AstNode{ line, col }
    , declarations(_declarations)
    , statements(_statements)
{
}

// TODO: You may use code snippets in AstDumper.cpp
// compound statement <line: {line_number}, col: {col_number}>
void CompoundStatementNode::print()
{
    outputIndentationSpace();

    std::printf("compound statement <line: %u, col: %u>\n",
        location.line, location.col);

    // TODO
    incrementIndentation();
    // visitChildNodes();
    decrementIndentation();
}

void CompoundStatementNode::accept(AstDumper& p_visitor)
{
    p_visitor.visit(*this);
}

void CompoundStatementNode::visitChildNodes(AstDumper& p_visitor)
{
    for (auto& decl : declarations) {
        decl->accept(p_visitor);
    }

    for (auto& decl : statements) {
        decl->accept(p_visitor);
    }
}

// void ProgramNode::visitChildNodes(AstNode &adt_node) {
//     return;
// }
