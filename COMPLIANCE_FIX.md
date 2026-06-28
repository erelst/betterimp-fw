# COMPLIANCE_FIX

> Dokumen strategis — mengatasi kepatuhan AI tools terhadap rules framework betterimp-fw.

---

## 1. Diagnosis Akar Masalah

### Context Window Drift
AI tools lupa rules mid-session. Context terisi code/output lain, aturan awal tergeser. Semakin panjang session, semakin tinggi probabilitas pelanggaran. Masalah struktural, bukan disiplin.

### No Enforcement Gate
Rules markdown = **advisory**, bukan **enforcement**. Tidak ada mekanisme yang memblokir aksi non-compliant. AI bisa mengabaikan instruksi kapan saja tanpa konsekuensi. Semua aturan bergantung pada "kesediaan" AI untuk patuh.

### Rule Complexity & Contradiction
Terlalu banyak aturan tumpang tindih:
- `AGENTS.md` (root DOX)
- 3 skill global (`caveman`, `ponytail`, `ponytail-audit`)
- Instruksi DOX framework di system prompt
- Campuran bahasa EN/ID yang tidak konsisten
- Broken references (`STATE.md` belum ada, `Child DOX Index` masih placeholder)

Semakin kompleks rules, semakin sering AI gagal mematuhi semuanya.

### Tool-Specific Differences
Setiap AI tool load rules berbeda:
| Tool | Config File |
|------|-------------|
| Cline | `.clinerules` |
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Codex | System prompt / `codex.json` |

Tanpa symlink kompatibilitas, rules hanya terbaca oleh tool tertentu.

### No Verification Loop
Tidak ada auto-check apakah rules dipatuhi. AI bisa mengklaim "done" tanpa benar-benar menjalankan verification. Tidak ada CI gate, tidak ada git hook, tidak ada script validasi.

---

## 2. Strategi Solusi (Prioritized)

### Tier 1: Structural Enforcement (Paling Efektif)

**Pre-commit hooks** — auto-check sebelum commit:
- `AGENTS.md` updated setelah edit
- Semua command log pakai `rtk` prefix
- File sesuai DOX chain
- `STATE.md` sinkron

Contoh hook `.git/hooks/pre-commit`:
```bash
#!/bin/bash
# Validasi DOX chain integrity
if ! grep -q "## State & Constraints" AGENTS.md; then
  echo "ERROR: AGENTS.md missing State & Constraints section"
  exit 1
fi
```

**Wrapper script** — `ai-run.sh` yang bungkus invocation AI tool dengan `rtk` auto-prefix dan validasi path.

**CI check** — GitHub Actions / gitlab CI yang validasi:
- Semua `AGENTS.md` punya `## Verification` section
- Tidak ada broken references
- File structure sesuai DOX chain

### Tier 2: Simplifikasi Rules (Sangat Efektif)

**Konsolidasi `AGENTS.md`**:
- Kurangi dari ~140 baris ke **<60 baris**
- Hanya essential rules — buang duplikasi dan basa-basi
- Setiap aturan harus **unambiguous** dan **testable**

**Hapus duplikasi** antara `AGENTS.md` dan skill files (`skills/caveman/SKILL.md`, `skills/ponytail/SKILL.md`). Cukup satu source of truth.

**Fix broken references**:
- Buat `STATE.md` (referenced di `AGENTS.md`)
- Isi `Child DOX Index` dengan index nyata

**Konsistensi bahasa**:
- **Rules**: Bahasa Inggris (presisi teknis)
- **Output komunikasi**: Bahasa Indonesia (caveman style)
- Tidak boleh campur dalam satu dokumen

### Tier 3: Tool-Specific Config (Efektif)

Pastikan symlink kompatibilitas semua point ke `AGENTS.md`:
```bash
ln -s ../AGENTS.md .clinerules
ln -s ../AGENTS.md CLAUDE.md
ln -s ../AGENTS.md .cursorrules
ln -s ../AGENTS.md .github/copilot-instructions.md
```

Untuk **Codex**: pastikan `AGENTS.md` diload via system prompt atau config Codex.

### Tier 4: Self-Check Protocol (Moderat)

Embed mandatory checklist di akhir `AGENTS.md`:

```markdown
## Pre-Completion Checklist

Before attempt_completion, AI MUST verify:

- [ ] rtk digunakan untuk semua command?
- [ ] DOX chain sudah dibaca (root → target path)?
- [ ] Ada perubahan yang perlu update `## State & Constraints`?
- [ ] `cargo check` / `cargo clippy` clean?
- [ ] Tidak ada kode YAGNI/spekulatif baru?
- [ ] Output komunikasi pakai caveman ID style?
```

AI tidak boleh skip checklist ini. Jika ada item merah, harus fix dulu.

### Tier 5: Progressive Disclosure (Moderat)

Jangan dump semua rules di system prompt. Surface rules **contextually**:
- Per directory: `child AGENTS.md` hanya untuk scope directory itu
- Query rules on-demand via **MCP codebase-memory**
- Ganti "baca semua rules" dengan "cari rules yang relevan"

---

## 3. Concrete Action Items

### Tier 1 — Structural Enforcement

| # | Item | File | Prioritas |
|---|------|------|-----------|
| 1 | Buat pre-commit hook validasi DOX chain | `.git/hooks/pre-commit` | P0 |
| 2 | Buat wrapper script `ai-run.sh` dengan rtk auto-prefix | `scripts/ai-run.sh` | P0 |
| 3 | Setup CI workflow validasi DOX integrity | `.github/workflows/dox-check.yml` | P1 |
| 4 | Buat script auto-check AGENTS.md update setelah edit | `scripts/check-dox-update.sh` | P1 |
| 5 | Setup verification gate (cargo check otomatis) | `scripts/verify.sh` | P1 |

### Tier 2 — Simplifikasi Rules

| # | Item | File | Prioritas |
|---|------|------|-----------|
| 6 | Konsolidasi AGENTS.md ke <60 baris | `AGENTS.md` | P0 |
| 7 | Buat STATE.md (fix broken reference) | `STATE.md` | P0 |
| 8 | Isi Child DOX Index dengan daftar nyata | `AGENTS.md` | P0 |
| 9 | Hapus duplikasi antara root AGENTS.md dan skill files | `skills/*/SKILL.md` | P1 |
| 10 | Seragamkan bahasa: EN untuk rules, ID untuk output | Semua AGENTS.md | P1 |

### Tier 3 — Tool-Specific Config

| # | Item | File | Prioritas |
|---|------|------|-----------|
| 11 | Buat symlink `.clinerules` → `AGENTS.md` | `.clinerules` | P0 |
| 12 | Buat symlink `CLAUDE.md` → `AGENTS.md` | `CLAUDE.md` | P0 |
| 13 | Buat symlink `.cursorrules` → `AGENTS.md` | `.cursorrules` | P0 |
| 14 | Buat dir `.github/` + symlink copilot-instructions | `.github/copilot-instructions.md` | P1 |
| 15 | Dokumentasi setup Codex | `docs/codex-setup.md` | P2 |

### Tier 4 — Self-Check Protocol

| # | Item | File | Prioritas |
|---|------|------|-----------|
| 16 | Tambah Pre-Completion Checklist ke AGENTS.md | `AGENTS.md` | P0 |
| 17 | Buat verification script (checklist runner) | `scripts/checklist-runner.sh` | P1 |

### Tier 5 — Progressive Disclosure

| # | Item | File | Prioritas |
|---|------|------|-----------|
| 18 | Refactor child AGENTS.md per directory (hanya rules relevan) | `src/AGENTS.md`, dll | P2 |
| 19 | Integrasi MCP codebase-memory untuk rule query on-demand | `configure.sh` | P2 |
| 20 | Hapus system prompt rules yang redundan dengan file | System prompt config | P2 |

---

## 4. Key Insight

> Rules di markdown adalah **permintaan**, bukan **perintah**. AI tools tidak punya motivasi untuk mematuhi — mereka tidak bisa dihukum, tidak bisa diberi sanksi. Solusi efektif = pindahkan enforcement dari **"harap dibaca"** ke **"tidak bisa dilewati"** (structural gates).
>
> **Pre-commit hook > CI check > checklist > instruksi markdown.**
>
> Semakin sedikit rules yang bergantung pada **disiplin AI**, semakin tinggi kepatuhan. Investasi utama ada di **Tier 1 dan Tier 2**: structural enforcement + simplifikasi. Sisanya opsional.
