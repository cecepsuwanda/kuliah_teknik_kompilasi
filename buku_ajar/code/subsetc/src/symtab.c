// Berkas: src/symtab.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

static char *duplicate_n(const char *text, int length) {
    char *copy = (char *)malloc((size_t)length + 1);
    if (!copy) {
        fprintf(stderr, "kehabisan memori pada tabel simbol\n");
        exit(1);
    }
    memcpy(copy, text, (size_t)length);
    copy[length] = '\0';
    return copy;
}

void symtab_init(SymTab *table) {
    table->current = (Scope *)calloc(1, sizeof(Scope));
    if (!table->current) {
        fprintf(stderr, "kehabisan memori pada tabel simbol\n");
        exit(1);
    }
    table->current->symbols = NULL;
    table->current->parent = NULL;
}

void symtab_enter_scope(SymTab *table) {
    Scope *scope = (Scope *)calloc(1, sizeof(Scope));
    if (!scope) {
        fprintf(stderr, "kehabisan memori pada tabel simbol\n");
        exit(1);
    }
    scope->symbols = NULL;
    scope->parent = table->current;
    table->current = scope;
}

void symtab_leave_scope(SymTab *table) {
    Scope *scope = table->current;
    Symbol *symbol;
    Symbol *next;

    if (!scope || !scope->parent) {
        return;
    }

    symbol = scope->symbols;
    while (symbol) {
        next = symbol->next;
        free(symbol->name);
        free(symbol);
        symbol = next;
    }

    table->current = scope->parent;
    free(scope);
}

Symbol *symtab_define(SymTab *table, const char *name, int length,
                      TypeKind type, SymbolKind kind,
                      int line, int column) {
    Symbol *symbol = (Symbol *)calloc(1, sizeof(Symbol));
    if (!symbol) {
        fprintf(stderr, "kehabisan memori pada tabel simbol\n");
        exit(1);
    }

    symbol->name = duplicate_n(name, length);
    symbol->type = type;
    symbol->kind = kind;
    symbol->line = line;
    symbol->column = column;
    symbol->next = table->current->symbols;
    table->current->symbols = symbol;
    return symbol;
}

static Symbol *lookup_in_scope(Scope *scope, const char *name,
                               int length) {
    Symbol *symbol;
    for (symbol = scope ? scope->symbols : NULL;
         symbol; symbol = symbol->next) {
        if ((int)strlen(symbol->name) == length &&
            strncmp(symbol->name, name, (size_t)length) == 0) {
            return symbol;
        }
    }
    return NULL;
}

Symbol *symtab_lookup_current(const SymTab *table, const char *name,
                              int length) {
    return lookup_in_scope(table->current, name, length);
}

Symbol *symtab_lookup(const SymTab *table, const char *name,
                      int length) {
    Scope *scope;
    for (scope = table->current; scope; scope = scope->parent) {
        Symbol *symbol = lookup_in_scope(scope, name, length);
        if (symbol) {
            return symbol;
        }
    }
    return NULL;
}

void symtab_free(SymTab *table) {
    while (table->current) {
        if (!table->current->parent) {
            Symbol *symbol = table->current->symbols;
            while (symbol) {
                Symbol *next = symbol->next;
                free(symbol->name);
                free(symbol);
                symbol = next;
            }
            free(table->current);
            table->current = NULL;
        } else {
            symtab_leave_scope(table);
        }
    }
}
