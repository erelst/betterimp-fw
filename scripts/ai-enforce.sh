#!/bin/sh
# scripts/ai-enforce.sh - AI environment compliance validator for betterimp-fw
# Panggil di awal sesi AI untuk verifikasi environment compliance
#
# Usage: sh scripts/ai-enforce.sh
# Return: exit 0 jika semua pass, exit 1 jika ada fail

set -e

PASS=0
FAIL=0

check() {
    if [ "$2" -eq 0 ]; then
        echo "  \342\234\205 $1"
        PASS=$((PASS + 1))
    else
        echo "  \342\235\214 $1"
        FAIL=$((FAIL + 1))
    fi
}

echo ""
echo "=== betterimp-fw: compliance check ==="
echo ""

# --- Core files ---
echo "--- Core Files ---"
# 1. STATE.md exists
test -f STATE.md
check "STATE.md exists" $?

# 2. AGENTS.md exists dan cukup pendek (<100 baris, ideal untuk LLM context)
test -f AGENTS.md
check "AGENTS.md exists" $?
LINES=$(wc -l < AGENTS.md 2>/dev/null || echo 999)
if [ "$LINES" -le 120 ]; then
    check "AGENTS.md length OK ($LINES lines)" 0
else
    check "AGENTS.md length OK ($LINES lines) [limit:120]" 1
fi

# --- Tools ---
echo ""
echo "--- Tools ---"
# 3. rtk terinstall
command -v rtk >/dev/null 2>&1
check "rtk installed" $?

# 4. git hooks path configured
HOOKS_PATH=$(git config core.hooksPath 2>/dev/null || echo "")
if [ "$HOOKS_PATH" = ".githooks" ]; then
    check "git hooks configured (.githooks)" 0
else
    check "git hooks configured (run: git config core.hooksPath .githooks)" 1
fi

# --- Symlinks ---
echo ""
echo "--- Symlinks ---"
# 5. Symlinks valid → AGENTS.md
for link in .cursorrules CLAUDE.md .clinerules; do
    if [ -L "$link" ]; then
        TARGET=$(readlink "$link")
        if [ "$TARGET" = "AGENTS.md" ]; then
            check "Symlink $link \342\206\222 AGENTS.md" 0
        else
            check "Symlink $link \342\206\222 $TARGET (expected: AGENTS.md)" 1
        fi
    elif [ -f "$link" ]; then
        check "Symlink $link is regular file (not symlink!)" 1
    else
        check "Symlink $link missing" 1
    fi
done

# --- Skills ---
echo ""
echo "--- Skills ---"
# 6. Skill directories exist
for skill in caveman ponytail ponytail-audit arugoflow; do
    if [ -d "skills/$skill" ] && [ -f "skills/$skill/SKILL.md" ]; then
        check "Skill $skill/ exists" 0
    else
        check "Skill $skill/ exists" 1
    fi
done

# 7. Check if arugoflow PRD needs updating (compare project skills with global)
echo ""
echo "--- PRD Sync ---"
for skill in arugoflow; do
    project_file="skills/$skill/SKILL.md"
    global_file="$HOME/.agents/skills/$skill/SKILL.md"
    if [ -f "$global_file" ] && [ -f "$project_file" ]; then
        if diff -q "$project_file" "$global_file" >/dev/null 2>&1; then
            check "$skill: synced with global" 0
        else
            check "$skill: OUTDATED — run: sh scripts/sync-skills.sh" 1
        fi
    elif [ -f "$project_file" ]; then
        check "$skill: global not found at $global_file" 1
    else
        check "$skill: project file missing" 1
    fi
done

# --- Scripts ---
echo ""
echo "--- Scripts ---"
# 7. configure.sh exists and executable
if [ -f "configure.sh" ] && [ -x "configure.sh" ]; then
    check "configure.sh executable" 0
else
    check "configure.sh executable" 1
fi

# 8. enforce script sendiri
if [ -f "scripts/ai-enforce.sh" ] && [ -x "scripts/ai-enforce.sh" ]; then
    check "ai-enforce.sh executable" 0
else
    check "ai-enforce.sh executable" 1
fi

# 9. pre-commit hook
if [ -f ".githooks/pre-commit" ] && [ -x ".githooks/pre-commit" ]; then
    check ".githooks/pre-commit executable" 0
else
    check ".githooks/pre-commit executable" 1
fi

# --- Summary ---
echo ""
echo "=== Result: $PASS passed, $FAIL failed ==="

if [ "$FAIL" -gt 0 ]; then
    echo ""
    echo "\360\237\224\204 Recommendations:"
    echo "  1. Run: sh configure.sh (setup ulang symlinks & tools)"
    echo "  2. Run: git config core.hooksPath .githooks (aktifkan hooks)"
    echo "  3. Pastikan STATE.md dan AGENTS.md ada di root proyek"
    echo "  4. Run: sh scripts/audit-compliance.sh (audit history compliance)"
    exit 1
fi

echo ""
echo "\342\234\205 All checks passed — environment compliant"
exit 0
