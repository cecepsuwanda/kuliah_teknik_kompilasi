// Berkas: include/typecheck.h
// Pemeriksaan tipe untuk AST Subset-C.

#ifndef SUBSETC_TYPECHECK_H
#define SUBSETC_TYPECHECK_H

#include "ast.h"
#include "symtab.h"

int typecheck_program(SymTab *table, AstNode *root);

#endif /* SUBSETC_TYPECHECK_H */
