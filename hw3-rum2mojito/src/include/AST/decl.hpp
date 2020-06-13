#ifndef __AST_DECL_NODE_H
#define __AST_DECL_NODE_H

#include "AST/ast.hpp"
#include "AST/variable.hpp"

#include <cstring>
#include <string>
#include <vector>

class DeclNode : public AstNode {
public:
    // variable declaration
    DeclNode(const uint32_t line, const uint32_t col,
        std::vector<char*> identifiers, std::vector<int> cols, char* type
        /* TODO: identifiers, type */);

    DeclNode(const uint32_t line, const uint32_t col,
        std::vector<char*> identifiers, std::vector<int> cols, char* type,
        AstNode* consts);

    DeclNode(const uint32_t line, const uint32_t col, char* identifiers,
        char* type);

    // constant variable declaration
    // DeclNode(const uint32_t, const uint32_t col
    //         /* TODO: identifiers, constant */);

    ~DeclNode() = default;

    const char* get_var_type()
    {
        char* tmp = (char*)malloc(sizeof(char) * 500);
        if (variables.size() > 0) {
            strcat(tmp, ((VariableNode*)variables[0])->get_type());
        }
        for (int i = 1; i < variables.size(); i++) {
            strcat(tmp, ", ");
            strcat(tmp, ((VariableNode*)variables[i])->get_type());
        }

        return tmp;
    }

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: variables
    std::vector<AstNode*> variables;
};

#endif
