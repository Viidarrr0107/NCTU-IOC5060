#include "AST/program.hpp"

// TODO
ProgramNode::ProgramNode(const uint32_t line, const uint32_t col,
    const char* p_name,
    std::vector<AstNode*> _decl_list,
    std::vector<AstNode*> _function_list,
    AstNode* csn)
    : AstNode{ line, col }
    , name(p_name)
    , decl_list(_decl_list)
    , function_list(_function_list)
    , compound_statement_node(csn)
{
}

// visitor pattern version: const char *ProgramNode::getNameCString() const { return name.c_str(); }

void ProgramNode::print()
{
    // TODO
    outputIndentationSpace();

    std::printf("program <line: %u, col: %u> %s %s\n",
        location.line, location.col,
        name.c_str(), "void");

    // TODO
    incrementIndentation();
    // AstNode **adt_node = &compound_statement_node;
    // visitChildNodes(compound_statement_node);
    decrementIndentation();
}

// void ProgramNode::visitChildNodes(AstNode *adt_node) {
//     adt_node->print();
// }

void ProgramNode::accept(AstDumper& p_visitor)
{ // visitor pattern version
    p_visitor.visit(*this);
}

void ProgramNode::visitChildNodes(AstDumper& p_visitor)
{ // visitor pattern version
    for (auto& decl : decl_list) {
        decl->accept(p_visitor);
    }

    for (auto& func : function_list) {
        func->accept(p_visitor);
    }

    compound_statement_node->accept(p_visitor);
}
