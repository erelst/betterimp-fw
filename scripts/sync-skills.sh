#!/bin/sh
# scripts/sync-skills.sh — Sync skill files between project and global dirs
# Usage: sh scripts/sync-skills.sh [direction]
#   direction: "push" (project → global), "pull" (global → project), "both" (default: pull)

set -e

SKILLS_DIR="$(cd "$(dirname "$0")/../skills" && pwd)"
AGENTS_SKILLS_DIR="$HOME/.agents/skills"
ROO_SKILLS_DIR="$HOME/.roo/skills"
DIRECTION="${1:-pull}"

log_info() { printf "  ℹ️  %s\n" "$*"; }
log_ok()   { printf "  ✅ %s\n" "$*"; }
log_warn() { printf "  ⚠️  %s\n" "$*"; }

echo "=== Sync skills: $DIRECTION ==="
echo "  Project: $SKILLS_DIR"
echo ""

# Map of skill directories to sync
SKILLS="caveman ponytail ponytail-audit arugoflow"

for skill in $SKILLS; do
    project_file="$SKILLS_DIR/$skill/SKILL.md"
    global_file="$AGENTS_SKILLS_DIR/$skill/SKILL.md"
    roo_file="$ROO_SKILLS_DIR/$skill/SKILL.md"

    case "$DIRECTION" in
        pull)
            # Global → Project (default)
            if [ -f "$global_file" ]; then
                if diff -q "$project_file" "$global_file" >/dev/null 2>&1; then
                    log_ok "$skill: already synced"
                else
                    cp "$global_file" "$project_file"
                    log_ok "$skill: synced from global ($global_file → project)"
                fi
            else
                log_warn "$skill: global source not found at $global_file"
            fi
            ;;

        push)
            # Project → Global
            if [ -f "$project_file" ]; then
                for target_dir in "$AGENTS_SKILLS_DIR" "$ROO_SKILLS_DIR"; do
                    target_file="$target_dir/$skill/SKILL.md"
                    mkdir -p "$(dirname "$target_file")"
                    if [ -f "$target_file" ] && diff -q "$project_file" "$target_file" >/dev/null 2>&1; then
                        log_ok "$skill → $(basename $target_dir): already synced"
                    else
                        cp "$project_file" "$target_file"
                        log_ok "$skill: pushed to $(basename $target_dir)"
                    fi
                done
            else
                log_warn "$skill: project file not found at $project_file"
            fi
            ;;

        both)
            # Bidirectional sync — pull global → project, then push project → global
            sh "$0" pull
            sh "$0" push
            ;;
    esac
done

echo ""
echo "=== Sync complete ==="
