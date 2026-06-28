# AGENTS.md — skills/

## Purpose

Mendefinisikan skill-skill yang tersedia untuk AI agent di proyek betterimp-fw. Setiap skill adalah instruksi khusus yang bisa dimuat sesuai kebutuhan.

## Ownership

Direktori ini dimiliki oleh root AGENTS.md. Setiap subdirektori `skills/<name>/` memiliki satu file [`SKILL.md`](SKILL.md) yang mendefinisikan aturan skill tersebut.

## Local Contracts

Semua aturan root AGENTS.md berlaku penuh. Skill-specific rules ada di masing-masing [`SKILL.md`](SKILL.md):
- [`caveman/SKILL.md`](caveman/SKILL.md) — komunikasi ultra-padat (caveman mode)
- [`ponytail/SKILL.md`](ponytail/SKILL.md) — kode minimalis YAGNI-first
- [`arugoflow/SKILL.md`](arugoflow/SKILL.md) — PRD & spesifikasi non-teknis
- [`ponytail-audit/SKILL.md`](ponytail-audit/SKILL.md) — audit over-engineering repo-wide

## Work Guidance

- Skill hanya dimuat saat deskripsi/trigger-nya cocok dengan task
- SKILL.md tidak diupdate tanpa perubahan pada skill itu sendiri
- Jika menambah skill baru, update file ini dan root AGENTS.md Child DOX Index

## Sync & Auto-Update

- `scripts/sync-skills.sh` — sync skill files between project and global dirs
  - `pull`: global → project (default, jalankan di awal sesi AI)
  - `push`: project → global (setelah edit skill lokal)
  - `both`: bidirectional sync
- Setelah perubahan codebase signifikan, AI harus menjalankan arugoflow skill untuk update PRD/docs

## Verification

Tidak ada verification khusus untuk file skill. Verification mengikuti root AGENTS.md.

## Child DOX Index

| Path | Scope |
|------|-------|
| `caveman/SKILL.md` | Komunikasi sangat padat, 4 intensity levels |
| `ponytail/SKILL.md` | YAGNI-first code, 7 rung ladder, 3 intensity levels |
| `arugoflow/SKILL.md` | PRD & dokumentasi non-teknis, Bahasa Indonesia |
| `ponytail-audit/SKILL.md` | Over-engineering scan, one-shot report |
