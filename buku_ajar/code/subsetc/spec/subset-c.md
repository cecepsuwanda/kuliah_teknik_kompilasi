# Subset-C (SC) — Spesifikasi Bahasa v0.1

Status: **M0 (Bab III)**. Spesifikasi ini akan diperluas pada Bab V
(token), Bab VIII (tata bahasa), Bab XIV (tipe), dan Bab XVI
(validasi).

## 1. Tujuan

Subset-C adalah bahasa kecil bergaya C untuk pembelajaran front-end
kompilator. Bahasa ini cukup kaya untuk memperlihatkan analisis
leksikal, sintaksis, semantik, dan validasi, tetapi cukup kecil untuk
diselesaikan dalam satu semester.

## 2. Ruang Lingkup

Didukung:
- tipe dasar `int`, `float`, `char`, dan `void`;
- fungsi dengan parameter dan nilai balik;
- deklarasi variabel lokal;
- ekspresi aritmetika, relasional, dan logika;
- pernyataan `if`, `else`, `while`, `for`;
- `return`, `break`, `continue`;
- pernyataan `print` untuk keluaran sederhana;
- komentar `//` dan `/* ... */`.

Tidak didukung pada v1.0:
- pointer, array, struct, union, enum;
- preprocessor dan `#include`;
- fungsi variadik;
- kelas atau objek.

Fitur yang tidak didukung dapat menjadi proyek pengayaan.

## 3. Program Contoh

```c
// Program Subset-C pertama: penjumlahan dua bilangan
int main() {
    int a = 5;
    int b = 7;
    int hasil = a + b;
    print(hasil);
    return 0;
}
```

## 4. Unsur Leksikal

### 4.1 Kata Kunci

`int`, `float`, `char`, `void`, `if`, `else`, `while`, `for`,
`return`, `break`, `continue`, `print`.

### 4.2 Pengenal

Pengenal dimulai dengan huruf atau garis bawah, diikuti huruf, angka,
atau garis bawah. Panjang maksimum 63 karakter.

### 4.3 Literal

- Bilangan bulat: `0`, `42`, `1000`.
- Bilangan pecahan: `3.14`, `0.5`, `2.0`.
- Karakter: `'a'`, `'\n'`, `'\\'`.
- String: `"halo"`, `"baris\nbaru"`.

### 4.4 Operator dan Tanda Baca

`+ - * / %`, `< <= > >= == !=`, `&& || !`, `=`, `( ) { } ; ,`.

### 4.5 Komentar

Komentar baris dimulai dengan `//` sampai akhir baris. Komentar blok
dimulai dengan `/*` dan berakhir dengan `*/`. Komentar blok tidak
bersarang.

## 5. Tata Bahasa Ringkas (v0.1)

```ebnf
program     = { topdecl } EOF ;
topdecl     = type ID "(" [ params ] ")" ( block | ";" ) ;
params      = param { "," param } ;
param       = type ID ;
type        = "int" | "float" | "char" | "void" ;
block       = "{" { stmt } "}" ;
stmt        = decl ";" | block | ifstmt | whilestmt | forstmt
            | returnstmt | breakstmt | continuestmt
            | expr ";" | printstmt | ";" ;
ifstmt      = "if" "(" expr ")" stmt [ "else" stmt ] ;
whilestmt   = "while" "(" expr ")" stmt ;
forstmt     = "for" "(" [ expr ] ";" [ expr ] ";" [ expr ] ")" stmt ;
returnstmt  = "return" [ expr ] ";" ;
printstmt   = "print" "(" expr ")" ";" ;
expr        = assign ;
assign      = ID "=" assign | logor ;
logor       = logand { "||" logand } ;
logand      = equality { "&&" equality } ;
equality    = relation { ( "==" | "!=" ) relation } ;
relation    = additive { ( "<" | "<=" | ">" | ">=" ) additive } ;
additive    = term { ( "+" | "-" ) term } ;
term        = unary { ( "*" | "/" | "%" ) unary } ;
unary       = ( "!" | "-" | "+" ) unary | primary ;
primary     = INT | FLOAT | CHAR | STRING | ID
            | ID "(" [ args ] ")" | "(" expr ")" ;
```

Tata bahasa ini masih bersifat rancangan dan akan diubah menjadi
LL(1) pada Bab IX.

## 6. Aturan Semantik Ringkas

- Tipe dasar: `int`, `float`, `char`, `void`.
- Konversi implisit `int -> float` dan `char -> int` diizinkan.
- Konversi `float -> int` memerlukan cast eksplisit (belum didukung
  v1.0).
- `print` menerima `int`, `float`, `char`, atau `string`.
- `break` dan `continue` hanya valid di dalam loop.
- Fungsi non-`void` harus mengembalikan nilai.
- `main` harus `int main()` tanpa parameter.
- Deklarasi ulang dalam scope yang sama adalah kesalahan.

## 7. Struktur Repositori

```text
subsetc/
├── spec/          spesifikasi bahasa dan token
├── include/       header C
├── src/           implementasi
├── examples/      program contoh
├── tests/         tes dan berkas harapan
└── scripts/       skrip bantu
```

## 8. Status Implementasi

| Komponen | Status |
|---|---|
| Spesifikasi v0.1 | selesai (M0) |
| Token dan lexer | Bab V--VII |
| Parser dan AST | Bab X--XIII |
| Analisis semantik | Bab XIV--XV |
| Validator | Bab XVI |
