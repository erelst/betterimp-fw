# AGENTS.md

Framework: betterimp-fw — DOX hierarchy + Caveman + Ponytail + Arugoflow + tooling MCP.
Purpose: token savings maksimal, anti-regresi, kode minimalis.

## Core Contract

- AGENTS.md files are binding work contracts for their subtrees
- Work products, instructions, records, and assets must stay understandable from the nearest AGENTS.md plus every parent AGENTS.md above it

## Read Before Editing

1. Read this root AGENTS.md
2. Identify every file/folder you expect to touch
3. Walk from repository root to each target path
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
- required inputs, outputs, permissions, constraints, or side effects
- user preferences about behavior, communication, process, organization, or quality
- AGENTS.md creation, deletion, move, rename, or index contents

Update parent docs when parent-level structure, ownership, workflow, or child index changes. Update child docs when parent changes alter local rules. Remove stale or contradictory text immediately.

## Hierarchy

- Root AGENTS.md: project-wide instructions, global preferences, durable workflow rules, and top-level Child DOX Index
- `skills/AGENTS.md` owns domain-specific instructions for skill files and its own Child DOX Index
- The closer a doc is to the work, the more specific and practical it must be

## Local Contracts

- **Ponytail** ([`skills/ponytail/SKILL.md`](skills/ponytail/SKILL.md)): kode minimal first (YAGNI > stdlib > native > existing deps > one line)
- **Caveman** ([`skills/caveman/SKILL.md`](skills/caveman/SKILL.md)): komunikasi sangat padat (drop filler/artikel/hedging), prosa Bahasa Indonesia singkat
- **Arugoflow** ([`skills/arugoflow/SKILL.md`](skills/arugoflow/SKILL.md)): PRD/docs bebas jargon teknis, deskripsi UX fungsional, jangan overclaim

## Tooling

- **rtk**: semua command developer WAJIB lewat rtk (token compression 60-90%)
- **codebase-memory-mcp**: cari symbol definitions via semantic graph
- **sequential-thinking**: gunakan untuk tugas kompleks multi-step
- **server-memory**: simpan preferensi lintas sesi
- **Context7 / web_search**: akurasi API/library — jangan asumsi

Jika salah satu MCP tidak tersedia: lanjutkan dengan fallback manual langsung.

## Verification (Generalisasi)

Sesuaikan dengan ekosistem proyek:
- Rust: `cargo check`, `cargo clippy`
- Python: `ruff check`, `mypy .`
- JS/TS: `tsc --noEmit`, `eslint .`
- Go: `go vet ./...`
- Lainnya: compiler/linter standar ekosistem

WAJIB: audit YAGNI mandiri. Tidak ada kode spekulatif/dead code.

## Pre-Completion Checklist

SEBELUM `attempt_completion`, AI HARUS verifikasi:
- [ ] rtk digunakan untuk semua command developer?
- [ ] State & Constraints di [`STATE.md`](STATE.md) sudah dicek untuk constraints aktif?
- [ ] DOX chain lengkap dibaca untuk path target?
- [ ] Verification (compiler/linter) jalan tanpa error?
- [ ] Tidak ada kode spekulatif / YAGNI violation?
- [ ] Output komunikasi padat (Caveman style)?

## User Preferences

(Isi saat user meminta perubahan durable pada behavior/komunikasi/flow.)

## Child DOX Index

| Path | Scope | Type |
|------|-------|------|
| [`skills/`](skills/) | Skill definitions — Ponytail, Caveman, Arugoflow, Ponytail-audit | 📂 Directory with [`AGENTS.md`](skills/AGENTS.md) |
| [`.githooks/`](.githooks/) | Git hooks — AI compliance enforcement | 📂 Git hooks |
| [`scripts/`](scripts/) | AI environment validation & sync scripts | 📂 Utility scripts |
| [`.roo/rules-code/`](.roo/rules-code/) | Code mode specific rules | 📂 Mode rules |
| [`.roo/rules-debug/`](.roo/rules-debug/) | Debug mode specific rules | 📂 Mode rules |
| [`.roo/rules-architect/`](.roo/rules-architect/) | Architect mode specific rules | 📂 Mode rules |
| [`.roo/rules-ask/`](.roo/rules-ask/) | Ask mode specific rules | 📂 Mode rules |
| [`.github/workflows/`](.github/workflows/) | CI/CD compliance workflow | 📂 GitHub Actions |
| [`.github/copilot-instructions.md`](.github/copilot-instructions.md) | Copilot rules (symlink → AGENTS.md) | 🔗 Symlink |
| [`.vscode/`](.vscode/) | VSCode tasks & settings | 📂 Editor config |
| [`.cursorrules`](.cursorrules) | Cursor rules (symlink → AGENTS.md) | 🔗 Symlink |
| [`CLAUDE.md`](CLAUDE.md) | Claude Code rules (symlink → AGENTS.md) | 🔗 Symlink |
| [`.clinerules`](.clinerules) | Cline/Roo rules (symlink → AGENTS.md) | 🔗 Symlink |
| [`STATE.md`](STATE.md) | Anti-regresi state & constraints | 📄 Project state |
| [`COMPLIANCE_FIX.md`](COMPLIANCE_FIX.md) | Strategi & rekomendasi kepatuhan AI | 📄 Strategic doc |
