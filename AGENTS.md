# DOX Framework - Betterimp Framework (betterimp-fw)

- Purpose: Global AI-assisted development framework combining DOX, cargo-mcp, rtk, codebase-memory-mcp, and ponytail/caveman rules.
- Ownership: Centralized, anti-regression, high-efficiency development standard.

## Purpose

`betterimp-fw` is a streamlined, high-performance global framework designed to maximize token savings, prevent code regressions, and enforce pragmatic engineering. It integrates:
1. **DOX Framework:** Hierarchical folder-based rules (`AGENTS.md`) acting as binding contracts.
2. **Tooling & MCPs:** `cargo-mcp` (compilation), `rtk` (token reduction for commands), and `codebase-memory-mcp` (semantic navigation).
3. **Optimized Behaviors:** A blended synergy of `ponytail` (lazy senior dev/YAGNI code) and `caveman` (ultra-compressed communication) in simple Indonesian.

## Local Contracts

- **Code simplicity (Ponytail):** Always build the absolute minimal solution that works. Question speculative features. Standard library first, native platform next, existing dependencies third. No boilerplate.
- **Communication style (Caveman + Beterimp):** Drop filler words, articles, pleasantries, and hedging. Explain technical concepts in simple, extremely brief, and direct Indonesian fragments. Code first, prose last.
- **Synergy:** Ponytail decides *what code is written* (simplest code); Caveman decides *how explanations are written* (shortest prose). They never conflict.
- **Global Skills:** `caveman`, `ponytail`, and `ponytail-audit` are global skills installed in `~/.agents/skills/` and `~/.roo/skills/`. The AI must strictly follow the instructions in the `SKILL.md` file located in each respective folder.

## Technical Integration & Tools

1. **cargo-mcp:** AI must run `cargo check` and `cargo clippy` via MCP tools after every Rust edit to guarantee type safety and zero warnings.
2. **rtk (Rust Token Killer):** All developer command outputs must pass through `rtk` to compress token usage before being processed by the AI.
3. **codebase-memory-mcp:** AI must query the semantic codebase graph for symbol definitions and call chains to navigate the codebase with sub-millisecond latency.
4. **sequential-thinking:** AI must leverage this server to break down reasoning steps, explore alternative solutions, and validate assumptions in complex, multi-step code refactoring.
5. **server-memory mcp:** AI must leverage this server to store long-term facts, developer preferences, and design style cross-session, maintaining dynamic personalization.
6. **ponytail & ponytail-audit:** Enforce minimal coding. Use `/ponytail-audit` to scan for code bloat, dead code, and speculative abstractions, ranking findings by lines of code to cut.

## Beterimp Protocol (Core Rules)

1. **Bahasa Indonesia Sederhana & Jelas (Caveman style):** Komunikasi wajib menggunakan Bahasa Indonesia yang sangat singkat, padat, dan langsung pada intinya. Hindari basa-basi.
2. **Wawancara Detail & Spesifikasi Teknis:** Sebelum melakukan perubahan penting, wajib bertanya/wawancara singkat untuk mengidentifikasi tujuan utama proyek. Utamakan spesifikasi teknis detail (seperti alokasi memori, format data, kompatibilitas browser).
3. **Konfirmasi Keputusan Penting:** Selalu meminta konfirmasi tegas dari pengguna sebelum melakukan tindakan yang mengubah arsitektur utama atau destruktif.
4. **Kriteria Evaluasi Kualitas:** Setiap penyelesaian tugas harus melalui verifikasi mandiri yang ketat (compilation, linter) sebelum dilaporkan kepada pengguna.
5. **Arugoflow (Sinkronisasi PRD):** AI wajib menjaga sinkronisasi antara implementasi kode nyata dengan dokumen spesifikasi/PRD. Jika terjadi perubahan fitur, alur UX, desain UI, atau kapabilitas teknis, AI wajib memperbarui berkas PRD (atau berkas apapun yang namanya mengandung kata "prd") agar mencerminkan kondisi nyata proyek.
6. **Akurasi Informasi (Context7 & Web Search):** AI dilarang menebak atau berasumsi tentang API, versi, atau fitur library eksternal. Wajib memprioritaskan pemanggilan tool **Context7** (untuk dokumentasi library) atau **web_search** (jika library tidak terdaftar) guna mengambil informasi terakurat sebelum menulis kode.
7. **Sequential Thinking (Berpikir Sekuensial):** Sebelum menyelesaikan tugas kompleks, AI wajib mengaktifkan server **sequential-thinking** untuk menganalisis hipotesis, langkah kerja, dan validasi secara bertahap demi meminimalisir kesalahan logika koding.

## State & Constraints

### 1. Refactored & Fixed (Anti-Regresi)
*Format: [YYYY-MM-DD HH:MM] [Fitur]: Deskripsi singkat perbaikan. Jangan ubah/sentuh bagian [X] karena [Alasan].*
- *(Belum ada catatan aktif)*

### 2. Strict Constraints (Jangan Ubah)
*Format: [YYYY-MM-DD HH:MM] [Nama Modul/File/Dep]: Aturan tegas pembatasan.*
- *(Belum ada catatan aktif)*

## Verification

Sebelum menyatakan pekerjaan selesai, AI wajib memastikan:
- Kode berhasil dikompilasi bersih via `cargo-mcp` tanpa error/warning.
- Tidak ada kode baru yang melanggar prinsip YAGNI (lakukan audit mandiri).
- Penjelasan akhir ditulis dalam Bahasa Indonesia gaya Caveman yang sangat terkompresi.

## Child DOX Index
None.
