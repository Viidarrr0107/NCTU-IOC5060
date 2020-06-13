#ifndef __AST_VARIABLE_REFERENCE_NODE_H
#define __AST_VARIABLE_REFERENCE_NODE_H

#include "AST/expression.hpp"
#include <vector>

class VariableReferenceNode : public ExpressionNode {
public:
    // normal reference
    VariableReferenceNode(const uint32_t line, const uint32_t col,
        const char* v_name, std::vector<AstNode*> arr_ref_list
        /* TODO: name */);
    // array reference
    // VariableReferenceNode(const uint32_t line, const uint32_t col
    //                       /* TODO: name, expressions */);
    ~VariableReferenceNode() = default;

    const char* get_name() { return name.c_str(); }

    void print() override;

    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: variable name, expressions
    std::vector<AstNode*> expressions;
    const std::string name;
};

#endif
