// Berkas: src/validate.c
#include <stdio.h>
#include <stdlib.h>
#include "validate.h"
#include "types.h"
#include "error.h"

typedef struct {
    int loop_depth;
    TypeKind return_type;
    int has_return;
    int had_error;
} Context;

static void visit(Context *context, AstNode *node);

static void visit_children(Context *context, AstNode *node) {
    AstNode *child;
    for (child = node->children; child; child = child->next) {
        visit(context, child);
    }
}

static void report(AstNode *node, Context *context,
                   const char *message) {
    error_at("<validate>", node->token.line, node->token.column,
             message);
    context->had_error = 1;
}

static void visit(Context *context, AstNode *node) {
    if (!node) {
        return;
    }

    switch (node->kind) {
    case AST_FUNC: {
        Context inner;
        inner.loop_depth = 0;
        inner.return_type = node->decl_type;
        inner.has_return = 0;
        inner.had_error = 0;

        visit_children(&inner, node);

        if (node->decl_type != TYPE_VOID && !inner.has_return) {
            report(node, context,
                   "fungsi non-void harus mengembalikan nilai");
        }
        if (inner.had_error) {
            context->had_error = 1;
        }
        break;
    }

    case AST_BLOCK:
        visit_children(context, node);
        break;

    case AST_WHILE:
    case AST_FOR:
        context->loop_depth++;
        visit_children(context, node);
        context->loop_depth--;
        break;

    case AST_BREAK:
        if (context->loop_depth == 0) {
            report(node, context,
                   "break hanya valid di dalam loop");
        }
        break;

    case AST_CONTINUE:
        if (context->loop_depth == 0) {
            report(node, context,
                   "continue hanya valid di dalam loop");
        }
        break;

    case AST_RETURN:
        context->has_return = 1;
        visit_children(context, node);
        break;

    default:
        visit_children(context, node);
        break;
    }
}

int validate_program(AstNode *root) {
    Context context;
    context.loop_depth = 0;
    context.return_type = TYPE_VOID;
    context.has_return = 0;
    context.had_error = 0;

    visit_children(&context, root);
    return context.had_error;
}
