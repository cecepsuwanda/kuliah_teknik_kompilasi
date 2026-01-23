# Buku Ajar Teknik Kompilasi

Buku ajar ini disusun berdasarkan silabus resmi mata kuliah **Teknik Kompilasi** untuk Program Studi S1 Teknik Informatika dengan pendekatan **Outcome-Based Education (OBE)**.

## Struktur Buku

Buku ini menggunakan struktur modular dengan file LaTeX terpisah untuk setiap bab:

```
book_2/
├── main.tex                    # File utama buku (menggabungkan semua bab)
├── references.bib              # File bibliografi
├── compile-all.bat             # Script menu compile buku/bab
├── compile.bat                 # Script untuk compile silabus
├── preamble.tex                # Konfigurasi LaTeX terpusat
├── preamble-book.tex           # Konfigurasi khusus book
├── preamble-article.tex        # Konfigurasi khusus article
├── chapters/                   # Folder berisi file-file bab
│   ├── bab-01.tex             # Bab 1: Pengenalan Kompilator (untuk main.tex)
│   ├── bab-01-standalone.tex  # Bab 1 standalone (dapat dikompilasi terpisah)
│   └── bab-01-content.tex     # Konten Bab 1 (tidak digunakan langsung)
└── README.md                   # File ini
```

## Cara Kompilasi

### Kompilasi Buku Lengkap

Untuk mengompilasi seluruh buku menjadi PDF:

```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

Atau gunakan batch file menu:
```bash
compile-all.bat
```

### Kompilasi Bab Secara Terpisah

Untuk mengompilasi hanya satu bab (contoh: Bab 1):

```bash
cd chapters
pdflatex bab-01-standalone.tex
bibtex bab-01-standalone
pdflatex bab-01-standalone.tex
pdflatex bab-01-standalone.tex
```

Atau gunakan batch file menu:
```bash
compile-all.bat
```

### Kompilasi Bab Lainnya

Setiap bab dapat dikompilasi secara terpisah menggunakan file `bab-XX-standalone.tex` di folder `chapters/`. Proses kompilasi sama seperti Bab 1.

### Kompilasi Silabus

Silabus terpisah berada di `silabus-teknik-kompilasi.tex` dan dapat dikompilasi lewat:
```bash
compile.bat
```

## Bab-bab Buku

- File bab tersedia untuk **bab-01 s.d. bab-16** di folder `chapters/`.
- Status konten bervariasi (sebagian masih draft), silakan cek file bab terkait.

## Menambahkan Bab Baru

Untuk menambahkan bab baru:

1. Buat file `bab-XX.tex` di folder `chapters/` dengan struktur:
   ```latex
   \chapter{Judul Bab}
   \label{chap:label}
   
   % Konten bab
   ```

2. Buat file `bab-XX-standalone.tex` untuk kompilasi terpisah (copy dari `bab-01-standalone.tex` dan sesuaikan)

3. Tambahkan `\input{chapters/bab-XX}` di `main.tex` setelah `\input{chapters/bab-01}`

## Referensi

Buku ini menggunakan referensi dari:
- Buku teks standar (Dragon Book, Engineering a Compiler, dll.)
- Course materials dari berbagai universitas (UC San Diego, Northeastern, Johns Hopkins, dll.)
- Open educational resources yang dapat diverifikasi online

Semua referensi tercatat dalam file `references.bib` menggunakan format BibTeX.

## Lisensi dan Hak Cipta

Buku ajar ini dibuat untuk keperluan pendidikan di Program Studi S1 Teknik Informatika. Semua referensi digunakan sesuai dengan fair use untuk keperluan pendidikan.

## Catatan Penting

- Setiap bab menggunakan kutipan langsung dari sumber yang dapat diverifikasi
- Semua URL referensi disertakan untuk transparansi akademik
- Buku ini fokus pada praktik implementasi menggunakan C/C++
- Setiap bab dilengkapi dengan latihan yang sesuai dengan CPMK
