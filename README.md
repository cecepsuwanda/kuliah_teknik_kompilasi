## Buku Ajar Teknik Kompilasi — Universitas Bale Bandung

Repositori ini berisi sumber LaTeX untuk Buku Ajar mata kuliah Teknik Kompilasi pada Program Studi Teknik Informatika, Fakultas Teknologi Informasi, Universitas Bale Bandung. Struktur bab mengikuti RPS pada `rps1.tex`, dengan tiap bab ditulis di berkas `.tex` terpisah dan dapat dikompilasi sebagai satu buku utuh maupun per-bab.

### Struktur Proyek

- `book/`
  - `main.tex`: Dokumen utama buku (menggunakan kelas `book`).
  - `Makefile`: Skrip build untuk kompilasi buku penuh dan per-bab (prioritas `latexmk`, fallback `pdflatex`+`bibtex`).
  - `references.bib`: Daftar pustaka (open-access: Mogensen, Wirth, LLVM, GCC, Flex, Bison, ANTLR, dan rujukan CC-BY-SA seperti Wikipedia untuk topik formal).
  - `chapters/`
    - `00-praface.tex`: Prakata (opsional; saat ini tidak di-include).
    - `01-pendahuluan.tex`: Pendahuluan.
    - `02-analisis-lexikal.tex`: Analisis Leksikal.
    - `03-analisis-sintaksis.tex`: Analisis Sintaksis.
    - `04-analisis-semantik.tex`: Analisis Semantik.
    - `05-syntesis.tex`: Sintesis (IR, optimisasi, pembangkitan kode).
- `rps1.tex`: Rujukan struktur materi (RPS) yang diikuti oleh buku.
- `LICENSE`: Lisensi repositori (GPL-3.0).
- `Makefile` (root): Makefile lama yang tidak digunakan; gunakan Makefile di dalam `book/`.

### Fitur Utama

- Kompilasi buku penuh dan per-bab (menggunakan paket `subfiles`).
- Daftar pustaka global dengan `natbib` + `bibtex` (gaya `plainnat`).
- Saat kompilasi per-bab, setiap bab menyertakan bibliografi kondisional agar referensi tetap tampil.
- Daftar gambar dan tabel otomatis (`\listoffigures`, `\listoftables`).
- Ilustrasi didukung: diagram pipeline (TikZ), parse tree (`forest`), dan tabel komparatif (`booktabs`).

### Prasyarat

Instal TeX Live dan alat pendukung. Cara termudah adalah memasang paket lengkap:

```bash
sudo apt-get update && sudo apt-get install -y texlive-full latexmk
```

Atau instal paket minimal berikut (Ubuntu/Debian):

```bash
sudo apt-get install -y \
  latexmk pdflatex texlive-base texlive-latex-recommended texlive-latex-extra \
  texlive-fonts-recommended texlive-lang-other texlive-pictures texlive-forest
```

Catatan paket LaTeX yang digunakan:
- Bahasa/umum: `babel` (indonesian), `fontenc`, `inputenc`, `lmodern`, `geometry`, `setspace`, `enumitem`
- Matematika/gambar: `amsmath`, `amssymb`, `graphicx`, `tikz` (`pgf`), `forest`
- Tabel dan layout: `booktabs`, `caption`, `subcaption`
- Sitasi: `natbib`
- Modularisasi: `subfiles`

### Cara Build

1) Build buku penuh (PDF):

```bash
cd book
make book
# atau, bila tersedia
latexmk -pdf main.tex
```

Hasil: `book/main.pdf`.

2) Build per-bab:

```bash
cd book
make chapters
# atau bangun bab tertentu:
latexmk -pdf chapters/02-analisis-lexikal.tex
```

3) Bersih-bersih artefak build:

```bash
cd book
make clean
```

### Overleaf

Unggah folder `book/` ke Overleaf dan set dokumen utama ke `main.tex`. Semua bab berada di `chapters/` dan dikelola melalui paket `subfiles`.

### Menambah/Modifikasi Konten

- Tambah bab: buat berkas baru di `book/chapters/`, lalu tambahkan `\subfile{chapters/<nama-bab>}` ke `book/main.tex` pada bagian “Chapters”.
- Sumber: tambahkan entri BibTeX ke `book/references.bib`. Gunakan `\citep{key}` atau `\citet{key}` (paket `natbib`).
- Gambar/tabel: gunakan TikZ (`tikzpicture`) atau paket `forest` untuk parse tree; untuk tabel gunakan `booktabs`.

### Catatan Penting

- Struktur bab mengikuti `rps1.tex` (RPS). Bab-bab telah dilengkapi konten 2–4 paragraf per bagian, bahasa akademik, serta sitasi sumber terbuka.
- Beberapa rujukan berasal dari Wikipedia (CC-BY-SA). Konten buku mengutipnya dengan benar; lisensi tetap milik sumber masing-masing.
- Makefile di root bersifat legacy dan tidak dipakai; gunakan `book/Makefile`.

### Lisensi

Kode proyek dalam repositori ini dilisensikan di bawah GPL-3.0 (lihat `LICENSE`). Materi kutipan dan tautan pihak ketiga tunduk pada lisensi sumber aslinya (mis. CC-BY-SA untuk Wikipedia, lisensi dokumentasi resmi untuk LLVM/GCC, dsb.).

