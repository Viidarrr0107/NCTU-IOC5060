#ifndef __AST_VARIABLE_NODE_H
#define __AST_VARIABLE_NODE_H

#include "AST/ast.hpp"

class VariableNode : public AstNode {
public:
    VariableNode(const uint32_t line, const uint32_t col, char* v_name, char* type
        /* TODO: variable name, type, constant value */);

    VariableNode(const uint32_t line, const uint32_t col, char* v_name,
        char* type, AstNode* _consts);
    ~VariableNode() = default;

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

    const char* get_name() { return name.c_str(); }

    const char* get_type() { return type.c_str(); }

private:
    // TODO: variable name, type, constant value
    const std::string name;
    const std::string type;
    AstNode* consts;
};

#endif
