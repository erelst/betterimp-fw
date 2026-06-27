# Betterimp Framework (betterimp-fw)

Betterimp Framework adalah perkakas pengembangan ringan yang dirancang untuk mengoptimalkan kinerja AI coding agent dengan penghematan token maksimal dan pencegahan bug secara mandiri.

Framework ini menyatukan:
1. **DOX Framework (`AGENTS.md`):** Mengunci aturan gaya koding dan kontrol mutu tanpa testing playwright yang berat.
2. **rtk (Rust Token Killer):** Memotong token output terminal dari perintah shell yang dijalankan (60-90% savings). Implementasi via `rtk hook claude` — semua command otomatis direwrite transparan.
3. **codebase-memory-mcp, sequential-thinking, & server-memory mcp:** GPS navigasi semantik instan, penganalisa logika sekuensial bertahap, dan penyimpan memori fakta jangka panjang lintas sesi.
4. **Arugoflow & Dokumentasi Akurat:** Menjaga keandalan dokumen PRD proyek agar sinkron dengan kode riil, serta memaksa AI memakai **Context7** dan **Web Search** demi akurasi API.
5. **Harmonisasi Caveman & Ponytail:** AI koding diprogram untuk menulis kode paling sederhana (YAGNI/Ponytail) dan menjelaskan secara sangat padat dan ringkas dalam Bahasa Indonesia (Caveman style).

---

## **Struktur Proyek**

```text
betterimp-fw/
├── AGENTS.md        # Aturan global terpadu (DOX + Beterimp + Caveman + Ponytail)
├── configure.sh     # Script POSIX sh untuk instalasi otomatis & penyalinan DOX
├── README.md        # Dokumen panduan ini
└── skills/          # Berisi skill global terpilih
    ├── caveman/
    │   └── SKILL.md
    ├── ponytail/
    │   └── SKILL.md
    └── ponytail-audit/
        └── SKILL.md
```

---

## **Cara Penggunaan**

Masuk ke direktori root proyek Anda di terminal, lalu pilih salah satu metode eksekusi berikut:

### **Metode A: Eksekusi Langsung dari GitHub (Instan & Praktis)**
Gunakan metode ini tanpa perlu mengunduh repositori framework terlebih dahulu:
```sh
curl -fsSL https://raw.githubusercontent.com/erelst/betterimp-fw/main/configure.sh | sh
```
*Atau menggunakan `wget`:*
```sh
wget -qO- https://raw.githubusercontent.com/erelst/betterimp-fw/main/configure.sh | sh
```

### **Metode B: Eksekusi Lokal (Offline / Terklon)**
Gunakan metode ini jika Anda sudah mengkloning folder `betterimp-fw` di komputer Anda:
```sh
sh ~/NewRust/betterimp-fw/configure.sh
```

---

## **Cara Kerja Otomatisasi Script**
Script ini akan mendeteksi lingkungan eksekusi secara cerdas dan melakukan tugas berikut:
1. **Menyalin/Mengunduh `AGENTS.md`:** Menyalin dari lokal (jika ada) atau mengunduh dari GitHub ke root proyek Anda.
2. **Membuat Tautan Kompatibilitas:** Membuat symlink `.cursorrules`, `.clinerules`, dan `CLAUDE.md` ke `AGENTS.md`.
3. **Menginstal Skill Global:** Mengonfigurasi skill `caveman`, `ponytail`, dan `ponytail-audit` ke `~/.agents/skills` dan `~/.roo/skills`.
4. **Menginstal Tools Inti:** Mengunduh dan menginstal **rtk** dan **codebase-memory-mcp** secara otomatis langsung dari repositori aslinya jika belum terinstal.
5. **Mengonfigurasi MCP Server:** Mengonfigurasi server MCP **codebase-memory-mcp**, **sequential-thinking**, dan **server-memory mcp** secara otomatis pada **Antigravity**, **Cline**, dan **Roo Code** (termasuk VSCodium).
6. **Tampilan ANSI:** Log proses dengan pewarnaan terminal interaktif.
