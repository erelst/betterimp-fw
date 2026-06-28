# AGENTS.md — skills/

## Purpose

Defines skill modules available to AI agents in betterimp-fw. Each skill is loaded on-demand when the task BEHAVIOR or current STATE matches its description.

## Ownership

Owned by root AGENTS.md. Each `skills/<name>/` subdirectory has one `SKILL.md` defining that skill's rules.

## Available Skills

| When behavior/state is → | Load | Instructions in |
|--------------------|------|-----------------|
| Need minimal/simple code, question if code is needed | Ponytail | [`ponytail/SKILL.md`](ponytail/SKILL.md) |
| Need very compressed output, remove filler words | Caveman | [`caveman/SKILL.md`](caveman/SKILL.md) |
| Writing PRD/docs that must match actual code | Arugoflow | [`arugoflow/SKILL.md`](arugoflow/SKILL.md) |
| Scanning for over-engineering, dead code, bloat | Ponytail-audit | [`ponytail-audit/SKILL.md`](ponytail-audit/SKILL.md) |
| Isolating bugs, finding root cause | Isolation-debug | [`isolation-debug/SKILL.md`](isolation-debug/SKILL.md) |
