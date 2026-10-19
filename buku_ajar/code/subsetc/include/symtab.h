// Berkas: include/symtab.h
// Tabel simbol dengan scope bersarang.

#ifndef SUBSETC_SYMTAB_H
#define SUBSETC_SYMTAB_H

#include "types.h"

typedef enum {
    SYM_VAR,
    SYM_FUNC,
    SYM_PARAM
} SymbolKind;

typedef struct Symbol {
    char *name;
    TypeKind type;
    SymbolKind kind;
    int line;
    int column;
    struct Symbol *next;
} Symbol;

typedef struct Scope {
    Symbol *symbols;
    struct Scope *parent;
} Scope;

typedef struct {
    Scope *current;
} SymTab;

void symtab_init(SymTab *table);
void symtab_free(SymTab *table);

void symtab_enter_scope(SymTab *table);
void symtab_leave_scope(SymTab *table);

Symbol *symtab_define(SymTab *table, const char *name, int length,
                      TypeKind type, SymbolKind kind,
                      int line, int column);
Symbol *symtab_lookup(const SymTab *table, const char *name,
                      int length);
Symbol *symtab_lookup_current(const SymTab *table, const char *name,
                              int length);

#endif /* SUBSETC_SYMTAB_H */
