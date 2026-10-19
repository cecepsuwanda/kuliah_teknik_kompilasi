# Buku Ajar Teknik Kompilasi

Buku ajar LaTeX berbasis Outcome-Based Education (OBE) untuk mata kuliah
**Teknik Kompilasi** (MWCA017), Program Studi Teknik Informatika,
Fakultas Teknologi Informasi, Universitas Bale Bandung.

## Status

- 17 bab lengkap (Bab I--XVII) dan 4 lampiran.
- Total 290 halaman pada build terakhir.
- Seluruh 19 Sub-CPMK tercakup dan terpetakan.
- Semua 17 bab dapat dikompilasi mandiri.
- 20 entri bibliografi, tanpa referensi atau sitasi yang belum terdefinisi.
- Proyek mini-compiler Subset-C tersedia di `code/subsetc` (M0--M5).
- Kode C/Flex/Bison ditinjau statis; lingkungan penyusunan tidak memiliki
  GCC, Flex, dan Bison. Jalankan build kode pada lingkungan yang lengkap.

## Prasyarat

- MiKTeX atau TeX Live dengan `pdflatex` dan `bibtex`.
- Tidak memerlukan `latexmk`, `make`, atau Perl.
- Tidak memerlukan aset gambar eksternal: semua diagram dibuat dengan TikZ/forest.

## Struktur

```text
main.tex            dokumen induk
preamble.tex        pemuat konfigurasi
metadata.tex        identitas buku
references.bib      basis data bibliografi
config/             paket, gaya, perintah, lingkungan, listings, tikz
frontmatter/        halaman judul, hak cipta, kata pengantar, capaian
chapters/NN/        bab modular (chapter.tex + section + komponen OBE)
appendices/         rubrik, contoh tugas, glosarium, referensi tambahan
code/               proyek mini-compiler Subset-C dan alat bantu Python
scripts/            skrip build dan pemeriksaan
build/              keluaran build
```

## Membangun Buku

```bat
scripts\build-all.bat
```

Empat lintasan: `pdflatex` -> `bibtex` -> `pdflatex` -> `pdflatex`.
Hasil akhir: `main.pdf` (salinan dari `build\main.pdf`).

## Membangun Satu Bab

```bat
scripts\build-chapter.bat 07
scripts\build-chapter.bat 07 /bib
```

Bab dapat dikompilasi mandiri karena memakai
`\documentclass[../../main.tex]{subfiles}`. Referensi lintas bab yang
belum ditulis akan tampil sebagai `??`; ini normal untuk build mandiri.

## Pemeriksaan

```bat
scripts\check-log.bat
powershell -ExecutionPolicy Bypass -File scripts\check-coverage.ps1
powershell -ExecutionPolicy Bypass -File scripts\check-code-paths.ps1
```

## Aturan Penulisan

1. Konfigurasi LaTeX hanya di `config/`; bab tidak boleh memuat `\usepackage`.
2. Setiap bab harus dapat dikompilasi mandiri.
3. Gunakan `\subfile` untuk section dan `\input` untuk komponen kecil.
4. Semua label memakai awalan: `chap:`, `sec:`, `fig:`, `tab:`, `eq:`, `lst:`.
5. Sumber ditulis ASCII; simbol memakai perintah LaTeX.
6. Setiap bab inti memuat urutan OBE yang sama (lihat `PANDUAN.md`).

## Lisensi

Materi buku ini disusun untuk keperluan pembelajaran. Rujukan eksternal
memiliki lisensi masing-masing; lihat `references.bib` dan Lampiran D.
