// Berkas: src/types.c
#include "types.h"

const char *type_name(TypeKind kind) {
    switch (kind) {
    case TYPE_INT:    return "int";
    case TYPE_FLOAT:  return "float";
    case TYPE_CHAR:   return "char";
    case TYPE_VOID:   return "void";
    case TYPE_STRING: return "string";
    case TYPE_BOOL:   return "bool";
    default:          return "error";
    }
}

int type_is_numeric(TypeKind kind) {
    return kind == TYPE_INT || kind == TYPE_FLOAT ||
           kind == TYPE_CHAR;
}

TypeKind type_arith(TypeKind left, TypeKind right) {
    if (left == TYPE_ERROR || right == TYPE_ERROR) {
        return TYPE_ERROR;
    }
    if (!type_is_numeric(left) || !type_is_numeric(right)) {
        return TYPE_ERROR;
    }
    if (left == TYPE_FLOAT || right == TYPE_FLOAT) {
        return TYPE_FLOAT;
    }
    return TYPE_INT;
}

int type_assignable(TypeKind target, TypeKind source) {
    if (target == source) {
        return 1;
    }
    if (target == TYPE_FLOAT &&
        (source == TYPE_INT || source == TYPE_CHAR)) {
        return 1;
    }
    if (target == TYPE_INT && source == TYPE_CHAR) {
        return 1;
    }
    return 0;
}
