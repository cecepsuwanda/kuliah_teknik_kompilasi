# Spesifikasi Proyek Compiler Subset C

Ringkasan untuk codebase proyek. Spesifikasi resmi ada di **Buku Ajar Teknik Kompilasi**, Bab 1, Bagian "Proyek Buku: Compiler Subset C".

## Token

- **Identifier**: `[a-zA-Z_][a-zA-Z0-9_]*`
- **Kata kunci**: `int`, `float`, `print`
- **Literal**: integer `[0-9]+`, float `[0-9]+.[0-9]+`, string `"..."`
- **Operator**: `+`, `-`, `*`, `/`, `=`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Punctuator**: `;`, `,`, `(`, `)`, `{`, `}`
- **Komentar**: `//` dan `/* */`; whitespace diabaikan

## Grammar (BNF)

- **program** → barisan statement
- **statement** → declaration `;` | assignment `;` | print-statement `;`
- **declaration** → `int` identifier | `float` identifier
- **assignment** → identifier `=` expr
- **print-statement** → `print` `(` string-literal `)` | `print` `(` expr `)`
- **expr** → term | expr `+` term | expr `-` term
- **term** → factor | term `*` factor | term `/` factor
- **factor** → literal | identifier | `(` expr `)`

Precedence: `*`, `/` lebih tinggi dari `+`, `-`; associativity kiri.
