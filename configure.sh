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


# Memeriksa status instalasi cargo-mcp
log_info "Memeriksa status instalasi cargo-mcp..."
CARGO_MCP_PATH=""
if command -v cargo-mcp >/dev/null 2>&1; then
    CARGO_MCP_PATH=$(command -v cargo-mcp)
    log_success "cargo-mcp sudah terinstal di: $CARGO_MCP_PATH"
else
    log_info "Menginstal cargo-mcp via cargo..."
    if command -v cargo >/dev/null 2>&1; then
        cargo install cargo-mcp
        if command -v cargo-mcp >/dev/null 2>&1; then
            CARGO_MCP_PATH=$(command -v cargo-mcp)
            log_success "cargo-mcp berhasil diinstal di: $CARGO_MCP_PATH"
        else
            log_warning "Gagal menginstal cargo-mcp secara otomatis. Silakan instal manual dengan 'cargo install cargo-mcp'."
        fi
    else
        log_warning "cargo tidak ditemukan. Lewati instalasi cargo-mcp."
    fi
fi
export CARGO_MCP_PATH

CODEBASE_MEMORY_PATH=""
if command -v codebase-memory-mcp >/dev/null 2>&1; then
    CODEBASE_MEMORY_PATH=$(command -v codebase-memory-mcp)
else
    CODEBASE_MEMORY_PATH="/home/erel/.local/bin/codebase-memory-mcp"
fi
export CODEBASE_MEMORY_PATH

# Konfigurasi MCP server untuk Antigravity, Cline, dan Roo Code
log_info "Mengonfigurasi MCP server untuk Antigravity, Cline, dan Roo Code..."
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
    
    codebase_mem_cmd = os.environ.get("CODEBASE_MEMORY_PATH", "/home/erel/.local/bin/codebase-memory-mcp")
    data["mcpServers"]["codebase-memory"] = {
        "command": codebase_mem_cmd,
        "args": [],
        "env": {"CODEBASE_MEMORY_LOG_LEVEL": "info"}
    }
    data["mcpServers"]["sequential-thinking"] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
    data["mcpServers"]["memory"] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
    cargo_mcp_cmd = os.environ.get("CARGO_MCP_PATH", "cargo-mcp")
    data["mcpServers"]["cargo-mcp"] = {
        "command": cargo_mcp_cmd,
        "args": ["serve"]
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


# 5. Otomatisasi Child DOX Index
log_info "Memulai otomatisasi dan sinkronisasi Child DOX Index..."
if command -v python3 >/dev/null 2>&1; then
    python3 -c '
import os, re

def automate_dox():
    root_dir = os.getcwd()
    root_agents_path = os.path.join(root_dir, "AGENTS.md")
    if not os.path.exists(root_agents_path):
        print("  [SKIP] AGENTS.md tidak ditemukan di root.")
        return
    
    ignored_dirs = {".git", "target", ".cargo", "node_modules", ".gemini", ".next", ".svelte-kit", "dist", "build"}
    
    # Auto-initialize standard subdirectories if they exist but lack AGENTS.md
    subdirs = []
    for item in os.listdir(root_dir):
        item_path = os.path.join(root_dir, item)
        if os.path.isdir(item_path) and item not in ignored_dirs:
            subdirs.append(item)
            
    standard_dirs = {"src", "public", "tests", "app", "components", "pages", "lib", "services", "api", "backend", "frontend", "style"}
    
    for sd in subdirs:
        if sd.lower() in standard_dirs:
            child_agents_path = os.path.join(root_dir, sd, "AGENTS.md")
            if not os.path.exists(child_agents_path):
                parent_rel = "../AGENTS.md"
                template = f"""# DOX Child Module - {sd.upper()}

- **Purpose:** Local rules and guidelines for the `{sd}` directory.
- **Parent:** [Parent AGENTS.md]({parent_rel})

## Local Rules
- (Add specific rules for this module here)

## State & Constraints
- (Add local constraints here)
"""
                os.makedirs(os.path.dirname(child_agents_path), exist_ok=True)
                with open(child_agents_path, "w") as f:
                    f.write(template)
                print(f"  [OK] Child AGENTS.md dibuat di: {sd}/AGENTS.md")

    # Scan recursively for all child AGENTS.md files
    child_links = []
    for root, dirs, files in os.walk(root_dir):
        # prune ignored dirs
        dirs[:] = [d for d in dirs if d not in ignored_dirs]
        for file in files:
            if file == "AGENTS.md":
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, root_dir)
                if rel_path != "AGENTS.md": # exclude root
                    module_name = os.path.dirname(rel_path)
                    child_links.append(f"- [{module_name.upper()}]({rel_path})")

    # Update root AGENTS.md ## Child DOX Index section
    if child_links:
        child_links.sort()
        index_content = "\n".join(child_links)
    else:
        index_content = "None."

    with open(root_agents_path, "r") as f:
        content = f.read()

    if "## Child DOX Index" in content:
        parts = content.split("## Child DOX Index")
        parts[1] = "\n" + index_content + "\n"
        new_content = "## Child DOX Index".join(parts)
        with open(root_agents_path, "w") as f:
            f.write(new_content)
        print("  [OK] Root AGENTS.md Child DOX Index berhasil diperbarui!")

automate_dox()
'
else
    log_warning "python3 tidak ditemukan. Otomatisasi Child DOX dilewati."
fi

log_success "Seluruh konfigurasi Betterimp Framework berhasil diselesaikan!"
