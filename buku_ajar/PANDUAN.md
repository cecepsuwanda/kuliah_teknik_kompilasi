# PANDUAN PENULISAN DAN REGISTRI

Berkas ini adalah memori bersama untuk seluruh sesi penulisan.
Setiap bab harus mengikuti aturan di sini.

## 1. Urutan OBE setiap bab inti

1. `chapter.tex`: judul, `outcomebox` berisi Sub-CPMK dan tujuan, `Materi Pokok`.
2. `section-01.tex` ... `section-05.tex`: materi utama.
3. `contoh.tex`: 2-4 contoh berpenyelesaian.
4. `praktikum.tex`: aktivitas pembelajaran dan increment proyek.
5. `latihan.tex`: soal latihan dan refleksi.
6. `asesmen.tex`: instrumen asesmen dan rubrik.
7. `checklist.tex`: daftar cek kompetensi.
8. `rangkuman.tex`: ringkasan dan jembatan ke bab berikutnya.
9. `evaluasi.tex`: soal evaluasi akhir bab.

## 2. Registri label

| Label | Berkas | Keterangan |
|---|---|---|
| `chap:orientasi` | `chapters/01/chapter.tex` | Bab I |
| `chap:landasan` | `chapters/02/chapter.tex` | Bab II |
| `chap:arsitektur` | `chapters/03/chapter.tex` | Bab III |
| `chap:bahasa-formal` | `chapters/04/chapter.tex` | Bab IV |
| `chap:leksikal` | `chapters/05/chapter.tex` | Bab V |
| `chap:finite-automata` | `chapters/06/chapter.tex` | Bab VI |
| `chap:implementasi-lexer` | `chapters/07/chapter.tex` | Bab VII |
| `chap:cfg` | `chapters/08/chapter.tex` | Bab VIII |
| `chap:ambiguitas` | `chapters/09/chapter.tex` | Bab IX |
| `chap:top-down` | `chapters/10/chapter.tex` | Bab X |
| `chap:bottom-up` | `chapters/11/chapter.tex` | Bab XI |
| `chap:lr-parsing` | `chapters/12/chapter.tex` | Bab XII |
| `chap:parser-generator` | `chapters/13/chapter.tex` | Bab XIII |
| `chap:semantik` | `chapters/14/chapter.tex` | Bab XIV |
| `chap:symbol-table` | `chapters/15/chapter.tex` | Bab XV |
| `chap:ast-validasi` | `chapters/16/chapter.tex` | Bab XVI |
| `chap:evaluasi` | `chapters/17/chapter.tex` | Bab XVII |

## 3. Peta Sub-CPMK ke bab utama

| Sub-CPMK | Bab utama |
|---|---|
| 1.1, 1.2, 1.3 | Bab III |
| 1.4 | Bab IV |
| 1.5 | Bab XIV |
| 1.6 | Bab XV |
| 1.7 | Bab XVI |
| 2.1 | Bab V |
| 2.2, 2.3 | Bab VI |
| 2.4 | Bab VII |
| 3.1, 3.4 | Bab VIII |
| 3.2 | Bab IX |
| 3.3, 4.1 | Bab X |
| 4.2 | Bab XI dan XII |
| 4.3, 4.4 | Bab XIII dan XVI |

Gunakan `\subcpmk{...}` hanya untuk Sub-CPMK utama di `outcomebox`.
Gunakan `\subcpmkref{...}` untuk rujukan pendukung.

## 4. Terminologi

| Indonesia | Inggris (miring saat pertama) | Catatan |
|---|---|---|
| kompilator | *compiler* | bentuk baku di buku |
| penerjemah | *translator* | |
| analisis leksikal | *lexical analysis* | |
| analisis sintaksis | *syntax analysis* | *parsing* juga dipakai |
| analisis semantik | *semantic analysis* | |
| token | *token* | |
| leksem | *lexeme* | |
| pola | *pattern* | |
| ekspresi reguler | *regular expression* | |
| otomata hingga | *finite automaton* | |
| tata bahasa bebas konteks | *context-free grammar* | CFG |
| pohon urai | *parse tree* | |
| pohon sintaks abstrak | *abstract syntax tree* | AST |
| tabel simbol | *symbol table* | |
| pemeriksaan tipe | *type checking* | |
| pemulihan kesalahan | *error recovery* | |

Aturan: istilah Inggris dimiringkan dengan `\eng{...}` pada kemunculan
pertama di setiap bab, lalu bentuk Indonesia dipakai konsisten.

## 5. Konvensi kode dan listing

- Bahasa proyek: C99; indentasi 4 spasi; maksimum 78 kolom; tanpa tab.
- Berkas proyek berada di `code/subsetc/`.
- Kutipan kode memakai `\includecode[language=C, firstline=..., lastline=...,
  firstnumber=..., caption={...}, label={lst:...}]{../../code/...}`.
- Caption berbahasa Indonesia; label unik dengan awalan `lst:`.
- Kode dibekukan sebelum bab yang mendokumentasikannya ditulis.

## 6. Status bab

| Bab | Status | Catatan |
|---|---|---|
| 01 | selesai | Orientasi, 8 hlm mandiri |
| 02 | selesai | Landasan teori, 14 hlm mandiri |
| 03 | selesai | Arsitektur, M0 |
| 04 | selesai | Hierarki Chomsky |
| 05 | selesai | Leksikal, spec token v0.2 |
| 06 | selesai | Finite automata, fa_tool.py |
| 07 | selesai | Lexer, M1/Praktikum 1 |
| 08 | selesai | CFG/BNF/EBNF |
| 09 | selesai | Ambiguitas, left recursion |
| 10 | selesai | LL(1), M2/Praktikum 2 |
| 11 | selesai | Shift-reduce |
| 12 | selesai | LR/SLR/LALR, slr_table.py |
| 13 | selesai | Bison/AST, M3/Praktikum 3 |
| 14 | selesai | Analisis semantik, types.h |
| 15 | selesai | Symbol table, M4/Praktikum 4 |
| 16 | selesai | Validasi, M5/Project Final |
| 17 | selesai | Evaluasi dan integrasi |

## 7. Milestone kode

| Milestone | Bab | Artefak |
|---|---|---|
| M0 | III | repo, Makefile, spec v0.1, hello.sc |
| M1 | VII | lexer tangan + Flex, tes |
| M2 | X | recursive descent parser, tes |
| M3 | XIII | Bison + AST |
| M4 | XV | symbol table + type checker |
| M5 | XVI | validator + diagnostik |
