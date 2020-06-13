#ifndef __AST_FUNCTION_INVOCATION_NODE_H
#define __AST_FUNCTION_INVOCATION_NODE_H

#include "AST/expression.hpp"
#include <vector>

class FunctionInvocationNode : public ExpressionNode {
public:
    FunctionInvocationNode(const uint32_t line, const uint32_t col,
        const char* f_name,
        std::vector<AstNode*> _expression_list
        /* TODO: function name, expressions */);
    ~FunctionInvocationNode() = default;

    const char* get_name() { return name.c_str(); };

    void print() override;

    void accept(AstDumper& adt_node) override;
    void visitChildNodes(AstDumper& adt_node) override;

private:
    // TODO: function name, expressions
    const std::string name;
    std::vector<AstNode*> expression_list;
};

#endif
