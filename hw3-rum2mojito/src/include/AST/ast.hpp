#ifndef __AST_H
#define __AST_H

#include <cstdint>
#include <string>
#include <vector>

#include "AST/AstDumper.hpp"

struct Location {
    Location(const uint32_t line, const uint32_t col)
        : line(line)
        , col(col)
    {
    }

    uint32_t line;
    uint32_t col;
};

class AstNode {
public:
    AstNode(const uint32_t line, const uint32_t col);
    virtual ~AstNode() = 0;

    const Location& getLocation() const;
    virtual void print() = 0;
    virtual void visitChildNodes(AstDumper& p_visitor) = 0;
    virtual void accept(AstDumper& p_visitor) = 0;

    const void outputIndentationSpace();
    const void incrementIndentation();
    const void decrementIndentation();

protected:
    const Location location;
};

extern int indentation;

#endif
