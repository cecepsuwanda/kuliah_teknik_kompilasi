# Buku Ajar Teknik Kompilasi - Universitas Bale Bandung

Repositori ini berisi sumber LaTeX untuk **Buku Ajar mata kuliah Teknik Kompilasi**
(Kode MK: MWCA017) pada Program Studi Teknik Informatika, Fakultas Teknologi
Informasi, Universitas Bale Bandung.

Buku disusun berbasis **Outcome-Based Education (OBE)**: struktur bab mengikuti
RPS/Silabus pada `rps_silabus/`, dan setiap bab inti memuat komponen OBE
(outcome, materi pokok, contoh, praktikum, latihan, asesmen, checklist,
rangkuman, dan evaluasi).

## Identitas Mata Kuliah

- Program Studi    : Teknik Informatika
- Fakultas         : Teknologi Informasi
- Perguruan Tinggi : Universitas Bale Bandung
- Mata Kuliah      : Teknik Kompilasi
- Kode MK          : MWCA017
- Semester         : Ganjil
- Dosen Pengampu   : Cecep Suwanda, S.Si., M.Kom.

## Struktur Proyek

| Folder/Berkas | Keterangan |
|---|---|
| `buku_ajar/` | **Proyek utama buku ajar** (17 bab + 4 lampiran, mini-compiler Subset-C) |
| `buku_ajar/main.tex` | Dokumen induk buku (kelas `book`, bab dimuat via `subfiles`) |
| `buku_ajar/preamble.tex` | Pemuat konfigurasi LaTeX |
| `buku_ajar/metadata.tex` | Identitas buku dan metadata PDF |
| `buku_ajar/references.bib` | Basis data bibliografi |
| `buku_ajar/config/` | Semua paket/gaya/perintah LaTeX terpusat |
| `buku_ajar/frontmatter/` | Cover, copyright, kata pengantar, capaian pembelajaran |
| `buku_ajar/chapters/01-17/` | Bab modular (tiap bab dapat dikompilasi mandiri) |
| `buku_ajar/appendices/` | Rubrik, contoh tugas, glosarium, referensi tambahan |
| `buku_ajar/code/subsetc/` | Proyek mini-compiler Subset-C (C/Flex/Bison) |
| `buku_ajar/scripts/` | Skrip build dan pemeriksaan (build, clean, cek cakupan CPMK) |
| `rps_silabus/` | RPS (`rps1.tex`) dan silabus resmi (`silabus-teknik-kompilasi.tex`) |
| `referensi/` | Sumber referensi yang telah diekstraksi (5 buku) |
| `write_quiz.py`, `write_quiz_1.py` | Alat ekspor soal kuis LaTeX ke Excel (.xlsx) |
| `compile-all.bat` | Build buku utuh dari root |
| `compile-all-bab.bat` | Build semua bab individual dari root |
| `compile.bat` | Build silabus/RPS di `rps_silabus/` |
| `Makefile` (root) | **Legacy, tidak digunakan** |

## Prasyarat

- **MiKTeX** atau **TeX Live** di Windows dengan `pdflatex` dan `bibtex`.
- Tidak memerlukan `latexmk`, `make`, atau Perl.
- Tidak memerlukan aset gambar eksternal: seluruh diagram dibuat dengan
  TikZ/`forest`.
- Untuk kode `buku_ajar/code/subsetc/`: GCC, Flex, dan Bison (opsional;
  hanya jika ingin membangun dan menguji mini-compiler).

## Cara Build

### 1. Buku utuh (dari root)

```bat
compile-all.bat
```

Empat lintasan: `pdflatex` -> `bibtex` -> `pdflatex` -> `pdflatex`.
Hasil disalin ke `output\buku_ajar_full.pdf` dan `buku_ajar\main.pdf`.

### 2. Buku utuh (alternatif, langsung dari proyek)

```bat
buku_ajar\scripts\build-all.bat
```

### 3. Bab individual

```bat
compile-all-bab.bat
```

Berkas `chapter.tex` pada `buku_ajar\chapters\NN\` dikompilasi satu per satu
(lintasan `pdflatex` -> `bibtex` -> `pdflatex` -> `pdflatex`). PDF per bab
hasil ke `output\chapter_NN.pdf`. Untuk build satu bab saja:

```bat
buku_ajar\scripts\build-chapter.bat 05
```

### 4. Silabus/RPS

```bat
compile.bat
```

Hasil: `rps_silabus\silabus-teknik-kompilasi.pdf`.

### 5. Pembersihan artefak build

```bat
buku_ajar\scripts\clean.bat
```

## Pemeriksaan

```bat
buku_ajar\scripts\check-log.bat
powershell -ExecutionPolicy Bypass -File buku_ajar\scripts\check-coverage.ps1
powershell -ExecutionPolicy Bypass -File buku_ajar\scripts\check-code-paths.ps1
```

- `check-coverage.ps1` memastikan seluruh 19 Sub-CPMK terpetakan di
  `outcomebox` tiap bab.
- `check-code-paths.ps1` memverifikasi path sumber kode yang dirujuk bab.

## Aturan Penulisan

1. Konfigurasi LaTeX hanya di `buku_ajar/config/`; bab tidak boleh memuat
   `\usepackage` sendiri.
2. Setiap bab harus dapat dikompilasi mandiri (pakai `subfiles`).
3. Gunakan `\subfile` untuk section dan `\input` untuk komponen kecil.
4. Semua label memakai awalan: `chap:`, `sec:`, `fig:`, `tab:`, `eq:`, `lst:`.
5. Sumber ditulis ASCII; simbol khusus memakai perintah LaTeX.
6. Urutan komponen OBE per bab mengikuti `buku_ajar/PANDUAN.md`.

## Overleaf

Unggah isi folder `buku_ajar/` dan set dokumen utama ke `main.tex`.

## Lisensi

Lisensi repositori mengikuti `LICENSE`. Materi rujukan eksternal memiliki
lisensi masing-masing; rincian ada di `buku_ajar/references.bib` dan
Lampiran D.
