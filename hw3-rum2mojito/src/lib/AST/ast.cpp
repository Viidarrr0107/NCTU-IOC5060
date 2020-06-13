#include <AST/ast.hpp>

int indentation = 0;

AstNode::AstNode(const uint32_t line, const uint32_t col)
    : location(line, col)
{
}

// prevent the linker from complaining
AstNode::~AstNode() {}

const Location& AstNode::getLocation() const { return location; }

const void AstNode::outputIndentationSpace()
{
    for (int i = 0; i < indentation; i++) {
        std::printf("  ");
    }
}

const void AstNode::incrementIndentation()
{
    indentation++;
}

const void AstNode::decrementIndentation()
{
    indentation--;
}

// const void visitChildNodes(AstNode *root) {
//     root->print();
// }
