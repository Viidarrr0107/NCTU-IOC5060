#ifndef __AST_FUNCTION_NODE_H
#define __AST_FUNCTION_NODE_H

#include "AST/ast.hpp"
#include "AST/decl.hpp"
#include <vector>

class FunctionNode : public AstNode {
public:
    FunctionNode(const uint32_t line, const uint32_t col, char* f_name,
        char* f_return, std::vector<AstNode*> _decl_list
        /* TODO: name, declarations, return type,
                  *       compound statement (optional) */);

    FunctionNode(const uint32_t line, const uint32_t col, char* f_name,
        char* f_return, std::vector<AstNode*> _decl_list,
        AstNode* _compound);
    ~FunctionNode() = default;

    const char* get_name() { return name.c_str(); }

    const char* msg()
    {
        char* tmp = (char*)malloc(sizeof(char) * 500);
        strcat(tmp, return_type.c_str());
        strcat(tmp, " (");
        if (declarations.size() > 0) {
            strcat(tmp, ((DeclNode*)declarations[0])->get_var_type());
        }
        for (int i = 1; i < declarations.size(); i++) {
            strcat(tmp, ", ");
            strcat(tmp, ((DeclNode*)declarations[i])->get_var_type());
        }
        strcat(tmp, ")");

        return tmp;
    }

    void print() override;
    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: name, declarations, return type, compound statement
    const std::string name;
    const std::string return_type;
    std::vector<AstNode*> declarations;
    AstNode* compound;
};

#endif
