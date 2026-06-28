---
name: arugoflow
description: Generates or updates product requirement documents (PRD) and high-level specifications that accurately reflect the ACTUAL source code implementation. Uses descriptive, user-friendly human language without code snippets or technical jargon. Always reads and analyzes the real codebase before writing.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, WebSearch
---

# Skill: Arugoflow

> "Merumuskan dan memperbarui dokumen spesifikasi produk dengan bahasa manusia yang deskriptif, fungsional, dan bebas dari jargon teknis pemrograman."

## Deskripsi Umum

Skill **arugoflow** digunakan untuk menulis, memperbarui, atau membuat dokumen persyaratan produk (seperti `PRD.md`) berdasarkan kondisi nyata dari proyek dan riwayat percakapan. Skill ini memandu agen untuk menerjemahkan perubahan kode tingkat rendah (low-level code changes) menjadi penjelasan fitur tingkat tinggi (high-level feature description) yang berfokus pada pengalaman pengguna (user experience) dan perilaku fungsional produk.

Jika pengguna meminta panduan kerja AI agent, aturan anti-regression, atau dokumen perilaku agent, buat atau perbarui `developer_guide.md` jika file tersebut ada di workspace; jika belum ada, buat `developer_guide.md` sebagai dokumen utama yang berisi hal yang boleh dan tidak boleh dilakukan untuk mencegah regression.

## Prinsip Utama Penulisan

Saat skill ini aktif, patuhi aturan penulisan berikut:

- **Code-First Analysis**: SEBELUM menulis PRD, AI WAJIB membaca & menganalisis source code proyek secara langsung. PRD harus berdasarkan kode yang TERTULIS, bukan spekulasi atau rencana.
- **Actual State Documentation**: PRD mendokumentasikan keadaan KODE SAAT INI (what the code DOES), bukan spesifikasi ideal (what it SHOULD do). Ini adalah "as-built documentation", bukan "requirements specification".
- **Auto-Update on Code Change**: Setiap kali ada perubahan pada source code yang signifikan, AI harus memperbarui PRD yang terdampak. PRD yang tidak sinkron dengan kode adalah bug.
- **Honest Scope**: Bedakan dengan jelas antara: (a) sudah diimplementasikan, (b) sedang dalam pengembangan, (c) masih rencana. Jangan menulis fitur yang belum ada kodenya seolah-olah sudah jadi.

### 1. Gunakan Bahasa Manusia Deskriptif
* **HINDARI** penulisan detail teknis spesifik seperti:
  * Kelas utility CSS/Tailwind (misal: `mr-4`, `font-bold`, `text-[0.75rem]`).
  * Nama variabel, nama fungsi, nama signal, closure, atau tipe data (misal: `filename_signal`, `select()`, `HtmlInputElement`).
  * Rincian arsitektur kode internal Rust/Leptos.
* **GUNAKAN** penjelasan perilaku visual dan fungsional yang berpusat pada pengguna (user-centric):
  * *Contoh Teknis:* "Menggeser bingkai list antrean ke kiri dengan margin kanan `mr-4` agar scrollbar tidak menimpa teks."
  * *Contoh Arugoflow (Dianjurkan):* "Menggeser bingkai antrean merapat ke kiri, memberikan ruang kosong di sebelah kanannya agar scrollbar terlihat bersih dan tidak tumpang tindih dengan teks."

### 2. Berorientasi pada Pengalaman Pengguna (User Experience)
* Jelaskan *mengapa* perubahan tersebut penting bagi pengguna dan *bagaimana* mereka berinteraksi dengannya.
* Deskripsikan detail visual menggunakan metafora desain umum (seperti "gaya kaca transparan", "bercahaya halus", "efek tumpukan lembaran bertumpuk").

### 3. Konsistensi Struktur Dokumen
* Selaraskan gaya penulisan dengan gaya dokumen PRD yang sudah ada.
* Gunakan daftar poin terstruktur (bullet points) yang ringkas dan padat informasi untuk memudahkan pemindaian cepat (skimmability).

### 4. Keselarasan Realitas Kode dengan PRD (Realism & Alignment)
* Pastikan narasi di PRD, About, FAQ, dan Landing Page selaras dengan arah tujuan akhir produk dan batasan teknis nyata.
* Hindari menulis klaim fungsionalitas fiktif yang tidak didukung atau direncanakan oleh arsitektur asli produk (seperti mengklaim penggunaan FFmpeg WASM jika produk dirancang murni berbasis WebCodecs/Web Audio API).
* Selalu bedakan antara fungsionalitas prototipe saat ini, fitur terencana, dan fungsionalitas penuh untuk mencegah *overclaiming*.

### 5. Referensi Kode dalam PRD

- PRD harus menyertakan referensi ke file/source code yang relevan (path file) agar pembaca bisa verifikasi sendiri.
- Setiap klaim fitur harus bisa dilacak ke implementasi di kode.

---

## Langkah Kerja Skill

Ikuti alur kerja berikut untuk memperbarui dokumen spesifikasi:

### Langkah 1: Analisis Perubahan Proyek
1. Periksa riwayat git commit terbaru untuk melihat daftar fitur yang baru saja ditambahkan atau diperbaiki.
2. Bandingkan berkas kode utama dengan versi sebelumnya untuk mengidentifikasi perubahan perilaku aplikasi.
3. Baca ringkasan percakapan terbaru untuk memahami keluhan pengguna dan arah perbaikan yang diinginkan.

### Langkah 2: Terjemahkan Perubahan Menjadi Fungsional
Petakan temuan teknis menjadi penjelasan tingkat tinggi. Contoh pemetaan:
* *Temuan Teknis:* Penambahan event `on:focus` dan `on:click` dengan metode `.set_selection_range(start, end)` untuk mendeteksi indeks pemisah titik dua `:`.
* *Terjemahan Fungsional:* Fitur pemilihan otomatis per bagian waktu (Jam, Menit, atau Detik) secara cerdas ketika pengguna mengklik area tersebut, memudahkan penyuntingan cepat tanpa menghapus keseluruhan teks.

### Langkah 3: Tulis / Perbarui Dokumen
1. Cari lokasi yang sesuai di dalam file target (misalnya di bawah bagian `Implemented UI/UX Enhancements` pada `PRD.md`).
2. Masukkan poin-poin deskriptif hasil terjemahan fungsional.
3. Pastikan tidak ada karakter kode atau sintaks pemrograman yang ikut tertulis.

### Langkah 4: Verifikasi Hasil Penulisan
Baca kembali teks yang baru saja ditulis. Tanyakan pada diri sendiri:
* *"Apakah teks ini bisa dipahami dengan jelas oleh seorang Product Manager atau pengguna biasa tanpa latar belakang pemrograman Rust?"*
* Jika jawabannya **Ya**, maka dokumen telah siap disajikan.

---

## Contoh Pola Penulisan

| Fitur Teknis | Gaya Penulisan Arugoflow (Benar ✅) | Gaya Penulisan Teknis (Salah ❌) |
|---|---|---|
| **Styling Switcher** | Switcher menggunakan gaya kaca transparan dengan bingkai bercahaya warna biru-cyan tipis di atas latar belakang sangat gelap. | Switcher ditambahkan kelas `bg-accent-cyan/10 border-accent-cyan/30 text-accent-cyan` dengan kontainer `bg-[#090d16]/80`. |
| **Pencegahan Re-render** | Mengisolasi pembaruan data berkas secara halus sehingga posisi scroll antrean tetap stabil dan tidak melompat kembali ke atas saat berkas dipilih. | Memisahkan reactivity menggunakan closure `filename_signal` dan `filesize_mb_signal` untuk menghindari full page re-render di Leptos. |
| **Progress Bar Multi-file** | Menampilkan bilah progres kemajuan keseluruhan secara terpisah dari kemajuan berkas tunggal yang sedang aktif agar status konversi lebih informatif. | Menambahkan progress bar kedua dengan style `bg-[#00ff7f]` untuk berkas aktif dan gradasi cyan untuk overall progress. |

---

## Codebase Sync Workflow

1. Scan struktur proyek — baca file manifest (package.json, Cargo.toml, pyproject.toml, dll), identifikasi stack.
2. Baca source code di direktori utama (src/, app/, lib/, dll).
3. Identifikasi komponen, fungsi, alur data dari kode — bukan dari dokumentasi yang mungkin usang.
4. Generate PRD yang mendeskripsikan implementasi aktual.
5. Simpan PRD sebagai file dokumentasi (PRD.md, docs/prd.md, dll).
6. Setiap sesi AI baru: cek dulu apakah kode berubah sejak PRD terakhir dibuat.
   - Jika ya: update PRD.
   - Jika tidak: PRD masih valid.
