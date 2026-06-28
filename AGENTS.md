# DOX Framework — betterimp-fw

Global AI contract. Anti-regression, minimal code, efficient communication.

## Workflow (MUST follow exactly)

### Phase A — Before first edit this session
1. Read this entire file.
2. Open [STATE.md](STATE.md). IF `## Active Constraints` lists anything overlapping your target paths, MUST adjust approach to respect them.
3. Walk DOX chain: for each target path, read every AGENTS.md from root to the target's directory. Nearest AGENTS.md to target controls local details.

### Phase B — After file changes
1. Locate nearest AGENTS.md in the directory tree above each changed file.
2. Update it IF any of these changed: purpose/scope/ownership, structure/contracts/workflows, constraints/permissions, user preferences, AGENTS.md files themselves.
3. IF change refactors a feature or adds/modifies constraints: append a row to STATE.md `## Entry Log`.
4. Remove stale/contradictory text immediately.

### Phase C — Before attempt_completion
Verify ALL items in [Pre-Completion Checklist] below.

## Pre-Completion Checklist

MUST verify each item before attempt_completion:
- [ ] **Compiler/linter clean**: run `cargo check` (Rust), `tsc --noEmit` (TS), `ruff check` (Python), `go vet ./...` (Go) — language-appropriate. Fix all errors.
- [ ] **STATE.md read**: verify no active constraints overlap modified paths.
- [ ] **DOX chain read**: verify every AGENTS.md on the path from root to modified files was read.
- [ ] **No YAGNI code**: scan diff for code without immediate caller or test. Delete speculative additions.
- [ ] **rtk used**: verify every `npm`, `cargo`, `go`, `pip`, `rustc`, `node`, `python` command was prefixed with `rtk`.
- [ ] **Caveman output**: no filler phrases (well, basically, actually, basically, obviously, you know). Review and trim.

## Skills (load on behavior/state)

Skills load when the task BEHAVIOR or current STATE matches, not only on exact keywords. Detect intent from context.

| When behavior/state is → | Load | Instructions in |
|-------------------------|------|-----------------|
| Writing/modifying code — prefer minimal, simplest solution. Question if code is needed at all. | Ponytail | [skills/ponytail/SKILL.md](skills/ponytail/SKILL.md) |
| Communicating output — need to be very concise, compress explanation, remove filler. | Caveman | [skills/caveman/SKILL.md](skills/caveman/SKILL.md) |
| Update or generating PRD, docs, or specs — must reflect actual code, not ideals. No technical jargon. | Arugoflow | [skills/arugoflow/SKILL.md](skills/arugoflow/SKILL.md) |
| Auditing codebase — check for dead code, over-engineering, bloat, unnecessary complexity. | Ponytail-audit | [skills/ponytail-audit/SKILL.md](skills/ponytail-audit/SKILL.md) |
| Debugging — finding root cause, isolating errors, troubleshooting failures. | Isolation-debug | [skills/isolation-debug/SKILL.md](skills/isolation-debug/SKILL.md) |

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

## Symlinks (read this file)

`.clinerules` · `.cursorrules` · `CLAUDE.md` · `.github/copilot-instructions.md`
