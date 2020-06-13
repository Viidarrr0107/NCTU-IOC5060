#ifndef __AST_COMPOUND_STATEMENT_NODE_H
#define __AST_COMPOUND_STATEMENT_NODE_H

#include "AST/ast.hpp"

#include <vector>

class CompoundStatementNode : public AstNode {
public:
    CompoundStatementNode(const uint32_t line, const uint32_t col,
        std::vector<AstNode*> _declarations,
        std::vector<AstNode*> _statements
        /* TODO: declarations, statements */);
    ~CompoundStatementNode() = default;

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& p_visitor) override;

private:
    // TODO: declarations, statements
    std::vector<AstNode *> declarations, statements;
};

#endif
