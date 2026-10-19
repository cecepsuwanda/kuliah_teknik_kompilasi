# Spesifikasi Token Subset-C v0.2

Status: **Bab V**. Spesifikasi ini menjadi acuan implementasi lexer
pada Bab VII.

## 1. Prinsip

1. **Maximal munch**: lexer selalu memilih lexeme terpanjang yang
   cocok.
2. **Prioritas aturan**: jika dua aturan menghasilkan panjang sama,
   aturan yang lebih awal dalam berkas spesifikasi menang.
3. **Kata kunci dikenali setelah identifier**: lexer membaca
   identifier, lalu memeriksa tabel kata kunci.
4. **Setiap token membawa lokasi**: baris dan kolom awal token.

## 2. Daftar Token

| Kategori | Token | Lexeme contoh | Pola |
|---|---|---|---|
| Kata kunci | `TOK_INT` | `int` | `int` |
| | `TOK_FLOAT` | `float` | `float` |
| | `TOK_CHAR` | `char` | `char` |
| | `TOK_VOID` | `void` | `void` |
| | `TOK_IF` | `if` | `if` |
| | `TOK_ELSE` | `else` | `else` |
| | `TOK_WHILE` | `while` | `while` |
| | `TOK_FOR` | `for` | `for` |
| | `TOK_RETURN` | `return` | `return` |
| | `TOK_BREAK` | `break` | `break` |
| | `TOK_CONTINUE` | `continue` | `continue` |
| | `TOK_PRINT` | `print` | `print` |
| Identifier | `TOK_IDENT` | `hasil`, `_x1` | `[A-Za-z_][A-Za-z0-9_]*` |
| Integer | `TOK_INT_LIT` | `0`, `42` | `[0-9]+` |
| Float | `TOK_FLOAT_LIT` | `3.14`, `2.0` | `[0-9]+\.[0-9]+` |
| Char | `TOK_CHAR_LIT` | `'a'`, `'\n'` | `'([^'\\]|\\.)'` |
| String | `TOK_STRING_LIT` | `"halo"` | `"([^"\\]|\\.)*"` |
| Operator | `TOK_PLUS` | `+` | `\+` |
| | `TOK_MINUS` | `-` | `-` |
| | `TOK_STAR` | `*` | `\*` |
| | `TOK_SLASH` | `/` | `/` |
| | `TOK_PERCENT` | `%` | `%` |
| | `TOK_LT` | `<` | `<` |
| | `TOK_LE` | `<=` | `<=` |
| | `TOK_GT` | `>` | `>` |
| | `TOK_GE` | `>=` | `>=` |
| | `TOK_EQ` | `==` | `==` |
| | `TOK_NE` | `!=` | `!=` |
| | `TOK_AND` | `&&` | `&&` |
| | `TOK_OR` | `\|\|` | `\|\|` |
| | `TOK_NOT` | `!` | `!` |
| | `TOK_ASSIGN` | `=` | `=` |
| Tanda baca | `TOK_LPAREN` | `(` | `\(` |
| | `TOK_RPAREN` | `)` | `\)` |
| | `TOK_LBRACE` | `{` | `\{` |
| | `TOK_RBRACE` | `}` | `\}` |
| | `TOK_SEMI` | `;` | `;` |
| | `TOK_COMMA` | `,` | `,` |
| Akhir | `TOK_EOF` | --- | akhir masukan |
| Kesalahan | `TOK_ERROR` | --- | karakter ilegal |

## 3. Aturan Prioritas

Aturan diurutkan sebagai berikut:

1. komentar (`//`, `/* */`) dan whitespace: dibuang;
2. operator dua karakter: `<=`, `>=`, `==`, `!=`, `&&`, `||`;
3. operator dan tanda baca satu karakter;
4. literal float (sebelum integer);
5. literal integer;
6. identifier dan kata kunci;
7. literal char dan string;
8. karakter ilegal -> `TOK_ERROR`.

Urutan ini memastikan `<=` tidak dibaca sebagai `<` diikuti `=`, dan
`3.14` tidak dibaca sebagai `3` diikuti `.` dan `14`.

## 4. Kesalahan Leksikal

| Kasus | Perilaku |
|---|---|
| Karakter ilegal, misalnya `@` | Hasilkan `TOK_ERROR`, lanjutkan |
| String tidak ditutup | `TOK_ERROR` pada baris awal string |
| Char literal kosong atau terlalu panjang | `TOK_ERROR` |
| Komentar blok tidak ditutup | `TOK_ERROR` pada baris awal komentar |
| Float tanpa digit setelah titik | `TOK_ERROR` (mis. `3.`) |

## 5. Format Keluaran Tes

Setiap baris keluaran lexer:

```text
BARIS:KOLOM JENIS LEXEME
```

Contoh:

```text
1:1 INT int
1:5 IDENT main
1:9 LPAREN (
1:10 RPAREN )
```
