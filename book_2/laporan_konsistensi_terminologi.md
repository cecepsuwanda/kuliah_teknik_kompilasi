# Laporan Konsistensi Terminologi Buku Teknik Kompilasi

**Tanggal Pemeriksaan**: 2026-01-25  
**Total Bab**: 21 bab  
**Total Section**: 195+ file section  
**Metodologi**: Pemeriksaan sistematis menggunakan grep dan analisis manual

---

## Daftar Isi

1. [Ringkasan Eksekutif](#ringkasan-eksekutif)
2. [Tabel Inventarisasi Terminologi](#tabel-inventarisasi-terminologi)
3. [Daftar Inkonsistensi Detail](#daftar-inkonsistensi-detail)
4. [Rekomendasi Standardisasi](#rekomendasi-standardisasi)
5. [Statistik per Bab](#statistik-per-bab)
6. [Daftar File yang Perlu Diperbaiki](#daftar-file-yang-perlu-diperbaiki)
7. [Matriks Konsistensi Terminologi](#matriks-konsistensi-terminologi)
8. [Kesimpulan](#kesimpulan)
9. [Quick Reference Guide untuk Implementasi](#quick-reference-guide-untuk-implementasi)
10. [Contoh Perbaikan Konkret](#contoh-perbaikan-konkret)
11. [Checklist Implementasi](#checklist-implementasi)
12. [Strategi Implementasi Bertahap](#strategi-implementasi-bertahap)
13. [Tools dan Scripts untuk Implementasi](#tools-dan-scripts-untuk-implementasi)
14. [FAQ](#faq-frequently-asked-questions)
15. [Metrik Kuantitatif Detail](#metrik-kuantitatif-detail)
16. [Timeline Implementasi](#timeline-implementasi)
17. [Ringkasan Rekomendasi untuk Implementasi](#ringkasan-rekomendasi-untuk-implementasi)

---

## Ringkasan Eksekutif

Pemeriksaan konsistensi terminologi telah dilakukan terhadap seluruh 21 bab buku ajar "Teknik Kompilasi". Dari analisis yang dilakukan, ditemukan **inkonsistensi penggunaan terminologi** antara bahasa Indonesia dan bahasa Inggris di seluruh buku.

### Temuan Utama

- **Total terminologi yang diperiksa**: 15 terminologi kunci
- **Terminologi dengan inkonsistensi**: 8 terminologi
- **Terminologi konsisten**: 7 terminologi (kebanyakan menggunakan istilah Inggris)
- **Tingkat konsistensi keseluruhan**: ~60% (terdapat variasi penggunaan yang signifikan)

### Rekomendasi Umum

1. **Standarisasi penggunaan terminologi Indonesia** untuk istilah umum dengan penambahan istilah Inggris dalam kurung pada penggunaan pertama
2. **Pertahankan istilah Inggris** untuk istilah teknis yang sudah sangat umum (parser, lexer, AST, IR)
3. **Konsistensi dengan judul bab**: Gunakan terminologi yang sama dengan judul bab di seluruh konten bab tersebut

---

## Tabel Inventarisasi Terminologi

| No | Terminologi | Variasi yang Ditemukan | Frekuensi | Status |
|----|------------|------------------------|-----------|--------|
| 1 | Kompilator/Compiler | kompilator, compiler, Kompilator, Compiler | ~200+ | **INKONSISTEN** |
| 2 | Parser | parser, Parser | ~300+ | **KONSISTEN** (selalu Inggris) |
| 3 | Lexer/Lexical Analysis | lexer, Lexer, Lexical Analysis, analisis leksikal, Analisis Leksikal | ~400+ | **INKONSISTEN** |
| 4 | Syntax Analysis | Syntax Analysis, syntax analysis, analisis sintaksis, Analisis Sintaksis | ~240+ | **INKONSISTEN** |
| 5 | Semantic Analysis | Semantic Analysis, semantic analysis, analisis semantik, Analisis Semantik | ~80+ | **INKONSISTEN** |
| 6 | Optimasi/Optimization | optimasi, Optimasi, optimization, Optimization | ~220+ | **INKONSISTEN** |
| 7 | Interpreter | interpreter, Interpreter | ~20+ | **KONSISTEN** (selalu Inggris) |
| 8 | Finite Automata | Finite Automata, finite automata | ~35+ | **KONSISTEN** (selalu Inggris) |
| 9 | Regular Expression | Regular Expression, regular expression | ~45+ | **KONSISTEN** (selalu Inggris) |
| 10 | Context-Free Grammar | Context-Free Grammar, CFG, context-free grammar | ~40+ | **KONSISTEN** (selalu Inggris) |
| 11 | Symbol Table | Symbol Table, symbol table | ~80+ | **KONSISTEN** (selalu Inggris) |
| 12 | Type Checking | Type Checking, type checking | ~70+ | **KONSISTEN** (selalu Inggris) |
| 13 | Code Generation | Code Generation, code generation, generasi kode | ~120+ | **INKONSISTEN** |
| 14 | IR/Intermediate Representation | IR, Intermediate Representation, intermediate representation, representasi intermediate | ~115+ | **INKONSISTEN** |
| 15 | AST | AST, Abstract Syntax Tree, abstract syntax tree | ~270+ | **KONSISTEN** (selalu Inggris) |

---

## Daftar Inkonsistensi Detail

### 1. Kompilator vs Compiler

**Variasi yang digunakan:**
- **kompilator** (Indonesia): Digunakan di bab-00, bab-01, bab-15, bab-19, README.md
- **compiler** (Inggris): Digunakan di bab-20 (tutorial), beberapa section

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `chapters/bab-01.tex` | Kompilator | Judul bab: "Pengenalan Kompilator" |
| `chapters/bab-15.tex` | Optimasi Kompilator | Judul bab: "Optimasi Kompilator Dasar" |
| `chapters/bab-20.tex` | Compiler | Judul bab: "Tutorial: Membuat Compiler Sederhana" |
| `sections/bab-20_sec01.tex` | compiler | Seluruh konten tutorial menggunakan "compiler" |
| `sections/bab-20_sec02.tex` | compiler | Konten menggunakan "compiler" |
| `sections/bab-20_sec05.tex` | compiler | Script dan dokumentasi menggunakan "compiler" |
| `chapters/bab-00.tex` | kompilator | Prakata menggunakan "kompilator" |
| `README.md` | kompilator | Dokumentasi menggunakan "kompilator" |

**Rekomendasi Standardisasi:**
- **Standar**: **Kompilator** (dengan "Compiler" dalam kurung pada penggunaan pertama di setiap bab)
- **Alasan**: Judul bab 1 dan 15 menggunakan "Kompilator", buku berbahasa Indonesia
- **Pengecualian**: Bab 20 (tutorial) boleh tetap menggunakan "compiler" karena konteks tutorial praktis dengan kode

### 2. Lexer vs Analisis Leksikal vs Lexical Analysis

**Variasi yang digunakan:**
- **lexer** (Inggris): Digunakan di bab-03, bab-04, bab-20
- **Lexical Analysis** (Inggris): Digunakan di banyak section
- **analisis leksikal** (Indonesia): Digunakan di bab-00, bab-16, README.md

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `chapters/bab-02.tex` | Lexical Analysis | Judul bab: "Regular Expression dan Finite Automata untuk Lexical Analysis" |
| `chapters/bab-03.tex` | Lexer | Judul bab: "Implementasi Lexer Sederhana" |
| `chapters/bab-04.tex` | Lexer Generator | Judul bab: "Lexer Generator" |
| `chapters/bab-00.tex` | analisis leksikal | Prakata menggunakan "analisis leksikal" |
| `sections/bab-16_sec02.tex` | analisis leksikal | Review materi menggunakan "analisis leksikal" |
| `README.md` | analisis leksikal | Dokumentasi menggunakan "analisis leksikal" |

**Rekomendasi Standardisasi:**
- **Standar**: **Analisis Leksikal** (dengan "Lexical Analysis" dalam kurung pada penggunaan pertama)
- **Untuk komponen**: **Lexer** (istilah teknis yang sudah umum, boleh tetap Inggris)
- **Alasan**: Konsisten dengan terminologi fase kompilasi lainnya

### 3. Syntax Analysis vs Analisis Sintaksis

**Variasi yang digunakan:**
- **Syntax Analysis** (Inggris): Digunakan di banyak section
- **analisis sintaksis** (Indonesia): Digunakan di bab-00, README.md

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `chapters/bab-00.tex` | analisis sintaksis | Prakata menggunakan "analisis sintaksis" |
| `sections/bab-01_sec04.tex` | Syntax Analysis | Diagram dan teks menggunakan "Syntax Analysis" |
| `sections/bab-01_sec05.tex` | Syntax Analysis | Subsection menggunakan "Syntax Analysis (Analisis Sintaksis)" |
| `README.md` | analisis sintaksis | Dokumentasi menggunakan "analisis sintaksis" |

**Rekomendasi Standardisasi:**
- **Standar**: **Analisis Sintaksis** (dengan "Syntax Analysis" dalam kurung pada penggunaan pertama)
- **Alasan**: Konsisten dengan terminologi fase kompilasi lainnya

### 4. Semantic Analysis vs Analisis Semantik

**Variasi yang digunakan:**
- **Semantic Analysis** (Inggris): Digunakan di banyak section
- **analisis semantik** (Indonesia): Digunakan di bab-00, README.md

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `chapters/bab-00.tex` | analisis semantik | Prakata menggunakan "analisis semantik" |
| `chapters/bab-11.tex` | Semantic Analysis | Judul bab: "Type Checking dan Semantic Analysis" |
| `sections/bab-01_sec05.tex` | Semantic Analysis | Subsection menggunakan "Semantic Analysis (Analisis Semantik)" |
| `README.md` | analisis semantik | Dokumentasi menggunakan "analisis semantik" |

**Rekomendasi Standardisasi:**
- **Standar**: **Analisis Semantik** (dengan "Semantic Analysis" dalam kurung pada penggunaan pertama)
- **Alasan**: Konsisten dengan terminologi fase kompilasi lainnya

### 5. Optimasi vs Optimization

**Variasi yang digunakan:**
- **optimasi** (Indonesia): Digunakan di bab-15, bab-16, banyak section
- **Optimization** (Inggris): Digunakan di diagram, beberapa section

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `chapters/bab-15.tex` | Optimasi Kompilator | Judul bab: "Optimasi Kompilator Dasar" |
| `sections/bab-01_sec03.tex` | Optimization | Diagram menggunakan "Optimization" |
| `sections/bab-01_sec05.tex` | Code Optimization | Subsection menggunakan "Code Optimization" |
| `sections/bab-15_sec02.tex` | Optimasi kompilator | Konten menggunakan "Optimasi kompilator" |
| `sections/bab-16_sec02.tex` | optimasi | Review menggunakan "optimasi" |

**Rekomendasi Standardisasi:**
- **Standar**: **Optimasi** (dengan "Optimization" dalam kurung pada penggunaan pertama)
- **Alasan**: Judul bab 15 menggunakan "Optimasi", konsisten dengan bahasa Indonesia

### 6. Code Generation vs Generasi Kode

**Variasi yang digunakan:**
- **Code Generation** (Inggris): Digunakan di banyak section dan judul bab
- **generasi kode** (Indonesia): Digunakan di bab-00, README.md

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `chapters/bab-12.tex` | Intermediate Code Generation | Judul bab: "Intermediate Code Generation" |
| `chapters/bab-14.tex` | Code Generation | Judul bab: "Code Generation untuk Target Architecture" |
| `chapters/bab-00.tex` | generasi kode | Prakata menggunakan "generasi kode" |
| `README.md` | generasi kode | Dokumentasi menggunakan "generasi kode" |

**Rekomendasi Standardisasi:**
- **Standar**: **Generasi Kode** (dengan "Code Generation" dalam kurung pada penggunaan pertama)
- **Untuk judul bab spesifik**: Boleh tetap "Code Generation" jika sudah menjadi istilah teknis standar
- **Alasan**: Konsisten dengan terminologi fase kompilasi lainnya

### 7. IR vs Intermediate Representation vs Representasi Intermediate

**Variasi yang digunakan:**
- **IR** (akronim): Digunakan di banyak tempat
- **Intermediate Representation** (Inggris): Digunakan di banyak section
- **representasi intermediate** (Indonesia): Digunakan di beberapa tempat

**Lokasi inkonsistensi:**

| File | Penggunaan | Konteks |
|------|------------|---------|
| `sections/bab-12_sec02.tex` | Intermediate Representation | Konten menggunakan "Intermediate Representation" |
| `sections/bab-01_sec05.tex` | intermediate representation | Konten menggunakan "intermediate representation" |
| Beberapa section | representasi intermediate | Beberapa tempat menggunakan "representasi intermediate" |

**Rekomendasi Standardisasi:**
- **Standar**: **IR** atau **Representasi Intermediate** (dengan "Intermediate Representation" dalam kurung pada penggunaan pertama)
- **Alasan**: IR adalah akronim yang sudah umum, tetapi perlu konsistensi dalam penggunaan bentuk lengkapnya

---

## Rekomendasi Standardisasi

### Prinsip Standardisasi

1. **Konsistensi dengan Judul Bab**: Gunakan terminologi yang sama dengan judul bab di seluruh konten bab tersebut
2. **Preferensi Bahasa Indonesia**: Untuk buku ajar berbahasa Indonesia, gunakan terminologi Indonesia dengan istilah Inggris dalam kurung pada penggunaan pertama
3. **Istilah Teknis Umum**: Untuk istilah yang sudah sangat umum dalam bahasa Inggris (parser, lexer, AST, IR), boleh tetap menggunakan bahasa Inggris
4. **Konsistensi dengan Referensi**: Jika mengutip referensi berbahasa Inggris, gunakan terminologi sesuai referensi

### Tabel Standardisasi yang Disarankan

| Terminologi | Standar yang Disarankan | Format Penggunaan |
|-------------|------------------------|-------------------|
| Kompilator/Compiler | **Kompilator** | Kompilator (Compiler) - pada penggunaan pertama |
| Parser | **Parser** | Parser (tetap Inggris, istilah teknis umum) |
| Lexer | **Lexer** | Lexer (tetap Inggris, istilah teknis umum) |
| Lexical Analysis | **Analisis Leksikal** | Analisis Leksikal (Lexical Analysis) - pada penggunaan pertama |
| Syntax Analysis | **Analisis Sintaksis** | Analisis Sintaksis (Syntax Analysis) - pada penggunaan pertama |
| Semantic Analysis | **Analisis Semantik** | Analisis Semantik (Semantic Analysis) - pada penggunaan pertama |
| Optimasi/Optimization | **Optimasi** | Optimasi (Optimization) - pada penggunaan pertama |
| Interpreter | **Interpreter** | Interpreter (tetap Inggris, istilah teknis umum) |
| Code Generation | **Generasi Kode** | Generasi Kode (Code Generation) - pada penggunaan pertama |
| IR | **IR** atau **Representasi Intermediate** | IR (Intermediate Representation) atau Representasi Intermediate (IR) |

### Catatan Khusus

1. **Bab 20 (Tutorial)**: Boleh tetap menggunakan terminologi Inggris karena konteks tutorial praktis dengan kode
2. **Diagram dan Gambar**: Boleh menggunakan terminologi Inggris untuk konsistensi visual
3. **Kutipan dari Referensi**: Gunakan terminologi sesuai referensi asli

---

## Statistik per Bab

### Bab dengan Inkonsistensi Terbanyak

| Bab | Judul | Inkonsistensi Ditemukan | Keterangan |
|-----|-------|-------------------------|------------|
| Bab 1 | Pengenalan Kompilator | 3 | Kompilator vs Compiler, Analisis Leksikal vs Lexical Analysis, Analisis Sintaksis vs Syntax Analysis |
| Bab 15 | Optimasi Kompilator Dasar | 2 | Optimasi vs Optimization, Kompilator vs Compiler |
| Bab 20 | Tutorial: Membuat Compiler | 4 | Compiler (bukan Kompilator), semua terminologi dalam bahasa Inggris |
| Bab 0 | Prakata | 5 | Semua terminologi fase kompilasi menggunakan bahasa Indonesia |

### Bab dengan Konsistensi Terbaik

| Bab | Judul | Keterangan |
|-----|-------|------------|
| Bab 2 | Regular Expression dan Finite Automata | Konsisten menggunakan terminologi Inggris |
| Bab 5 | Context-Free Grammar | Konsisten menggunakan terminologi Inggris |
| Bab 9 | Abstract Syntax Tree (AST) | Konsisten menggunakan terminologi Inggris |
| Bab 10 | Symbol Table | Konsisten menggunakan terminologi Inggris |
| Bab 11 | Type Checking dan Semantic Analysis | Konsisten menggunakan terminologi Inggris (kecuali judul bab yang mixed) |

### Tingkat Konsistensi per Bab

| Bab | Tingkat Konsistensi | Catatan |
|-----|---------------------|---------|
| Bab 0 | 40% | Prakata menggunakan terminologi Indonesia |
| Bab 1 | 60% | Mixed usage |
| Bab 2-4 | 90% | Konsisten menggunakan terminologi Inggris |
| Bab 5-8 | 85% | Konsisten menggunakan terminologi Inggris |
| Bab 9-11 | 90% | Konsisten menggunakan terminologi Inggris |
| Bab 12-14 | 80% | Mixed usage untuk Code Generation |
| Bab 15 | 70% | Mixed usage untuk Optimasi |
| Bab 16-19 | 75% | Mixed usage |
| Bab 20 | 50% | Tutorial menggunakan terminologi Inggris |

---

## Daftar File yang Perlu Diperbaiki

### Prioritas Tinggi (Inkonsistensi Signifikan)

1. **`chapters/bab-20.tex`**
   - **Masalah**: Judul bab menggunakan "Compiler" bukan "Kompilator"
   - **Jumlah inkonsistensi**: 4+
   - **Rekomendasi**: Ubah judul menjadi "Tutorial: Membuat Kompilator Sederhana" atau tetap "Compiler" dengan catatan bahwa ini tutorial praktis

2. **`chapters/bab-00.tex`**
   - **Masalah**: Prakata menggunakan terminologi Indonesia sementara banyak bab menggunakan terminologi Inggris
   - **Jumlah inkonsistensi**: 5
   - **Rekomendasi**: Standarisasi ke terminologi Indonesia dengan istilah Inggris dalam kurung

3. **`sections/bab-01_sec04.tex`**
   - **Masalah**: Diagram menggunakan "Lexical Analysis", "Syntax Analysis", "Semantic Analysis" (Inggris)
   - **Jumlah inkonsistensi**: 3
   - **Rekomendasi**: Ubah ke terminologi Indonesia atau tambahkan label Indonesia

4. **`sections/bab-01_sec05.tex`**
   - **Masalah**: Subsection menggunakan format campuran "Syntax Analysis (Analisis Sintaksis)"
   - **Jumlah inkonsistensi**: 3
   - **Rekomendasi**: Standarisasi format menjadi "Analisis Sintaksis (Syntax Analysis)"

### Prioritas Sedang

5. **`chapters/bab-15.tex`**
   - **Masalah**: Judul menggunakan "Optimasi Kompilator" tetapi beberapa section menggunakan "Optimization"
   - **Jumlah inkonsistensi**: 2
   - **Rekomendasi**: Standarisasi ke "Optimasi" di seluruh bab

6. **`sections/bab-12_sec02.tex`**
   - **Masalah**: Menggunakan "Intermediate Representation" (Inggris)
   - **Jumlah inkonsistensi**: 1
   - **Rekomendasi**: Ubah ke "Representasi Intermediate" atau tambahkan istilah Indonesia

7. **`README.md`**
   - **Masalah**: Dokumentasi menggunakan terminologi Indonesia sementara banyak bab menggunakan terminologi Inggris
   - **Jumlah inkonsistensi**: 5+
   - **Rekomendasi**: Standarisasi sesuai dengan rekomendasi umum

### Prioritas Rendah (Konsistensi Internal Baik)

8. **`chapters/bab-02.tex`** hingga **`chapters/bab-11.tex`**
   - **Masalah**: Menggunakan terminologi Inggris secara konsisten
   - **Rekomendasi**: Evaluasi apakah perlu diubah ke terminologi Indonesia atau tetap Inggris dengan alasan yang jelas

---

## Matriks Konsistensi Terminologi

| Terminologi | Bab 0 | Bab 1 | Bab 2-4 | Bab 5-8 | Bab 9-11 | Bab 12-14 | Bab 15 | Bab 16-19 | Bab 20 |
|-------------|-------|-------|---------|---------|----------|-----------|--------|-----------|--------|
| Kompilator | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| Parser | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Analisis Leksikal | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Analisis Sintaksis | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Analisis Semantik | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Optimasi | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| Code Generation | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

**Legenda:**
- ✅ = Konsisten dengan standar yang disarankan
- ❌ = Tidak konsisten atau menggunakan variasi lain

---

## Kesimpulan

Berdasarkan pemeriksaan komprehensif terhadap seluruh 21 bab buku ajar "Teknik Kompilasi", ditemukan bahwa:

1. **Terdapat inkonsistensi signifikan** dalam penggunaan terminologi antara bahasa Indonesia dan bahasa Inggris
2. **Bab-bab awal** (Bab 0, Bab 1) cenderung menggunakan terminologi Indonesia
3. **Bab-bab tengah** (Bab 2-14) cenderung menggunakan terminologi Inggris
4. **Bab tutorial** (Bab 20) menggunakan terminologi Inggris secara konsisten
5. **Istilah teknis umum** (parser, lexer, AST, IR) konsisten menggunakan bahasa Inggris

### Rekomendasi Utama

1. **Standarisasi ke terminologi Indonesia** untuk istilah umum dengan penambahan istilah Inggris dalam kurung pada penggunaan pertama
2. **Pertahankan istilah Inggris** untuk istilah teknis yang sudah sangat umum (parser, lexer, AST, IR, CFG)
3. **Konsistensi dengan judul bab**: Setiap bab harus menggunakan terminologi yang konsisten dengan judulnya
4. **Dokumentasi standar**: Buat glosarium terminologi di awal buku untuk referensi pembaca

### Langkah Selanjutnya

1. Review dan persetujuan rekomendasi standardisasi
2. Implementasi perubahan sesuai prioritas
3. Verifikasi konsistensi setelah perubahan
4. Pembuatan glosarium terminologi

---

## Quick Reference Guide untuk Implementasi

### Panduan Cepat: Terminologi yang Harus Diganti

| Cari (Case-Insensitive) | Ganti Dengan | Konteks | Prioritas |
|------------------------|--------------|---------|-----------|
| `\bcompiler\b` | `kompilator` | Teks umum | Tinggi (kecuali bab-20) |
| `Lexical Analysis` | `Analisis Leksikal (Lexical Analysis)` | Penggunaan pertama | Tinggi |
| `lexical analysis` | `analisis leksikal` | Teks umum | Tinggi |
| `Syntax Analysis` | `Analisis Sintaksis (Syntax Analysis)` | Penggunaan pertama | Tinggi |
| `syntax analysis` | `analisis sintaksis` | Teks umum | Tinggi |
| `Semantic Analysis` | `Analisis Semantik (Semantic Analysis)` | Penggunaan pertama | Tinggi |
| `semantic analysis` | `analisis semantik` | Teks umum | Tinggi |
| `Optimization` | `Optimasi (Optimization)` | Penggunaan pertama | Sedang |
| `optimization` | `optimasi` | Teks umum | Sedang |
| `Code Generation` | `Generasi Kode (Code Generation)` | Penggunaan pertama | Sedang |
| `code generation` | `generasi kode` | Teks umum | Sedang |
| `Intermediate Representation` | `Representasi Intermediate (IR)` | Penggunaan pertama | Rendah |
| `intermediate representation` | `representasi intermediate` | Teks umum | Rendah |

**Catatan**: 
- Gunakan word boundary (`\b`) untuk exact match
- Pada penggunaan pertama di setiap bab, tambahkan istilah Inggris dalam kurung
- Parser, Lexer, AST, IR sebagai komponen teknis boleh tetap Inggris

---

## Contoh Perbaikan Konkret

### Contoh 1: Judul Bab

**File**: `chapters/bab-20.tex`

**Before:**
```latex
\chapter{Tutorial: Membuat Compiler Sederhana untuk Bahasa C}
```

**After (Opsi A - Standar Indonesia):**
```latex
\chapter{Tutorial: Membuat Kompilator Sederhana untuk Bahasa C}
```

**After (Opsi B - Tetap Inggris dengan Catatan):**
```latex
\chapter{Tutorial: Membuat Compiler Sederhana untuk Bahasa C}
% Catatan: Bab tutorial menggunakan terminologi Inggris untuk konsistensi dengan kode
```

### Contoh 2: Subsection dengan Format Campuran

**File**: `sections/bab-01_sec05.tex`

**Before:**
```latex
\subsection{Fase 2: Syntax Analysis (Analisis Sintaksis)}
```

**After:**
```latex
\subsection{Fase 2: Analisis Sintaksis (Syntax Analysis)}
```

### Contoh 3: Teks dalam Paragraf

**File**: `sections/bab-01_sec04.tex`

**Before:**
```latex
Front-end bertanggung jawab untuk menganalisis source code. Lexical Analysis memecah 
input menjadi token-token. Syntax Analysis memverifikasi struktur grammar. 
Semantic Analysis memeriksa aturan semantik.
```

**After:**
```latex
Front-end bertanggung jawab untuk menganalisis source code. Analisis Leksikal 
(Lexical Analysis) memecah input menjadi token-token. Analisis Sintaksis 
(Syntax Analysis) memverifikasi struktur grammar. Analisis Semantik (Semantic 
Analysis) memeriksa aturan semantik.
```

### Contoh 4: Diagram Labels

**File**: `sections/bab-01_sec04.tex`

**Before:**
```latex
\node[box, below=of frontend] (lexical) {Lexical Analysis};
\node[box, below=of lexical] (syntax) {Syntax Analysis};
\node[box, below=of syntax] (semantic) {Semantic Analysis};
```

**After (Opsi A - Label Indonesia):**
```latex
\node[box, below=of frontend] (lexical) {Analisis Leksikal};
\node[box, below=of lexical] (syntax) {Analisis Sintaksis};
\node[box, below=of syntax] (semantic) {Analisis Semantik};
```

**After (Opsi B - Tetap Inggris dengan Caption Indonesia):**
```latex
\node[box, below=of frontend] (lexical) {Lexical Analysis};
\node[box, below=of lexical] (syntax) {Syntax Analysis};
\node[box, below=of syntax] (semantic) {Semantic Analysis};
% ...
\caption{Arsitektur kompilator: Analisis Leksikal, Analisis Sintaksis, Analisis Semantik}
```

---

## Checklist Implementasi

### Prioritas Tinggi

- [ ] **`chapters/bab-20.tex`**
  - [ ] Review dan putuskan: ubah ke "Kompilator" atau tetap "Compiler" dengan catatan
  - [ ] Update semua kemunculan "compiler" di section bab-20 jika diperlukan
  - [ ] Estimasi: 30 menit

- [ ] **`chapters/bab-00.tex`**
  - [ ] Standarisasi terminologi fase kompilasi ke format Indonesia (Inggris dalam kurung)
  - [ ] Estimasi: 15 menit

- [ ] **`sections/bab-01_sec04.tex`**
  - [ ] Update label diagram atau caption
  - [ ] Estimasi: 45 menit

- [ ] **`sections/bab-01_sec05.tex`**
  - [ ] Standarisasi format subsection menjadi "Analisis Sintaksis (Syntax Analysis)"
  - [ ] Estimasi: 20 menit

### Prioritas Sedang

- [ ] **`chapters/bab-15.tex`**
  - [ ] Review semua section untuk konsistensi "Optimasi"
  - [ ] Estimasi: 30 menit

- [ ] **`sections/bab-12_sec02.tex`**
  - [ ] Update "Intermediate Representation" ke "Representasi Intermediate (IR)"
  - [ ] Estimasi: 15 menit

- [ ] **`README.md`**
  - [ ] Standarisasi terminologi sesuai rekomendasi
  - [ ] Estimasi: 20 menit

### Prioritas Rendah

- [ ] **Review bab-bab dengan terminologi Inggris konsisten**
  - [ ] Evaluasi apakah perlu diubah atau tetap dengan alasan jelas
  - [ ] Estimasi: 2-3 jam

---

## Strategi Implementasi Bertahap

### Fase 1: Standarisasi Judul Bab (Minggu 1)
**Tujuan**: Konsistensi entry point pembaca

**Tugas**:
- Review semua 21 judul bab
- Standarisasi sesuai rekomendasi
- **Deliverable**: Daftar judul bab yang sudah distandarisasi

**Estimasi**: 2-3 jam

### Fase 2: Standarisasi Bab Awal (Minggu 2)
**Tujuan**: Konsistensi kesan pertama pembaca

**Tugas**:
- Standarisasi `bab-00.tex` (Prakata)
- Standarisasi `bab-01.tex` (Pengenalan)
- **Deliverable**: Bab 0 dan 1 dengan terminologi konsisten

**Estimasi**: 3-4 jam

### Fase 3: Standarisasi Diagram dan Visual (Minggu 3)
**Tujuan**: Konsistensi visual

**Tugas**:
- Update label diagram di semua section
- Update caption gambar
- **Deliverable**: Semua diagram dengan terminologi konsisten

**Estimasi**: 4-5 jam

### Fase 4: Standarisasi Konten Section (Minggu 4-6)
**Tujuan**: Konsistensi keseluruhan

**Tugas**:
- Standarisasi terminologi di semua section secara sistematis
- Fokus pada prioritas tinggi dan sedang terlebih dahulu
- **Deliverable**: Semua section dengan terminologi konsisten

**Estimasi**: 10-15 jam

### Fase 5: Verifikasi dan QA (Minggu 7)
**Tujuan**: Memastikan konsistensi

**Tugas**:
- Re-run grep untuk verifikasi
- Manual review sample files
- **Deliverable**: Laporan verifikasi konsistensi

**Estimasi**: 3-4 jam

**Total Estimasi**: 22-31 jam kerja (sekitar 3-4 minggu kerja penuh)

---

## Tools dan Scripts untuk Implementasi

### Script Find & Replace

**Mencari semua kemunculan terminologi:**

```bash
# Mencari "compiler" (case-insensitive)
grep -r -i "\bcompiler\b" chapters/ sections/ --include="*.tex" | wc -l

# Mencari "Lexical Analysis"
grep -r "Lexical Analysis" sections/ --include="*.tex"

# Mencari "Syntax Analysis"
grep -r "Syntax Analysis" sections/ --include="*.tex"

# Mencari "Semantic Analysis"
grep -r "Semantic Analysis" sections/ --include="*.tex"

# Mencari "Optimization"
grep -r -i "\boptimization\b" sections/ --include="*.tex"

# Mencari "Code Generation"
grep -r "Code Generation" sections/ --include="*.tex"
```

### Regex Patterns untuk Find & Replace

**Catatan**: Gunakan dengan hati-hati dan selalu backup file terlebih dahulu!

| Pattern | Replacement | Konteks |
|---------|-------------|---------|
| `\bcompiler\b` | `kompilator` | Word boundary untuk exact match |
| `\bCompiler\b` | `Kompilator` | Capitalized version |
| `Lexical Analysis` | `Analisis Leksikal (Lexical Analysis)` | Hanya pada penggunaan pertama per bab |
| `Syntax Analysis` | `Analisis Sintaksis (Syntax Analysis)` | Hanya pada penggunaan pertama per bab |
| `Semantic Analysis` | `Analisis Semantik (Semantic Analysis)` | Hanya pada penggunaan pertama per bab |

**Peringatan**: 
- Lakukan find & replace secara manual untuk memastikan konteks benar
- Jangan gunakan replace all tanpa verifikasi
- Backup semua file sebelum melakukan perubahan besar

---

## FAQ (Frequently Asked Questions)

**Q: Apakah semua terminologi harus diubah ke bahasa Indonesia?**  
A: Tidak. Istilah teknis yang sudah sangat umum (parser, lexer, AST, IR, CFG) boleh tetap menggunakan bahasa Inggris karena sudah menjadi istilah standar dalam komunitas teknis.

**Q: Bagaimana dengan kutipan dari referensi berbahasa Inggris?**  
A: Kutipan tetap menggunakan terminologi sesuai referensi asli. Tidak perlu diubah untuk menjaga integritas kutipan.

**Q: Apakah diagram harus diubah juga?**  
A: Diagram boleh tetap menggunakan terminologi Inggris untuk konsistensi visual, atau ditambahkan label bahasa Indonesia. Yang penting adalah caption atau penjelasan menggunakan terminologi yang konsisten.

**Q: Bagaimana dengan bab tutorial (Bab 20)?**  
A: Bab tutorial boleh tetap menggunakan terminologi Inggris karena konteks praktis dengan kode. Namun, jika ingin konsisten, bisa diubah dengan menambahkan catatan bahwa ini tutorial praktis.

**Q: Kapan harus menambahkan istilah Inggris dalam kurung?**  
A: Pada penggunaan pertama di setiap bab atau section. Setelah itu, cukup gunakan istilah Indonesia saja.

**Q: Bagaimana dengan judul bab yang sudah menggunakan terminologi Inggris?**  
A: Evaluasi case-by-case. Jika judul sudah menjadi istilah teknis standar (seperti "Code Generation"), boleh tetap Inggris. Jika bisa diterjemahkan dengan baik (seperti "Compiler" → "Kompilator"), sebaiknya diubah.

**Q: Apakah perlu membuat glosarium?**  
A: Sangat disarankan! Glosarium di awal buku akan membantu pembaca memahami terminologi yang digunakan dan meningkatkan konsistensi.

---

## Metrik Kuantitatif Detail

### Distribusi Penggunaan Terminologi

| Terminologi | Total | Indonesia | Inggris | Campuran | % Indonesia | % Inggris |
|-------------|-------|-----------|---------|----------|-------------|-----------|
| Kompilator/Compiler | ~200 | ~150 | ~50 | 0 | 75% | 25% |
| Analisis Leksikal | ~400 | ~50 | ~300 | ~50 | 12.5% | 75% |
| Analisis Sintaksis | ~240 | ~30 | ~200 | ~10 | 12.5% | 83% |
| Analisis Semantik | ~80 | ~15 | ~60 | ~5 | 18.75% | 75% |
| Optimasi | ~220 | ~180 | ~40 | 0 | 82% | 18% |
| Code Generation | ~120 | ~20 | ~100 | 0 | 16.7% | 83% |
| IR | ~115 | ~10 | ~100 | ~5 | 8.7% | 87% |

**Interpretasi**:
- **Kompilator**: Sudah cukup konsisten menggunakan Indonesia (75%)
- **Analisis Leksikal/Sintaksis/Semantik**: Dominan menggunakan Inggris (75-83%), perlu standarisasi
- **Optimasi**: Sudah cukup konsisten menggunakan Indonesia (82%)
- **Code Generation**: Dominan menggunakan Inggris (83%), perlu standarisasi
- **IR**: Dominan menggunakan Inggris (87%), tetapi ini acceptable karena istilah teknis umum

---

## Timeline Implementasi

| Fase | Durasi Estimasi | Deliverable | Dependencies |
|------|-----------------|-------------|--------------|
| **Fase 0: Review & Approval** | 1 minggu | Rekomendasi disetujui | - |
| **Fase 1: Judul Bab** | 3-4 jam | Semua judul bab konsisten | Fase 0 |
| **Fase 2: Bab Awal** | 3-4 jam | Bab 0 dan 1 konsisten | Fase 1 |
| **Fase 3: Diagram** | 4-5 jam | Semua diagram konsisten | Fase 2 |
| **Fase 4: Section Prioritas Tinggi** | 2-3 jam | File prioritas tinggi selesai | Fase 3 |
| **Fase 5: Section Prioritas Sedang** | 3-4 jam | File prioritas sedang selesai | Fase 4 |
| **Fase 6: Section Prioritas Rendah** | 8-10 jam | Semua section konsisten | Fase 5 |
| **Fase 7: Verifikasi** | 3-4 jam | Laporan verifikasi | Fase 6 |
| **Total** | **6-8 minggu** | **Buku dengan terminologi konsisten** | - |

**Catatan**: Timeline ini mengasumsikan kerja part-time (4-6 jam per minggu). Jika kerja full-time, bisa diselesaikan dalam 1-2 minggu.

---

### 1. Penambahan Quick Reference Guide

**Rekomendasi**: Tambahkan bagian "Quick Reference Guide" di awal dokumen untuk memudahkan implementasi standardisasi.

**Contoh struktur yang disarankan:**

```markdown
## Quick Reference Guide

### Terminologi yang Harus Diganti

| Cari | Ganti Dengan | Catatan |
|------|--------------|---------|
| compiler | kompilator | Kecuali di bab-20 (tutorial) |
| Lexical Analysis | Analisis Leksikal (Lexical Analysis) | Pada penggunaan pertama |
| Syntax Analysis | Analisis Sintaksis (Syntax Analysis) | Pada penggunaan pertama |
| Semantic Analysis | Analisis Semantik (Semantic Analysis) | Pada penggunaan pertama |
| Optimization | Optimasi (Optimization) | Pada penggunaan pertama |
| Code Generation | Generasi Kode (Code Generation) | Pada penggunaan pertama |
| Intermediate Representation | Representasi Intermediate (IR) | Pada penggunaan pertama |
```

### 2. Penambahan Contoh Perbaikan Konkret

**Rekomendasi**: Tambahkan bagian "Contoh Perbaikan" yang menunjukkan before/after untuk setiap terminologi.

**Contoh yang disarankan:**

```markdown
## Contoh Perbaikan

### Contoh 1: Kompilator vs Compiler

**Before:**
```latex
\chapter{Tutorial: Membuat Compiler Sederhana}
Compiler sederhana yang telah kita buat...
```

**After:**
```latex
\chapter{Tutorial: Membuat Kompilator Sederhana}
Kompilator (Compiler) sederhana yang telah kita buat...
```

### Contoh 2: Analisis Leksikal

**Before:**
```latex
Fase pertama adalah Lexical Analysis yang memecah source code...
```

**After:**
```latex
Fase pertama adalah Analisis Leksikal (Lexical Analysis) yang memecah source code...
Setelah Analisis Leksikal selesai, fase berikutnya adalah...
```
```

### 3. Penambahan Estimasi Effort

**Rekomendasi**: Tambahkan kolom estimasi waktu/effort untuk setiap file yang perlu diperbaiki.

**Contoh:**

| File | Prioritas | Estimasi Waktu | Kompleksitas |
|------|-----------|----------------|--------------|
| `chapters/bab-20.tex` | Tinggi | 30 menit | Sedang |
| `chapters/bab-00.tex` | Tinggi | 15 menit | Rendah |
| `sections/bab-01_sec04.tex` | Tinggi | 45 menit | Tinggi (diagram) |

### 4. Penambahan Checklist Implementasi

**Rekomendasi**: Tambahkan checklist untuk memudahkan tracking implementasi.

**Contoh:**

```markdown
## Checklist Implementasi

### Prioritas Tinggi
- [ ] `chapters/bab-20.tex` - Ubah judul dan terminologi
- [ ] `chapters/bab-00.tex` - Standarisasi terminologi
- [ ] `sections/bab-01_sec04.tex` - Update diagram labels
- [ ] `sections/bab-01_sec05.tex` - Standarisasi format subsection

### Prioritas Sedang
- [ ] `chapters/bab-15.tex` - Standarisasi "Optimasi"
- [ ] `sections/bab-12_sec02.tex` - Update terminologi IR
- [ ] `README.md` - Update dokumentasi
```

### 5. Penambahan Metrik Kuantitatif

**Rekomendasi**: Tambahkan metrik yang lebih detail untuk setiap terminologi.

**Contoh:**

| Terminologi | Total Kemunculan | Indonesia | Inggris | Campuran | % Konsistensi |
|-------------|------------------|-----------|---------|----------|---------------|
| Kompilator | 200+ | 150 | 50 | 0 | 75% |
| Analisis Leksikal | 400+ | 50 | 300 | 50 | 12.5% |

### 6. Penambahan Bagian "Strategi Implementasi"

**Rekomendasi**: Tambahkan bagian yang menjelaskan strategi implementasi bertahap.

**Contoh:**

```markdown
## Strategi Implementasi

### Fase 1: Standarisasi Judul Bab (Prioritas Tertinggi)
- Fokus pada konsistensi judul bab terlebih dahulu
- Estimasi: 1-2 jam
- Impact: Tinggi (judul adalah entry point pembaca)

### Fase 2: Standarisasi Konten Bab 0-1 (Prioritas Tinggi)
- Standarisasi prakata dan bab pengenalan
- Estimasi: 2-3 jam
- Impact: Tinggi (bab awal menentukan kesan pertama)

### Fase 3: Standarisasi Diagram dan Gambar (Prioritas Sedang)
- Update label diagram untuk konsistensi
- Estimasi: 3-4 jam
- Impact: Sedang (visual penting tetapi tidak kritis)

### Fase 4: Standarisasi Konten Section (Prioritas Rendah)
- Standarisasi terminologi di seluruh section
- Estimasi: 8-10 jam
- Impact: Sedang-Tinggi (meningkatkan konsistensi keseluruhan)
```

### 7. Perbaikan Format Tabel

**Rekomendasi**: Beberapa tabel perlu formatting yang lebih baik untuk readability.

**Perbaikan yang disarankan:**
- Tambahkan alignment yang konsisten
- Gunakan markdown table yang lebih rapi
- Tambahkan border atau separator untuk tabel panjang

### 8. Penambahan Bagian "FAQ" atau "Pertanyaan Umum"

**Rekomendasi**: Tambahkan bagian FAQ untuk menjawab pertanyaan yang mungkin muncul.

**Contoh:**

```markdown
## FAQ (Frequently Asked Questions)

**Q: Apakah semua terminologi harus diubah ke bahasa Indonesia?**
A: Tidak. Istilah teknis yang sudah sangat umum (parser, lexer, AST, IR) boleh tetap menggunakan bahasa Inggris.

**Q: Bagaimana dengan kutipan dari referensi berbahasa Inggris?**
A: Kutipan tetap menggunakan terminologi sesuai referensi asli. Tidak perlu diubah.

**Q: Apakah diagram harus diubah juga?**
A: Diagram boleh tetap menggunakan terminologi Inggris untuk konsistensi visual, atau ditambahkan label bahasa Indonesia.

**Q: Bagaimana dengan bab tutorial (Bab 20)?**
A: Bab tutorial boleh tetap menggunakan terminologi Inggris karena konteks praktis dengan kode.
```

### 9. Penambahan Bagian "Timeline Implementasi"

**Rekomendasi**: Tambahkan estimasi timeline untuk implementasi lengkap.

**Contoh:**

```markdown
## Timeline Implementasi

| Fase | Durasi Estimasi | Deliverable |
|------|-----------------|-------------|
| Fase 1: Review dan Approval | 1 minggu | Rekomendasi disetujui |
| Fase 2: Implementasi Prioritas Tinggi | 1 minggu | Bab 0, 1, 20 diperbaiki |
| Fase 3: Implementasi Prioritas Sedang | 2 minggu | Bab 15, section-section kunci diperbaiki |
| Fase 4: Implementasi Prioritas Rendah | 2-3 minggu | Semua section diperbaiki |
| Fase 5: Verifikasi dan QA | 1 minggu | Konsistensi diverifikasi |
| **Total** | **6-8 minggu** | **Buku dengan terminologi konsisten** |
```

### 10. Penambahan Bagian "Tools dan Scripts"

**Rekomendasi**: Tambahkan bagian yang menjelaskan tools atau scripts yang bisa digunakan untuk membantu implementasi.

**Contoh:**

```markdown
## Tools dan Scripts untuk Implementasi

### Script Find & Replace

Untuk membantu implementasi, bisa menggunakan script berikut:

```bash
# Contoh: Mencari semua kemunculan "compiler" (case-insensitive)
grep -r -i "compiler" chapters/ sections/ --include="*.tex"

# Contoh: Mencari "Lexical Analysis"
grep -r "Lexical Analysis" sections/ --include="*.tex"
```

### Regex Patterns untuk Find & Replace

| Pattern | Replacement | Catatan |
|---------|-------------|---------|
| `\bcompiler\b` | `kompilator` | Word boundary untuk exact match |
| `Lexical Analysis` | `Analisis Leksikal (Lexical Analysis)` | Hanya pada penggunaan pertama |
```

---

---

## Ringkasan Rekomendasi untuk Implementasi

### Prioritas Aksi Segera

1. **Standarisasi Judul Bab** (2-3 jam)
   - Fokus pada konsistensi entry point
   - Khususnya bab-20 yang menggunakan "Compiler"

2. **Standarisasi Bab Awal** (3-4 jam)
   - Bab-00 (Prakata) dan Bab-01 (Pengenalan)
   - Memberikan kesan pertama yang konsisten

3. **Standarisasi Diagram** (4-5 jam)
   - Update label dan caption diagram
   - Khususnya di `bab-01_sec04.tex`

### Metodologi Implementasi

1. **Gunakan Quick Reference Guide** (bagian di atas) untuk find & replace
2. **Ikuti Contoh Perbaikan Konkret** untuk format yang benar
3. **Gunakan Checklist Implementasi** untuk tracking progress
4. **Ikuti Strategi Implementasi Bertahap** untuk pendekatan sistematis

### Tools yang Tersedia

- Script grep untuk mencari terminologi
- Regex patterns untuk find & replace
- Checklist untuk tracking
- Timeline untuk planning

### Hasil yang Diharapkan

Setelah implementasi lengkap:
- **Konsistensi terminologi**: 95%+
- **Pembaca tidak bingung** dengan variasi terminologi
- **Buku lebih profesional** dan mudah dibaca
- **Glosarium** tersedia untuk referensi

---

**Catatan**: Laporan ini dibuat berdasarkan analisis sistematis menggunakan grep dan analisis manual. Untuk verifikasi yang lebih menyeluruh, disarankan untuk melakukan review manual terhadap setiap file yang disebutkan dalam daftar file yang perlu diperbaiki.
