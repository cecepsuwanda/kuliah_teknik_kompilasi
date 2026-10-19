// Berkas: include/types.h
// Representasi tipe untuk analisis semantik Subset-C.

#ifndef SUBSETC_TYPES_H
#define SUBSETC_TYPES_H

typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_CHAR,
    TYPE_VOID,
    TYPE_STRING,
    TYPE_BOOL,
    TYPE_ERROR
} TypeKind;

typedef struct {
    TypeKind kind;
} Type;

const char *type_name(TypeKind kind);
int type_is_numeric(TypeKind kind);
TypeKind type_arith(TypeKind left, TypeKind right);
int type_assignable(TypeKind target, TypeKind source);

#endif /* SUBSETC_TYPES_H */
