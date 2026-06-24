#!/bin/sh

# configure.sh - POSIX compliant setup script for Betterimp Framework
# Installs DOX (AGENTS.md), links skills, and installs rtk & codebase-memory-mcp.

set -e

# Resolve the directory where this script is located
# Using standard POSIX shell compliant path resolution
SCRIPT_PATH="$0"
case "$SCRIPT_PATH" in
    /*) SCRIPT_DIR=$(dirname "$SCRIPT_PATH") ;;
    *)  SCRIPT_DIR=$(pwd)/$(dirname "$SCRIPT_PATH") ;;
esac

# GitHub Raw URL for remote execution fallback
RAW_GITHUB_URL="https://raw.githubusercontent.com/erelst/betterimp-fw/main"

# Color definitions (POSIX compliant)
ESC=$(printf '\033')
RED="${ESC}[0;31m"
GREEN="${ESC}[0;32m"
BLUE="${ESC}[0;34m"
YELLOW="${ESC}[1;33m"
NC="${ESC}[0m"

# Shell Output Helper Functions
log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_success() {
    printf "${GREEN}[SUKSES]${NC} %s\n" "$1"
}

log_warning() {
    printf "${YELLOW}[PERINGATAN]${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
    exit 1
}

# Helper untuk menyalin atau mengunduh AGENTS.md
copy_or_download_agents() {
    if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
        log_info "Menyalin AGENTS.md dari folder lokal..."
        cp "$SCRIPT_DIR/AGENTS.md" ./AGENTS.md
    else
        log_info "Mengunduh AGENTS.md dari GitHub..."
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$RAW_GITHUB_URL/AGENTS.md" -o ./AGENTS.md
        elif command -v wget >/dev/null 2>&1; then
            wget -qO ./AGENTS.md "$RAW_GITHUB_URL/AGENTS.md"
        else
            log_error "curl atau wget tidak ditemukan. Gagal mengunduh AGENTS.md."
        fi
    fi
}

# 1. Konfigurasi AGENTS.md ke Proyek
log_info "Mengonfigurasi AGENTS.md ke direktori saat ini..."
if [ -f "AGENTS.md" ]; then
    log_warning "File AGENTS.md sudah ada di direktori ini."
    echo "Apakah Anda ingin menimpanya? (y/n)"
    read choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        copy_or_download_agents
        log_success "Berhasil memperbarui AGENTS.md!"
    else
        log_info "Penyalinan AGENTS.md dilewati."
    fi
else
    copy_or_download_agents
    log_success "Berhasil membuat AGENTS.md!"
fi

# Buat symbolic links kompatibilitas
log_info "Membuat symbolic links untuk kompatibilitas (.cursorrules, .clinerules, & CLAUDE.md)..."
ln -sf AGENTS.md .cursorrules
ln -sf AGENTS.md .clinerules
ln -sf AGENTS.md CLAUDE.md
log_success "Symbolic links berhasil dibuat!"

# 2. Menginstal & Mengonfigurasi Skill Global
log_info "Mengonfigurasi skill global (caveman, ponytail, ponytail-audit)..."
AGENTS_SKILLS_DIR="$HOME/.agents/skills"
ROO_SKILLS_DIR="$HOME/.roo/skills"

mkdir -p "$AGENTS_SKILLS_DIR/caveman" "$AGENTS_SKILLS_DIR/ponytail" "$AGENTS_SKILLS_DIR/ponytail-audit"
mkdir -p "$ROO_SKILLS_DIR/caveman" "$ROO_SKILLS_DIR/ponytail" "$ROO_SKILLS_DIR/ponytail-audit"

# Fungsi pembantu untuk mengunduh/menyalin skill
install_skill() {
    SKILL_NAME="$1"
    LOCAL_SKILL_FILE="$SCRIPT_DIR/skills/$SKILL_NAME/SKILL.md"

    # Hapus file/symlink target terlebih dahulu
    rm -f "$AGENTS_SKILLS_DIR/$SKILL_NAME/SKILL.md"
    rm -f "$ROO_SKILLS_DIR/$SKILL_NAME/SKILL.md"

    # Jika file ada di folder lokal framework, gunakan itu
    if [ -f "$LOCAL_SKILL_FILE" ]; then
        log_info "Menyalin skill '$SKILL_NAME' dari folder lokal..."
        cp "$LOCAL_SKILL_FILE" "$AGENTS_SKILLS_DIR/$SKILL_NAME/SKILL.md"
        cp "$LOCAL_SKILL_FILE" "$ROO_SKILLS_DIR/$SKILL_NAME/SKILL.md"
    else
        # Jika tidak ada secara lokal (karena running remote), unduh dari repo betterimp-fw kita
        log_info "Mengunduh skill '$SKILL_NAME' dari GitHub..."
        REMOTE_SKILL_URL="$RAW_GITHUB_URL/skills/$SKILL_NAME/SKILL.md"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$REMOTE_SKILL_URL" -o "$AGENTS_SKILLS_DIR/$SKILL_NAME/SKILL.md"
            cp "$AGENTS_SKILLS_DIR/$SKILL_NAME/SKILL.md" "$ROO_SKILLS_DIR/$SKILL_NAME/SKILL.md"
        elif command -v wget >/dev/null 2>&1; then
            wget -qO "$AGENTS_SKILLS_DIR/$SKILL_NAME/SKILL.md" "$REMOTE_SKILL_URL"
            cp "$AGENTS_SKILLS_DIR/$SKILL_NAME/SKILL.md" "$ROO_SKILLS_DIR/$SKILL_NAME/SKILL.md"
        else
            log_warning "curl atau wget tidak ditemukan. Gagal mengunduh skill '$SKILL_NAME'."
        fi
    fi
}

install_skill "caveman"
install_skill "ponytail"
install_skill "ponytail-audit"

log_success "Instalasi skill global selesai!"

# 3. Menginstal RTK (Rust Token Killer)
log_info "Memeriksa status instalasi RTK..."
if command -v rtk >/dev/null 2>&1; then
    log_success "RTK sudah terinstal."
else
    log_info "Menginstal RTK dari sumber asli (github.com/rtk-ai/rtk)..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
        log_success "RTK berhasil diinstal!"
        if command -v rtk >/dev/null 2>&1; then
            rtk init -g
            log_success "Inisialisasi global RTK berhasil!"
        fi
    else
        log_warning "curl diperlukan untuk menginstal RTK secara otomatis."
    fi
fi

# 4. Menginstal & Mengonfigurasi codebase-memory-mcp
log_info "Memeriksa status instalasi codebase-memory-mcp..."
CODEBASE_MEM_INSTALLED=0
if command -v codebase-memory-mcp >/dev/null 2>&1; then
    log_success "codebase-memory-mcp sudah terinstal."
    CODEBASE_MEM_INSTALLED=1
else
    log_info "Menginstal codebase-memory-mcp dari sumber asli (github.com/DeusData/codebase-memory-mcp)..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | sh
        log_success "codebase-memory-mcp berhasil diinstal!"
        CODEBASE_MEM_INSTALLED=1
    else
        log_warning "curl diperlukan untuk menginstal codebase-memory-mcp secara otomatis."
    fi
fi

# Konfigurasi codebase-memory-mcp untuk Antigravity, Cline, dan Roo Code
if [ "$CODEBASE_MEM_INSTALLED" = "1" ]; then
    log_info "Mengonfigurasi codebase-memory-mcp untuk Antigravity, Cline, dan Roo Code..."
    if command -v python3 >/dev/null 2>&1; then
        python3 -c '
import json, os
def update_mcp(path):
    path = os.path.expanduser(path)
    if not os.path.exists(path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        data = {"mcpServers": {}}
    else:
        try:
            with open(path, "r") as f: data = json.load(f)
        except Exception: data = {"mcpServers": {}}
    if "mcpServers" not in data: data["mcpServers"] = {}
    data["mcpServers"]["codebase-memory"] = {
        "command": "/home/erel/.local/bin/codebase-memory-mcp",
        "args": [],
        "env": {"CODEBASE_MEMORY_LOG_LEVEL": "info"}
    }
    data["mcpServers"]["sequential-thinking"] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
    with open(path, "w") as f: json.dump(data, f, indent=2)

files = [
    "~/.gemini/antigravity/mcp_config.json",
    "~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json",
    "~/.config/Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json",
    "~/.config/VSCodium/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json",
    "~/.config/VSCodium/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json"
]
for f in files:
    try:
        update_mcp(f)
        print(f"  [OK] Terkonfigurasi: {f}")
    except Exception as e:
        print(f"  [SKIP] {f} ({e})")
'
        log_success "Konfigurasi MCP selesai!"
    else
        log_warning "python3 tidak ditemukan. Silakan konfigurasi MCP server secara manual."
    fi
fi

log_success "Seluruh konfigurasi Betterimp Framework berhasil diselesaikan!"
