# Proyek Compiler Subset C

Codebase ini mendampingi **Buku Ajar Teknik Kompilasi**. Dari Bab 2 hingga Bab 16, setiap bab menambah satu lapis ke compiler untuk subset bahasa C ini. Spesifikasi token dan grammar ada di **Bab 1** (Bagian "Proyek Buku: Compiler Subset C") dalam buku.

## Struktur file (sesuai lapis per bab)

| Bab | Lapis | File |
|-----|--------|------|
| 2 | Spesifikasi token | Lihat Bab 1 + `SPESIFIKASI_SUBSET_C.md` |
| 4 | Lexer proyek (Flex) | `simplec.l` |
| 8 | Parser proyek (Bison) | `simplec.y`, `simplec.tab.h`, `simplec.tab.c` (generated) |
| 9 | AST proyek | `ast.h`, `ast.c` (direncanakan) |
| 10 | Symbol table proyek | `symtab.h`, `symtab.c` (direncanakan) |
| 11 | Type checking | Modul typecheck (direncanakan) |
| 12 | IR proyek | Representasi TAC/quadruples (direncanakan) |
| 14 | Code generation | Modul codegen (direncanakan) |
| 15 | Optimasi | Modul optimasi (direncanakan) |

## Build (Flex + Bison)

```bash
flex -o simplec.lex.c simplec.l
bison -d -o simplec.tab.c simplec.y
gcc -o simplec simplec.lex.c simplec.tab.c -lfl
```

Atau sesuaikan dengan lingkungan Anda (MinGW, MSYS2, Linux, dll.). File `simplec.tab.h` dihasilkan oleh Bison dan dipakai oleh `simplec.l`.

## Spesifikasi

Lihat `SPESIFIKASI_SUBSET_C.md` untuk ringkasan token dan grammar subset C. Rincian lengkap ada di buku, Bab 1, Bagian "Proyek Buku: Compiler Subset C".
