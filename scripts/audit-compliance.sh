#!/bin/sh
# scripts/audit-compliance.sh — Audit kepatuhan AI tools via git history
# Usage: sh scripts/audit-compliance.sh [path]
#   path: path ke proyek (default: direktori saat ini)
# Output: compliance score + detail per aturan

set -e

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

echo "============================================"
echo " 🔍 AI Compliance Audit — betterimp-fw"
echo "============================================"
echo "Proyek: $(pwd)"
echo ""

PASS=0
FAIL=0
TOTAL=0

check() {
    TOTAL=$((TOTAL + 1))
    if [ "$2" -eq 0 ]; then
        echo "  ✅ $1"
        PASS=$((PASS + 1))
    else
        echo "  ❌ $1"
        FAIL=$((FAIL + 1))
    fi
}

# ==========================================
# ATURAN 1: STATE.md update saat code berubah
# ==========================================
echo "--- Aturan 1: STATE.md update ---"

# Cari commit yang mengubah file di src/ atau direktori kode lain
# TAPI tidak mengubah STATE.md
CODE_DIRS="src lib app components pages"

for dir in $CODE_DIRS; do
    if [ -d "$dir" ]; then
        # Cari commit dengan file baru di code dirs tapi STATE.md tidak berubah
        VIOLATIONS=$(git log --oneline --name-only --since="1 month ago" 2>/dev/null | grep -c "^$dir/" || true)
        STATE_UPDATES=$(git log --oneline --name-only --since="1 month ago" 2>/dev/null | grep -c "STATE.md" || true)
        if [ "$VIOLATIONS" -gt 0 ] && [ "$STATE_UPDATES" -eq 0 ]; then
            check "STATE.md: $VIOLATIONS file changes, 0 STATE.md updates (WARNING)" 1
        else
            check "STATE.md: $VIOLATIONS changes, $STATE_UPDATES updates" 0
        fi
        break
    fi
done

# ==========================================
# ATURAN 2: Apakah symlinks masih intact?
# ==========================================
echo "--- Aturan 2: Symlinks ---"
for link in .cursorrules CLAUDE.md .clinerules .github/copilot-instructions.md; do
    if [ -L "$link" ]; then
        TARGET=$(readlink "$link")
        check "Symlink $link → $TARGET" 0
    elif [ -f "$link" ]; then
        check "Symlink $link: regular file (not symlink!)" 1
    else
        check "Symlink $link: missing" 1
    fi
done

# ==========================================
# ATURAN 3: Apakah pre-commit hook aktif?
# ==========================================
echo "--- Aturan 3: Pre-commit hook ---"
HOOKS_PATH=$(git config core.hooksPath 2>/dev/null || echo "")
if [ "$HOOKS_PATH" = ".githooks" ]; then
    check "Pre-commit hooks: aktif (.githooks)" 0
elif [ -f .githooks/pre-commit ]; then
    check "Pre-commit hooks: path belum diset" 1
else
    check "Pre-commit hooks: tidak ada" 1
fi

# ==========================================
# ATURAN 4: Apakah AGENTS.md berubah tanpa Child DOX Index update?
# ==========================================
echo "--- Aturan 4: DOX Chain Integrity ---"
CHILD_DOX_COUNT=$(find . -name "AGENTS.md" -not -path "./.git/*" 2>/dev/null | wc -l)
check "AGENTS.md files: $CHILD_DOX_COUNT (root + child)" 0

# ==========================================
# ATURAN 5: Apakah skills lengkap?
# ==========================================
echo "--- Aturan 5: Skills ---"
for skill in arugoflow caveman ponytail ponytail-audit; do
    if [ -f "skills/$skill/SKILL.md" ]; then
        check "Skill $skill: ada" 0
    else
        check "Skill $skill: MISSING" 1
    fi
done

# ==========================================
# ATURAN 6: Apakah arugoflow PRD sync?
# ==========================================
echo "--- Aturan 6: Arugoflow PRD Sync ---"
if [ -f "skills/arugoflow/SKILL.md" ] && [ -f "$HOME/.agents/skills/arugoflow/SKILL.md" ]; then
    if diff -q "skills/arugoflow/SKILL.md" "$HOME/.agents/skills/arugoflow/SKILL.md" >/dev/null 2>&1; then
        check "Arugoflow: synced with global" 0
    else
        check "Arugoflow: OUTDATED — run 'sh scripts/sync-skills.sh pull'" 1
    fi
fi

# ==========================================
# ATURAN 7: Apakah rtk terinstall?
# ==========================================
echo "--- Aturan 7: rtk ---"
if command -v rtk >/dev/null 2>&1; then
    RTK_VER=$(rtk --version 2>/dev/null || echo "unknown")
    check "rtk terinstall ($RTK_VER)" 0
else
    check "rtk TIDAK terinstall" 1
fi

# ==========================================
# ATURAN 8: Mode-specific rules exists?
# ==========================================
echo "--- Aturan 8: Mode rules ---"
for mode in code debug architect ask; do
    if [ -f ".roo/rules-$mode/AGENTS.md" ]; then
        check "Mode $mode rules: ada" 0
    else
        check "Mode $mode rules: MISSING" 1
    fi
done

# ==========================================
# ATURAN 9: VSCode tasks
# ==========================================
echo "--- Aturan 9: VSCode config ---"
[ -f .vscode/tasks.json ] && check ".vscode/tasks.json: ada" 0 || check ".vscode/tasks.json: MISSING" 1
[ -f .vscode/settings.json ] && check ".vscode/settings.json: ada" 0 || check ".vscode/settings.json: MISSING" 1

# ==========================================
# ATURAN 10: CI/CD
# ==========================================
echo "--- Aturan 10: CI/CD ---"
if [ -f .github/workflows/compliance.yml ]; then
    check "CI/CD workflow: ada" 0
else
    check "CI/CD workflow: MISSING" 1
fi

# ==========================================
# ATURAN 11: Git log — rtk usage (sebulan terakhir)
# ==========================================
echo "--- Aturan 11: rtk usage (dari commit messages) ---"
RTK_COMMITS=$(git log --oneline --all --since="1 month ago" 2>/dev/null | head -50 | grep -i "rtk" | wc -l || echo 0)
TOTAL_COMMITS=$(git log --oneline --all --since="1 month ago" 2>/dev/null | head -50 | wc -l || echo 0)
if [ "$TOTAL_COMMITS" -gt 0 ]; then
    if [ "$RTK_COMMITS" -gt 0 ]; then
        check "rtk: $RTK_COMMITS/$TOTAL_COMMITS commits mention rtk" 0
    else
        check "rtk: 0/$TOTAL_COMMITS commits mention rtk (mungkin tidak dipakai)" 1
    fi
else
    check "rtk: no commits in last month (skip)" 0
fi

# ==========================================
# SCORE
# ==========================================
echo ""
echo "============================================"
echo " 📊 COMPLIANCE SCORE: $PASS/$TOTAL"
echo "============================================"

PERCENT=$((PASS * 100 / (TOTAL > 0 ? TOTAL : 1)))

if [ "$PERCENT" -ge 90 ]; then
    echo " 🟢 GRADE A: AI tools patuh ✅"
elif [ "$PERCENT" -ge 75 ]; then
    echo " 🟡 GRADE B: Sebagian besar patuh ⚠️"
elif [ "$PERCENT" -ge 50 ]; then
    echo " 🟠 GRADE C: Banyak pelanggaran 🔴"
else
    echo " 🔴 GRADE D: AI tools TIDAK patuh ❌❌❌"
fi
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo " 🔧 Action items:"
    [ -f scripts/ai-enforce.sh ] && echo "    - sh scripts/ai-enforce.sh (diagnosis detail)"
    echo "    - sh scripts/sync-skills.sh pull (sync skills)"
    echo "    - git config core.hooksPath .githooks (aktifkan hooks)"
    exit 1
else
    echo " ✅ Semua aturan dipatuhi."
    exit 0
fi
