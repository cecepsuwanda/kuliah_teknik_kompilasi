# Buku Ajar Teknik Kompilasi

Buku ajar ini disusun berdasarkan silabus resmi mata kuliah **Teknik Kompilasi** untuk Program Studi S1 Teknik Informatika dengan pendekatan **Outcome-Based Education (OBE)**. Buku ini dirancang untuk memberikan pemahaman dan keterampilan praktis dalam merancang dan mengimplementasikan kompilator untuk bahasa pemrograman menggunakan C/C++.

## 📋 Deskripsi

Buku ajar ini mencakup fase-fase kompilator dari Analisis Leksikal (Lexical Analysis), Analisis Sintaksis (Syntax Analysis), Analisis Semantik (Semantic Analysis), hingga Generasi Kode (Code Generation). Setiap bab dilengkapi dengan contoh praktis menggunakan bahasa pemrograman C atau C++, serta latihan yang mengarah pada pembangunan komponen-komponen kompilator secara bertahap.

## 📚 Struktur Buku

Buku ini menggunakan struktur modular dengan file LaTeX terpisah untuk setiap bab:

```
book_2/
├── main.tex                    # File utama buku (menggabungkan semua bab)
├── preamble.tex                # Konfigurasi terpusat (packages, settings)
├── preamble-book.tex          # Konfigurasi khusus untuk book class
├── preamble-article.tex       # Konfigurasi khusus untuk article class
├── references.bib             # File bibliografi (BibTeX)
├── silabus-teknik-kompilasi.tex  # Silabus mata kuliah
│
├── compile.bat                # Script untuk compile silabus
├── compile-all.bat            # Script compile buku lengkap (main.tex)
├── clean-aux.bat              # Hapus file sampingan kompilasi
│
├── chapters/                  # Folder berisi file bab (subfiles)
│   ├── bab-00.tex            # Prakata
│   ├── bab-01.tex … bab-18.tex # Bab 1–18 (masing-masing bisa dikompilasi sendiri)
│   └── *.pdf                 # Output PDF per bab (hasil kompilasi)
│
└── sections/                  # File section per bab (di-\input dari chapters)
    ├── bab-01_sec01.tex …    # Section untuk Bab 1
    ├── bab-02_sec01.tex …    # Section untuk Bab 2
    └── ...                    # Total 69+ file section
```

## 📖 Daftar Bab

### Bagian Awal
- **Bab 0**: Prakata

### Materi Utama (16 Pertemuan)
- **Bab 1**: Pengenalan Kompilator dan Fase-Fase Kompilasi
- **Bab 2**: Regular Expression dan Finite Automata untuk Analisis Leksikal (Lexical Analysis)
- **Bab 3**: Implementasi Lexer Sederhana (Hand-Written)
- **Bab 4**: Lexer Generator (Flex/re2c) dan Praktikum Lexer
- **Bab 5**: Context-Free Grammar dan Pengenalan Parsing
- **Bab 6**: Top-Down Parsing dan Recursive Descent
- **Bab 7**: Bottom-Up Parsing, LR Parser, dan Parser Generator
- **Bab 8**: Parser Generator (Bison/Yacc) dan Praktikum Parser
- **Bab 9**: Abstract Syntax Tree (AST) dan Struktur Data
- **Bab 10**: Symbol Table dan Scope Management
- **Bab 11**: Type Checking dan Analisis Semantik (Semantic Analysis)
- **Bab 12**: Generasi Kode Intermediate (Intermediate Code Generation)
- **Bab 13**: Runtime Environment dan Memory Management
- **Bab 14**: Generasi Kode (Code Generation) untuk Target Architecture
- **Bab 15**: Optimasi Kompilator Dasar
- **Bab 16**: Project Final Presentation dan Review

### Bagian Tambahan
- **Bab 17**: Kumpulan Latihan
- **Bab 18**: Kumpulan Quiz Pilihan Ganda

## 🛠️ Cara Kompilasi

### Prasyarat

Pastikan Anda telah menginstall:
- **LaTeX Distribution**: TeX Live (Windows), MiKTeX (Windows), atau MacTeX (macOS)
- **BibTeX**: Biasanya sudah termasuk dalam distribusi LaTeX
- **pdflatex**: Compiler LaTeX utama

### Kompilasi Buku Lengkap

Untuk mengompilasi seluruh buku menjadi PDF:

**Menggunakan Batch File (Disarankan):**
```bash
compile-all.bat
```
Pilih opsi **1** (Compile Buku Lengkap).

**Manual (Command Line):**
```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

Output: `main.pdf` (atau `output/main.pdf` jika menggunakan batch file)

### Kompilasi Per-Bab

Setiap bab menggunakan package **subfiles** (`\documentclass[../main.tex]{subfiles}`), sehingga `chapters/bab-XX.tex` dapat dikompilasi sendiri.

**Menggunakan Batch File (Disarankan):**
```bash
compile-all.bat
```
Pilih opsi **2** (Compile Per-Bab), lalu pilih nomor bab (0-18).

**Manual (Command Line):**
Harus dijalankan dari folder **chapters** (agar `../main.tex` dan `../sections/` ditemukan):
```bash
cd chapters
pdflatex bab-01.tex
pdflatex bab-01.tex
```
Ganti `bab-01` dengan `bab-00`, `bab-02`, … sesuai kebutuhan. Output: `chapters/bab-XX.pdf`.

**Catatan:** Saat kompilasi per-bab, daftar pustaka (`\bibliography`) tidak disertakan (hanya ada di `main.tex`). Kutipan (`\cite`) bisa tampil sebagai "?".

### Kompilasi Semua Bab Sekaligus

```bash
compile-all.bat
```
Pilih opsi **3** (Compile Semua Bab). Semua PDF akan tersimpan di folder `output/`.

### Kompilasi Silabus

```bash
compile.bat
```
Atau manual:
```bash
pdflatex silabus-teknik-kompilasi.tex
pdflatex silabus-teknik-kompilasi.tex
```

### Membersihkan File Sampingan

Untuk menghapus file temporary hasil kompilasi (.aux, .log, .toc, dll):
```bash
clean-aux.bat
```

## 📝 Menambahkan Bab Baru

Untuk menambahkan bab baru:

1. **Buat file `bab-XX.tex`** di folder `chapters/` dengan struktur:
   ```latex
   \documentclass[../main.tex]{subfiles}
   \begin{document}
   
   \chapter{Judul Bab}
   \label{chap:label}
   \input{../sections/bab-XX_sec01}
   % ... section lainnya
   
   \end{document}
   ```

2. **Buat file section** di `sections/` (mis. `bab-XX_sec01.tex`, …) dan `\input` dari `bab-XX.tex`.

3. **Tambahkan di `main.tex`**:
   ```latex
   \subfile{chapters/bab-XX}
   \cleardoublepage
   ```
   (setelah bab sebelumnya)

## 🎯 Capaian Pembelajaran Mata Kuliah (CPMK)

Buku ini dirancang untuk mencapai 6 CPMK:

- **CPMK 1**: Pemahaman Konsep Kompilator
- **CPMK 2**: Implementasi Lexer dan Parser
- **CPMK 3**: Analisis Semantik (Semantic Analysis)
- **CPMK 4**: Representasi Kode Intermediate (Intermediate Code Representation) dan Optimasi (Optimization)
- **CPMK 5**: Generasi Kode (Code Generation)
- **CPMK 6**: Evaluasi Alat dan Pendekatan

## 📦 Teknologi yang Digunakan

### LaTeX Packages Utama
- `subfiles`: Kompilasi independen per bab
- `babel`: Dukungan bahasa Indonesia
- `natbib`: Manajemen bibliografi
- `listings`: Syntax highlighting untuk kode
- `tikz`: Diagram dan visualisasi
- `forest`: Parse tree
- `hyperref`: Hyperlink dan navigasi PDF
- `fancyhdr`: Header dan footer
- Dan banyak lagi (lihat `preamble.tex`)

### Format Standar
- **Document Class**: `book` (untuk buku lengkap)
- **Font**: Times New Roman (sesuai standar buku ajar Indonesia)
- **Spacing**: 1.5 (sesuai standar Kementerian Pendidikan Tinggi)
- **Margin**: Sesuai standar buku ajar Indonesia (A4)

## 📚 Referensi

Buku ini menggunakan referensi dari:
- Buku teks standar (Dragon Book, Engineering a Compiler, dll.)
- Course materials dari berbagai universitas (UC San Diego, Northeastern, Johns Hopkins, dll.)
- Open educational resources yang dapat diverifikasi online

Semua referensi tercatat dalam file `references.bib` menggunakan format BibTeX. Total **132 citations** di seluruh buku dengan sumber yang dapat diverifikasi.

## 📊 Statistik Konten

- **Total Bab**: 19 (0-18)
- **Total Section**: 69+ file section
- **Total Gambar**: 241+ figure (menggunakan TikZ)
- **Total Label**: 122+ label (fig: dan tab:)
- **Total Citations**: 132 citations
- **Bahasa Pemrograman**: C/C++

## 🔧 Troubleshooting

### Error: File tidak ditemukan saat kompilasi per-bab
**Solusi**: Pastikan Anda menjalankan `pdflatex` dari folder `chapters/`, bukan dari root.

### Error: Bibliography tidak muncul
**Solusi**: Pastikan menjalankan `bibtex` setelah `pdflatex` pertama, lalu jalankan `pdflatex` dua kali lagi.

### Warning: Overfull hbox
**Solusi**: Ini adalah warning umum LaTeX. File sudah dikonfigurasi untuk mengurangi warning ini. Anda bisa mengabaikannya atau menyesuaikan `\emergencystretch` di `preamble.tex`.

### PDF tidak ter-update setelah edit
**Solusi**: Jalankan `pdflatex` beberapa kali (biasanya 2-3 kali) untuk memastikan semua referensi ter-update.

## 📄 Lisensi dan Hak Cipta

Buku ajar ini dibuat untuk keperluan pendidikan di Program Studi S1 Teknik Informatika. Semua referensi digunakan sesuai dengan fair use untuk keperluan pendidikan.

## 📝 Catatan Penting

- Setiap bab menggunakan kutipan langsung dari sumber yang dapat diverifikasi
- Semua URL referensi disertakan untuk transparansi akademik
- Buku ini fokus pada praktik implementasi menggunakan C/C++
- Setiap bab dilengkapi dengan latihan yang sesuai dengan CPMK
- Format mengikuti standar buku ajar Indonesia (Kementerian Pendidikan Tinggi)

## 🤝 Kontribusi

Jika Anda menemukan kesalahan atau ingin memberikan saran perbaikan, silakan buat issue atau pull request.

## 📧 Kontak

Untuk pertanyaan tentang buku ajar ini, silakan hubungi dosen pengampu mata kuliah Teknik Kompilasi.

---

**Versi**: 1.0  
**Terakhir Diupdate**: 2026  
**Status**: Aktif dalam Pengembangan
