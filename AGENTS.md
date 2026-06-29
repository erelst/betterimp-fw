# DOX Framework — betterimp-fw

Global AI contract. Anti-regression, minimal code, efficient communication.

## Workflow (MUST follow exactly — behavior + state)

### Phase A — Before first edit this session
1. Read this entire file and [STATE.md](STATE.md). Note current state and active constraints.
2. IF `## Active Constraints` lists anything overlapping target paths: MUST adjust approach.
3. Walk DOX chain: for each target path, read every AGENTS.md from root to target's directory. Cross-reference with STATE.md constraints. Nearest AGENTS.md controls local details.

### Phase B — After file changes
1. Locate nearest AGENTS.md above each changed file. Check STATE.md for constraints on modified paths.
2. Update nearest AGENTS.md IF any changed: purpose/scope/ownership, structure/contracts/workflows, constraints/permissions, user preferences, AGENTS.md files themselves.
3. STATE.md: create if missing, OR append a row to `## Entry Log` when refactoring features or modifying constraints.
4. Remove stale/contradictory text immediately.

### Phase C — Before attempt_completion
Verify ALL items in [Pre-Completion Checklist] below. Check STATE.md one last time for any new active constraints.

## Pre-Completion Checklist

MUST verify each item before attempt_completion (behavior + state):
- [ ] **Compiler/linter clean**: run language-appropriate check (`cargo check`, `tsc --noEmit`, `ruff check`, `go vet ./...`). Fix all errors. Check STATE.md if new constraints appear.
- [ ] **STATE.md read**: verify no active constraints overlap modified paths.
- [ ] **DOX chain read**: verify AGENTS.md chain was read. Check STATE.md for constraints on target paths.
- [ ] **No YAGNI code**: scan diff for speculative code. Check STATE.md if any new constraints should be logged.
- [ ] **rtk used**: verify every developer command was `rtk`-prefixed. STATE.md already logged any new tool requirements.
- [ ] **Caveman output**: no filler phrases (well, basically, actually, basically, obviously, you know). Review and trim. Align tone with STATE.md language preference.

## Skills (load on behavior/state)

Skills load when the task BEHAVIOR or current STATE matches, not only on exact keywords. Detect intent from context.

| When behavior/state is → | Load | Instructions in |
|-------------------------|------|-----------------|
| Writing/modifying code — prefer minimal, simplest. Ponytail always active when building code. | Ponytail | [skills/ponytail/SKILL.md](skills/ponytail/SKILL.md) |
| Communicating output — need concise, filler-free text. Caveman always active for output. | Caveman | [skills/caveman/SKILL.md](skills/caveman/SKILL.md) |
| Generating/updating PRD or docs. State: code has changed, docs are stale. | Arugoflow | [skills/arugoflow/SKILL.md](skills/arugoflow/SKILL.md) |
| Auditing codebase — over-engineering or bloat suspected. State: needs cleanup pass. | Ponytail-audit | [skills/ponytail-audit/SKILL.md](skills/ponytail-audit/SKILL.md) |
| Debugging — errors occurring or root cause unknown. | Isolation-debug | [skills/isolation-debug/SKILL.md](skills/isolation-debug/SKILL.md) |

## Child DOX Index

| Path | Scope |
|------|-------|
| [skills/](skills/) | Skill definitions — loaded on-demand |
| [.roo/rules-code/](.roo/rules-code/) | Code mode rules |
| [.roo/rules-debug/](.roo/rules-debug/) | Debug mode rules |
| [.roo/rules-architect/](.roo/rules-architect/) | Architect mode rules |
| [.roo/rules-ask/](.roo/rules-ask/) | Ask mode rules |
| [.roo/rules-project-research/](.roo/rules-project-research/) | Project Research mode rules |
| [.roo/rules-orchestrator/](.roo/rules-orchestrator/) | Orchestrator mode rules |
| [.roo/rules-coding-teacher/](.roo/rules-coding-teacher/) | Coding Teacher mode rules |
| [.roo/rules-mode-writer/](.roo/rules-mode-writer/) | Mode Writer mode rules |
| [.roo/rules-security-review/](.roo/rules-security-review/) | Security Reviewer mode rules |
| [.githooks/](.githooks/) | Git hooks — AI pre-commit compliance |
| [scripts/](scripts/) | AI environment validation & sync scripts |
| [.github/workflows/](.github/workflows/) | CI/CD compliance workflow |
| [.vscode/](.vscode/) | VSCode tasks & settings |
| [STATE.md](STATE.md) | Anti-regression state & constraints |

