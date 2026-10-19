// Berkas: code/teaching/shift_reduce.c
// Kalkulator shift-reduce sederhana untuk ekspresi digit tunggal
// dengan operator +, *, dan tanda kurung.
// Program ini mengilustrasikan stack, shift, dan reduce; bukan
// parser Subset-C yang lengkap.

#include <stdio.h>
#include <stdlib.h>

static int precedence(char op) {
    if (op == '+' || op == '-') {
        return 1;
    }
    if (op == '*' || op == '/') {
        return 2;
    }
    return 0;
}

static int apply(int left, char op, int right) {
    switch (op) {
    case '+': return left + right;
    case '-': return left - right;
    case '*': return left * right;
    case '/': return right == 0 ? 0 : left / right;
    default:  return 0;
    }
}

static void reduce_top(int *values, int *vtop,
                       char *ops, int *otop) {
    int right = values[(*vtop)--];
    int left = values[(*vtop)--];
    char op = ops[(*otop)--];
    values[++(*vtop)] = apply(left, op, right);
    printf("  reduce: %d %c %d -> %d\n",
           left, op, right, values[*vtop]);
}

int main(void) {
    const char *input = "2+3*4";
    int values[64];
    char ops[64];
    int vtop = -1;
    int otop = -1;
    const char *p;

    printf("Masukan: %s\n", input);

    for (p = input; *p; p++) {
        if (*p >= '0' && *p <= '9') {
            values[++vtop] = *p - '0';
            printf("  shift angka %c\n", *p);
        } else if (*p == '(') {
            ops[++otop] = *p;
            printf("  shift '('\n");
        } else if (*p == ')') {
            while (otop >= 0 && ops[otop] != '(') {
                reduce_top(values, &vtop, ops, &otop);
            }
            if (otop >= 0) {
                otop--;
            }
        } else {
            while (otop >= 0 && ops[otop] != '(' &&
                   precedence(ops[otop]) >= precedence(*p)) {
                reduce_top(values, &vtop, ops, &otop);
            }
            ops[++otop] = *p;
            printf("  shift operator %c\n", *p);
        }
    }

    while (otop >= 0) {
        reduce_top(values, &vtop, ops, &otop);
    }

    printf("Hasil: %d\n", values[vtop]);
    return 0;
}
