# Subset-C Mini Compiler

Proyek mini-kompilator untuk mata kuliah Teknik Kompilasi.
Bahasa target: **Subset-C (SC)**, sebuah subset bahasa C untuk
pembelajaran front-end kompilator.

## Status

Tahap **M0**: struktur repositori dan spesifikasi bahasa v0.1.
Implementasi lexer, parser, AST, dan analisis semantik ditambahkan
pada bab-bab berikutnya.

## Struktur

```text
subsetc/
├── Makefile
├── build.bat
├── spec/
│   └── subset-c.md
├── include/        (ditambahkan pada Bab V)
├── src/            (ditambahkan pada Bab VII)
├── examples/
│   └── hello.sc
├── tests/
│   ├── lexer/
│   ├── parser/
│   └── semantic/
└── scripts/
    └── run-tests.bat
```

## Prasyarat

- Kompiler C99 (gcc atau clang).
- Flex dan Bison untuk milestone M3.
- Tidak ada dependensi pihak ketiga.

## Build

```bat
build.bat
```

atau, pada sistem dengan `make`:

```sh
make
```

## Menjalankan

```bat
build\scc.exe examples\hello.sc
```

Keluaran yang diharapkan pada M5: program tervalidasi tanpa diagnostik.

## Catatan

Repositori ini disusun bertahap mengikuti bab buku ajar. Setiap
milestone menambahkan satu lapisan:

| Milestone | Bab | Isi |
|---|---|---|
| M0 | III | repo, spesifikasi, program contoh |
| M1 | VII | lexer tangan dan Flex |
| M2 | X | recursive descent parser |
| M3 | XIII | Bison, AST |
| M4 | XV | symbol table, type checker |
| M5 | XVI | validator dan diagnostik |
