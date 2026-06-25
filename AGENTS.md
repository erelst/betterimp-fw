# DOX Framework - Betterimp Framework (betterimp-fw)

- Purpose: Global AI-assisted development framework combining DOX, cargo-mcp, rtk, codebase-memory-mcp, "ponytail skill dari path global skills", and "caveman skill dari path global skills".
- Ownership: Centralized, anti-regression, high-efficiency development standard.

## Purpose

`betterimp-fw` is a streamlined, high-performance global framework designed to maximize token savings, prevent code regressions, and enforce pragmatic engineering. It integrates:
1. **DOX Framework:** Hierarchical folder-based rules (`AGENTS.md`) acting as binding contracts.
2. **Tooling & MCPs:** `cargo-mcp` (compilation), `rtk` (token reduction for commands), and `codebase-memory-mcp` (semantic navigation).
3. **Optimized Behaviors:** Sinergi antara "ponytail skill dari path global skills" (kode minimalis/YAGNI) dan "caveman skill dari path global skills" (komunikasi sangat padat) dalam Bahasa Indonesia sederhana.

## Local Contracts

- **Code simplicity ("ponytail skill dari path global skills"):** Selalu bangun solusi paling minimal yang berfungsi. Pertanyakan fitur spekulatif. Pustaka standar didahulukan, fitur bawaan platform berikutnya, dependensi yang sudah ada ketiga. Tanpa boilerplate.
- **Communication style ("caveman skill dari path global skills" + Beterimp):** Hapus kata pengisi, artikel, basa-basi, dan hedging. Jelaskan konsep teknis secara sederhana, sangat singkat, dan langsung dalam fragmen Bahasa Indonesia. Kode didahulukan, penjelasan belakangan.
- **Synergy:** "ponytail skill dari path global skills" menentukan *kode apa yang ditulis* (kode paling sederhana); "caveman skill dari path global skills" menentukan *bagaimana penjelasan ditulis* (prosa paling singkat). Keduanya tidak pernah bertentangan.
- **Global Skills:** Seluruh modul skill yang terpasang di direktori global (`~/.agents/skills/` dan `~/.roo/skills/`) bersifat mengikat. AI wajib mendeteksi dan mematuhi instruksi dalam berkas `SKILL.md` pada masing-masing direktori skill tersebut (seperti "caveman skill dari path global skills", "ponytail skill dari path global skills", dll.) tanpa terkecuali.

## Technical Integration & Tools

1. **cargo-mcp:** AI must run `cargo check` and `cargo clippy` via MCP tools after every Rust edit to guarantee type safety and zero warnings.
2. **rtk (Rust Token Killer):** All developer command outputs must pass through `rtk` to compress token usage before being processed by the AI.
3. **codebase-memory-mcp:** AI must query the semantic codebase graph for symbol definitions and call chains to navigate the codebase with sub-millisecond latency.
4. **sequential-thinking:** AI must leverage this server to break down reasoning steps, explore alternative solutions, and validate assumptions in complex, multi-step code refactoring.
5. **server-memory mcp:** AI must leverage this server to store long-term facts, developer preferences, and design style cross-session, maintaining dynamic personalization.
6. **Global Audit Skills:** AI wajib menggunakan skill audit koding dari path global skills untuk memindai pembengkakan kode (code bloat), kode mati (dead code), dan abstraksi spekulatif, mengurutkan temuan berdasarkan baris kode yang dapat dipangkas demi menjaga efisiensi koding.

## Beterimp Protocol (Core Rules)

1. **Bahasa Indonesia Sederhana & Jelas ("caveman skill dari path global skills" style):** Komunikasi wajib menggunakan Bahasa Indonesia yang sangat singkat, padat, dan langsung pada intinya. Hindari basa-basi.
2. **Wawancara Detail & Spesifikasi Teknis:** Sebelum melakukan perubahan penting, wajib bertanya/wawancara singkat untuk mengidentifikasi tujuan utama proyek. Utamakan spesifikasi teknis detail (seperti alokasi memori, format data, kompatibilitas browser).
3. **Konfirmasi Keputusan Penting:** Selalu meminta konfirmasi tegas dari pengguna sebelum melakukan tindakan yang mengubah arsitektur utama atau destruktif.
4. **Kriteria Evaluasi Kualitas:** Setiap penyelesaian tugas harus melalui verifikasi mandiri yang ketat (compilation, linter) sebelum dilaporkan kepada pengguna.
5. **Arugoflow (Sinkronisasi PRD):** AI wajib menjaga sinkronisasi antara implementasi kode nyata dengan dokumen spesifikasi/PRD. Jika terjadi perubahan fitur, alur UX, desain UI, atau kapabilitas teknis, AI wajib memperbarui berkas PRD (atau berkas apapun yang namanya mengandung kata "prd") agar mencerminkan kondisi nyata proyek.
6. **Akurasi Informasi (Context7 & Web Search):** AI dilarang menebak atau berasumsi tentang API, versi, atau fitur library eksternal. Wajib memprioritaskan pemanggilan tool **Context7** (untuk dokumentasi library) atau **web_search** (jika library tidak terdaftar) guna mengambil informasi terakurat sebelum menulis kode.
7. **Sequential Thinking (Berpikir Sekuensial):** Sebelum menyelesaikan tugas kompleks, AI wajib mengaktifkan server **sequential-thinking** untuk menganalisis hipotesis, langkah kerja, dan validasi secara bertahap demi meminimalisir kesalahan logika koding.

# DOX framework

- DOX is highly performant AGENTS.md hierarchy installed here
- Agent must follow DOX instructions across any edits

## Core Contract

- AGENTS.md files are binding work contracts for their subtrees
- Work products, source materials, instructions, records, assets, and durable docs must stay understandable from the nearest applicable AGENTS.md plus every parent AGENTS.md above it

## Read Before Editing

1. Read the root AGENTS.md
2. Identify every file or folder you expect to touch
3. Walk from the repository root to each target path
4. Read every AGENTS.md found along each route
5. If a parent AGENTS.md lists a child AGENTS.md whose scope contains the path, read that child and continue from there
6. Use the nearest AGENTS.md as the local contract and parent docs for repo-wide rules
7. If docs conflict, the closer doc controls local work details, but no child doc may weaken DOX

Do not rely on memory. Re-read the applicable DOX chain in the current session before editing.

## Update After Editing

Every meaningful change requires a DOX pass before the task is done.

Update the closest owning AGENTS.md when a change affects:

- purpose, scope, ownership, or responsibilities
- durable structure, contracts, workflows, or operating rules
- required inputs, outputs, permissions, constraints, side effects, or artifacts
- user preferences about behavior, communication, process, organization, or quality
- AGENTS.md creation, deletion, move, rename, or index contents

Update parent docs when parent-level structure, ownership, workflow, or child index changes. Update child docs when parent changes alter local rules. Remove stale or contradictory text immediately. Small edits that do not change behavior or contracts may leave docs unchanged, but the DOX pass still must happen.

## Hierarchy

- Root AGENTS.md is the DOX rail: project-wide instructions, global preferences, durable workflow rules, and the top-level Child DOX Index
- Child AGENTS.md files own domain-specific instructions and their own Child DOX Index
- Each parent explains what its direct children cover and what stays owned by the parent
- The closer a doc is to the work, the more specific and practical it must be

## Child Doc Shape

- Create a child AGENTS.md when a folder becomes a durable boundary with its own purpose, rules, responsibilities, workflow, materials, or quality standards
- Work Guidance must reflect the current standards of the project or user instructions; if there are no specific standards or instructions yet, leave it empty
- Verification must reflect an existing check; if no verification framework exists yet, leave it empty and update it when one exists

Default section order:
- Purpose
- Ownership
- Local Contracts
- Work Guidance
- Verification
- Child DOX Index

## Style

- Keep docs concise, current, and operational
- Document stable contracts, not diary entries
- Put broad rules in parent docs and concrete details in child docs
- Prefer direct bullets with explicit names
- Do not duplicate rules across many files unless each scope needs a local version
- Delete stale notes instead of explaining history
- Trim obvious statements, repeated rules, misplaced detail, and warnings for risks that no longer exist

## Closeout

1. Re-check changed paths against the DOX chain
2. Update nearest owning docs and any affected parents or children
3. Refresh every affected Child DOX Index
4. Remove stale or contradictory text
5. Run existing verification when relevant
6. Report any docs intentionally left unchanged and why

## User Preferences

When the user requests a durable behavior change, record it here or in the relevant child AGENTS.md

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
