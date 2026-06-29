# DOX Framework — betterimp-fw

Global AI contract. Anti-regression, minimal code, efficient communication.

## Workflow (MUST follow exactly — behavior + state)

### Phase A — Before first edit this session
1. WHEN first edit in session: read this file AND [STATE.md](STATE.md). Note active constraints.
2. IF constraints exist AND overlap target paths: MUST adjust approach.
3. WHEN target paths exist: walk DOX chain from root, read every AGENTS.md. Cross-reference STATE.md constraints. Nearest AGENTS.md controls local details.

### Phase B — After file changes
1. AFTER file changes: locate nearest AGENTS.md above each changed file. Check STATE.md for constraints on modified paths.
2. IF any changed (purpose/scope/ownership, structure/contracts/workflows, constraints/permissions, user preferences, AGENTS.md files themselves): update nearest AGENTS.md.
3. IF refactoring features or modifying constraints: STATE.md — create if missing, OR append to `## Entry Log`.
4. IF stale/contradictory text found: remove immediately.

### Phase C — Before attempt_completion
WHEN attempt_completion is called: verify ALL items in [Pre-Completion Checklist]. Check STATE.md one last time for new constraints.

## Pre-Completion Checklist

MUST verify each item before attempt_completion (behavior + state):
- [ ] **Compiler/linter clean**: run language-appropriate check (`cargo check`, `tsc --noEmit`, `ruff check`, `go vet ./...`). Fix all errors. Check STATE.md if new constraints appear.
- [ ] **STATE.md read**: verify no active constraints overlap modified paths.
- [ ] **DOX chain read**: verify AGENTS.md chain was read. Check STATE.md for constraints on target paths.
- [ ] **No YAGNI code**: scan diff for speculative code. Check STATE.md if any new constraints should be logged.
- [ ] **rtk used**: verify every developer command was `rtk`-prefixed. STATE.md already logged any new tool requirements.
- [ ] **User output**: Bahasa Indonesia for all user-facing text. Clear, direct, full sentences. NOT Caveman.
- [ ] **AI thinking**: English + Caveman style for internal reasoning. Concise, compressed, no filler. ALWAYS active.

## Skills (load on behavior/state)

Skills load when the task BEHAVIOR or current STATE matches, not only on exact keywords. Detect intent from context.

| When behavior/state is → | Load | Instructions in |
|-------------------------|------|-----------------|
| ALL coding decisions AND code writing — Ponytail MANDATORY. Always active for any code work. | Ponytail (always active for code) | [skills/ponytail/SKILL.md](skills/ponytail/SKILL.md) |
| Internal thinking, reasoning, analysis — English + Caveman ALWAYS active. NOT for user-facing output. | Caveman (always active for thinking) | [skills/caveman/SKILL.md](skills/caveman/SKILL.md) |
| Generating/updating PRD or docs. State: code has changed, docs are stale. | Arugoflow | [skills/arugoflow/SKILL.md](skills/arugoflow/SKILL.md) |
| Auditing codebase — over-engineering or bloat suspected. State: needs cleanup pass. | Ponytail-audit | [skills/ponytail-audit/SKILL.md](skills/ponytail-audit/SKILL.md) |
| Debugging — errors occurring or root cause unknown. | Isolation-debug | [skills/isolation-debug/SKILL.md](skills/isolation-debug/SKILL.md) |

## MCP Tools (use on behavior/state)

| When behavior/state is → | Use | Purpose |
|--------------------------|-----|---------|
| Need library/framework API info, code examples, or setup guidance. State: unfamiliar API, guessing would be wrong. | **context7-mcp** | Look up real API docs before writing code |
| Need to understand code structure, find symbol definitions, trace call chains. State: editing unfamiliar code or navigating large codebase. | **codebase-memory-mcp** | Semantic codebase navigation |
| Task is complex, multi-step, or requires deep analysis. State: logic is tangled, steps are interdependent, or root cause is unclear. | **sequential-thinking** | Break down reasoning step by step |
| User stated a durable preference, decision, or fact. State: should persist across sessions, not just this conversation. | **server-memory** | Store and retrieve long-term project facts |

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

