# Betterimp Framework (betterimp-fw)

Betterimp Framework adalah perkakas pengembangan ringan yang dirancang untuk mengoptimalkan kinerja AI coding agent dengan penghematan token maksimal dan pencegahan bug secara mandiri.

Framework ini menyatukan:
1. **DOX Framework (`AGENTS.md`):** Mengunci aturan gaya koding dan kontrol mutu tanpa testing playwright yang berat.
2. **cargo-mcp:** Memaksa AI memverifikasi tipe data dan kompilasi Rust secara instan.
3. **rtk (Rust Token Killer):** Memotong token output terminal dari perintah shell yang dijalankan.
4. **codebase-memory-mcp & sequential-thinking:** GPS navigasi semantik instan dan penganalisa logika sekuensial bertahap untuk mencegah bug koding.
5. **Arugoflow & Dokumentasi Akurat:** Menjaga keandalan dokumen PRD proyek agar sinkron dengan kode riil, serta memaksa AI memakai **Context7** dan **Web Search** demi akurasi API.
6. **Harmonisasi Caveman & Ponytail:** AI koding diprogram untuk menulis kode paling sederhana (YAGNI/Ponytail) dan menjelaskan secara sangat padat dan ringkas dalam Bahasa Indonesia (Caveman style).

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

Cukup masuk ke folder proyek Anda (misalnya di terminal), lalu jalankan script `configure.sh` dari framework:

```sh
sh ~/NewRust/betterimp-fw/configure.sh
```

Script ini akan otomatis:
1. Menyalin `AGENTS.md` terintegrasi ke root proyek Anda.
2. Membuat tautan kompatibilitas `.cursorrules`, `.clinerules`, dan `CLAUDE.md` agar dibaca otomatis oleh VS Code, Cursor, Cline, dan Roo Code.
3. Menghubungkan skill `caveman`, `ponytail`, dan `ponytail-audit` secara global ke direktori `~/.agents/skills` dan `~/.roo/skills`.
4. Mengunduh dan menginstal **rtk** dan **codebase-memory-mcp** secara otomatis langsung dari repositori aslinya jika belum terinstal.
5. Mengonfigurasi server MCP **codebase-memory-mcp** dan **sequential-thinking** secara otomatis pada **Antigravity**, **Cline**, dan **Roo Code** (termasuk VSCodium).
6. Menampilkan log proses instalasi dengan warna terminal (ANSI Styling) yang interaktif dan informatif.
