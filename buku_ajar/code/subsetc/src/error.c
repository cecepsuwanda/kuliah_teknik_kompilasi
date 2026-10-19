// Berkas: src/error.c
#include <stdio.h>
#include "error.h"

void error_at(const char *filename, int line, int column,
              const char *message) {
    fprintf(stderr, "%s:%d:%d: error: %s\n",
            filename ? filename : "<input>", line, column, message);
}
