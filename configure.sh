#!/bin/sh

# configure.sh - POSIX compliant setup script for Betterimp Framework
# Installs DOX (AGENTS.md), links skills, and installs rtk & codebase-memory-mcp.

set -e


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

ok() { printf "  ${GREEN}✓${NC} %s\n" "$*"; }

# Helper untuk menyalin atau mengunduh AGENTS.md
# Dengan smart merge: pertahankan State & Constraints + Child DOX Index proyek
copy_or_download_agents() {
    TMP_AGENTS=$(mktemp /tmp/AGENTS.md.XXXXXX)
    
    if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
        log_info "Menyalin AGENTS.md dari folder lokal..."
        cp "$SCRIPT_DIR/AGENTS.md" "$TMP_AGENTS"
    else
        log_info "Mengunduh AGENTS.md dari GitHub..."
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$RAW_GITHUB_URL/AGENTS.md" -o "$TMP_AGENTS"
        elif command -v wget >/dev/null 2>&1; then
            wget -qO "$TMP_AGENTS" "$RAW_GITHUB_URL/AGENTS.md"
        else
            rm -f "$TMP_AGENTS"
            log_error "curl atau wget tidak ditemukan. Gagal mengunduh AGENTS.md."
        fi
    fi

    # Jika proyek sudah punya AGENTS.md, merge bagian spesifik proyek
    if [ -f "AGENTS.md" ]; then
        python3 -c "
import re, sys, os, shutil
old_path = 'AGENTS.md'
new_path = '$TMP_AGENTS'

with open(old_path) as f:
    old = f.read()
with open(new_path) as f:
    new = f.read()

# Backup existing AGENTS.md before merge
shutil.copyfile(old_path, old_path + '.bak')
print('[BACKUP] AGENTS.md -> AGENTS.md.bak')

# Seksi yang harus dipertahankan dari proyek
preserve_sections = ['## State & Constraints', '## User Preferences', '## Child DOX Index']

for section in preserve_sections:
    # Cari di file lama (dengan MULTILINE agar ^ anchor berfungsi)
    old_match = re.search(r'^' + re.escape(section) + r'\n.*?(?=\n## |\Z)', old, re.DOTALL | re.MULTILINE)
    if old_match:
        old_content = old_match.group(0)
        # Ganti di file baru, case-sensitive
        pattern = r'^' + re.escape(section) + r'\n.*?(?=\n## |\Z)'
        if re.search(pattern, new, re.DOTALL | re.MULTILINE):
            new = re.sub(pattern, old_content, new, count=1, flags=re.DOTALL | re.MULTILINE)

with open('$TMP_AGENTS', 'w') as f:
    f.write(new)
print('[MERGE] Seksi proyek dipertahankan: State & Constraints, User Preferences, Child DOX Index')
    " 2>&1 || log_warning "Gagal melakukan merge AGENTS.md, gunakan template baru polos."
        fi
    
        # Atomic write: write to tmp, then rename
        cp "$TMP_AGENTS" ./AGENTS.md.tmp
        mv ./AGENTS.md.tmp ./AGENTS.md
        rm -f "$TMP_AGENTS"
}
# Source directory — where this script and framework files live
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Target project directory (optional, default: current directory)
TARGET_DIR="${1:-.}"
cd "$TARGET_DIR" || {
    echo "❌ Error: Cannot access target directory '$TARGET_DIR'"
    exit 1
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

# Create STATE.md if missing
if [ ! -f "STATE.md" ]; then
    log_info "Membuat STATE.md..."
    cat > STATE.md << 'EOF'
# STATE.md — Project State & Constraints

## Active Constraints
(None yet — add constraints as project evolves)

## Completed Tasks
- Initial setup with betterimp-fw
EOF
    log_success "Berhasil membuat STATE.md!"
fi

# Prompt user for AI tool selection (single input)
echo ""
echo "=== Pilih AI Tools yang Akan Dikonfigurasi ==="
echo "Pisahkan dengan koma, atau ketik 'all' untuk semua."
echo "  claude-code  — Symlink CLAUDE.md → AGENTS.md"
echo "  cursor       — Symlink .cursorrules → AGENTS.md"
echo "  cline        — Symlink .clinerules → AGENTS.md"
echo "  roo          — Symlink .clinerules + symlink .roo/"
printf "Pilihan [all]: "
read AI_TOOLS
AI_TOOLS="${AI_TOOLS:-all}"

# Helper: check if tool is selected
has_tool() { echo "$AI_TOOLS" | grep -iqE "$1|all"; }
has_not_all() { echo "$AI_TOOLS" | grep -ivq "all"; }

# Helper untuk setup symlink
setup_symlink() {
    _target="$1"
    if [ -L "$_target" ]; then
        if [ "$(readlink "$_target")" = "AGENTS.md" ]; then
            log_info "Symlink $_target -> AGENTS.md: already exists"
            return
        else
            log_warning "Symlink $_target points elsewhere -- updating"
            ln -sf AGENTS.md "$_target"
        fi
    elif [ -f "$_target" ]; then
        log_warning "$_target is a regular file -- backing up to $_target.bak"
        cp "$_target" "$_target.bak"
        ln -sf AGENTS.md "$_target"
    else
        ln -s AGENTS.md "$_target"
        log_info "Symlink $_target -> AGENTS.md: created"
    fi
}

# Create symlinks only for selected tools
if has_tool "claude-code"; then
    setup_symlink "CLAUDE.md"
fi
if has_tool "cursor"; then
    setup_symlink ".cursorrules"
fi
if has_tool "cline|roo"; then
    setup_symlink ".clinerules"
fi

# .roo directory — symlink instead of copy
if has_tool "roo"; then
    if [ -d "$SCRIPT_DIR/.roo" ]; then
        if [ -L ".roo" ]; then
            log_info ".roo symlink: already exists"
        elif [ ! -e ".roo" ]; then
            ln -s "$SCRIPT_DIR/.roo" ".roo"
            log_info ".roo: symlink created"
        else
            log_warning ".roo directory exists — backing up and symlinking"
            mv .roo .roo.bak
            ln -sf "$SCRIPT_DIR/.roo" ".roo"
        fi
    fi
fi


# Verify symlinks for selected tools
log_info "Verifying symlinks..."
for link in .cursorrules CLAUDE.md .clinerules; do
    if [ -L "$link" ] && [ "$(readlink "$link")" = "AGENTS.md" ]; then
        ok " $link → AGENTS.md"
    elif [ -f "$link" ]; then
        log_warning " $link exists as regular file (should be symlink)"
    else
        log_warning " $link not found"
    fi
done

# Setup git hooks path
log_info "Configuring git hooks..."
if git config core.hooksPath .githooks 2>/dev/null; then
    log_info "Git hooks path configured"
else
    log_warning "Not a git repository or git not available — hooks skipped"
fi
if [ -f "$SCRIPT_DIR/.githooks/pre-commit" ]; then
    log_info "Pre-commit hook ready"
fi

# 2. Menginstal & Mengonfigurasi Skill Global
log_info "Mengonfigurasi skill global (caveman, ponytail, ponytail-audit, arugoflow, isolation-debug)..."
AGENTS_SKILLS_DIR="$HOME/.agents/skills"
ROO_SKILLS_DIR="$HOME/.roo/skills"

mkdir -p "$AGENTS_SKILLS_DIR/caveman" "$AGENTS_SKILLS_DIR/ponytail" "$AGENTS_SKILLS_DIR/ponytail-audit" "$AGENTS_SKILLS_DIR/arugoflow" "$AGENTS_SKILLS_DIR/isolation-debug"
mkdir -p "$ROO_SKILLS_DIR/caveman" "$ROO_SKILLS_DIR/ponytail" "$ROO_SKILLS_DIR/ponytail-audit" "$ROO_SKILLS_DIR/arugoflow" "$ROO_SKILLS_DIR/isolation-debug"

# Fungsi pembantu untuk mengunduh/menyalin skill
install_skill() {
    SKILL_NAME="$1"
    LOCAL_SKILL_FILE="$SCRIPT_DIR/skills/$SKILL_NAME/SKILL.md"

    # Jika file ada di folder lokal framework, gunakan itu (dengan diff/skip)
    if [ -f "$LOCAL_SKILL_FILE" ]; then
        for target_dir in "$AGENTS_SKILLS_DIR" "$ROO_SKILLS_DIR"; do
            target_file="$target_dir/$SKILL_NAME/SKILL.md"
            if [ -f "$target_file" ]; then
                if diff -q "$LOCAL_SKILL_FILE" "$target_file" >/dev/null 2>&1; then
                    log_info "Skill $SKILL_NAME: already up-to-date"
                else
                    log_warning "Skill $SKILL_NAME: local version differs -- backup saved as SKILL.md.bak"
                    cp "$target_file" "$target_file.bak"
                    cp "$LOCAL_SKILL_FILE" "$target_file"
                fi
            else
                cp "$LOCAL_SKILL_FILE" "$target_file"
                log_info "Skill $SKILL_NAME: installed"
            fi
        done
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
install_skill "arugoflow"
install_skill "isolation-debug"

log_success "Instalasi skill global selesai!"

# Copy skills to target project
log_info "Copying skills to target project..."
for skill in caveman ponytail ponytail-audit arugoflow isolation-debug; do
    mkdir -p "./skills/$skill"
    if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
        cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "./skills/$skill/SKILL.md"
        log_info "  Skill $skill: copied to project"
    fi
done
if [ -f "$SCRIPT_DIR/skills/AGENTS.md" ]; then
    cp "$SCRIPT_DIR/skills/AGENTS.md" "./skills/AGENTS.md"
    log_info "  Skills AGENTS.md: copied to project"
fi

# Copy scripts to target project
log_info "Copying scripts to target project..."
mkdir -p "./scripts"
for script in ai-enforce.sh audit-compliance.sh sync-skills.sh; do
    if [ -f "$SCRIPT_DIR/scripts/$script" ]; then
        cp "$SCRIPT_DIR/scripts/$script" "./scripts/$script"
        chmod +x "./scripts/$script"
        log_info "  Script $script: copied"
    fi
done

# Copy .githooks to target project
log_info "Copying .githooks to target project..."
if [ -d "$SCRIPT_DIR/.githooks" ]; then
    mkdir -p "./.githooks"
    cp -r "$SCRIPT_DIR/.githooks/"* "./.githooks/"
    if [ -f "./.githooks/pre-commit" ]; then
        chmod +x "./.githooks/pre-commit"
    fi
    log_info "  .githooks: copied"
fi

# Copy .vscode config (editor-agnostic — always copied if cursor selected)
if has_tool "cursor" && [ -d "$SCRIPT_DIR/.vscode" ]; then
    cp -r "$SCRIPT_DIR/.vscode" "./"
    log_info "  .vscode: copied"
fi

# Copy .github config (CI/CD — only if any tool is selected)
if [ -n "$AI_TOOLS" ] && [ -d "$SCRIPT_DIR/.github" ]; then
    mkdir -p "./.github"
    cp -r "$SCRIPT_DIR/.github/"* "./.github/"
    log_info "  .github: copied"
fi

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

CODEBASE_MEMORY_PATH=$(command -v codebase-memory-mcp) || CODEBASE_MEMORY_PATH="$HOME/.local/bin/codebase-memory-mcp"
export CODEBASE_MEMORY_PATH

# Konfigurasi MCP server untuk Antigravity, Cline, dan Roo Code
log_info "Mengonfigurasi MCP server untuk Antigravity, Cline, dan Roo Code..."
if command -v python3 >/dev/null 2>&1; then
    python3 -c '
import json, os, shutil
def update_mcp(path):
    path = os.path.expanduser(path)
    if not os.path.exists(path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        data = {"mcpServers": {}}
    else:
        try:
            with open(path, "r") as f:
                data = json.load(f)
        except FileNotFoundError:
            data = {"mcpServers": {}}
        except json.JSONDecodeError as e:
            print(f"  [WARN] Invalid JSON in {path}: {e}. Backing up and resetting.")
            shutil.copyfile(path, path + ".corrupted.bak")
            data = {"mcpServers": {}}
    if "mcpServers" not in data: data["mcpServers"] = {}
    
    codebase_mem_cmd = os.environ.get("CODEBASE_MEMORY_PATH")
    if not codebase_mem_cmd:
        codebase_mem_cmd = os.path.expanduser("~/.local/bin/codebase-memory-mcp")
        
    new_servers = {
        "codebase-memory": {
            "command": codebase_mem_cmd,
            "args": [],
            "env": {"CODEBASE_MEMORY_LOG_LEVEL": "info"}
        },
        "sequential-thinking": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
        },
        "memory": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-memory"]
        }
    }
    
    for name, config in new_servers.items():
        if name in data.get("mcpServers", {}):
            existing = data["mcpServers"][name]
            for key, value in config.items():
                existing[key] = value
        else:
            data["mcpServers"][name] = config
    # Atomic write: write to tmp, then rename
    tmp_path = path + ".tmp"
    with open(tmp_path, "w") as f:
        json.dump(data, f, indent=2)
    os.replace(tmp_path, path)

files = [
    "~/.gemini/antigravity/mcp_config.json",
    "~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json",
    "~/.config/Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json",
    "~/.config/VSCodium/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json",
    "~/.config/VSCodium/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json",
    "~/.config/Antigravity/User/globalStorage/zoocodeorganization.zoo-code/settings/mcp_settings.json"
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


# Configure MCP for aider
if has_tool "aider"; then
    AIDER_CONF="$HOME/.aider.conf.yml"
    if [ -f "$AIDER_CONF" ]; then
        log_info "aider config exists — skipping MCP setup (manual merge needed)"
    else
        cat > "$AIDER_CONF" << 'MCPEOF'
# Aider MCP Servers (auto-configured by betterimp-fw)
mcp-servers:
  codebase-memory:
    command: CODEBASE_MEMORY_PLACEHOLDER
  sequential-thinking:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-sequential-thinking"]
  memory:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-memory"]
MCPEOF
        # Replace placeholder with actual path
        if command -v codebase-memory-mcp >/dev/null 2>&1; then
            sed "s|CODEBASE_MEMORY_PLACEHOLDER|$(command -v codebase-memory-mcp)|" "$AIDER_CONF" > "${AIDER_CONF}.tmp" && mv "${AIDER_CONF}.tmp" "$AIDER_CONF"
        else
            sed "s|CODEBASE_MEMORY_PLACEHOLDER|$HOME/.local/bin/codebase-memory-mcp|" "$AIDER_CONF" > "${AIDER_CONF}.tmp" && mv "${AIDER_CONF}.tmp" "$AIDER_CONF"
        fi
        log_info "  aider: MCP config created at ~/.aider.conf.yml"
    fi
fi

# Final compliance check (run from target project directory)
log_info "Running environment compliance check..."
cd "$TARGET_DIR" || {
    log_warning "Cannot access target directory for compliance check"
    exit 1
}
if [ -f "./scripts/ai-enforce.sh" ] && [ -x "./scripts/ai-enforce.sh" ]; then
    sh "./scripts/ai-enforce.sh" || log_warning "Some compliance checks failed — review and fix"
else
    log_warning "ai-enforce.sh not found in target project — skipping compliance check"
fi

log_success "Seluruh konfigurasi Betterimp Framework berhasil diselesaikan!"