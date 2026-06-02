# CLAUDE.md hierarchy: user vs project scope; modularity via `@import` / `.claude/rules/`

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.1 (CLAUDE.md hierarchy, scoping, modular organization)
> **Scenario:** Code Generation with Claude Code · **Study area:** CLAUDE.md hierarchy & modularity (`@import`, `.claude/rules/`, `/memory`)
> **Trap level:** 🟡 Medium — every option "fixes" the standards, but only one moves them to a shared scope
> **Trap archetype:** Symptom over root cause
> **Source:** Concept note grounded in the official exam guide, Task 3.1.

## 1. Topic — what this really tests

The CLAUDE.md hierarchy loads broadest-to-most-specific: user-level (`~/.claude/CLAUDE.md`), project-level (`.claude/CLAUDE.md` or root `CLAUDE.md`), and directory-level subdirectory files. **Scope is a sharing boundary:** user-level lives on one machine and is *never* version-controlled, so teammates never see it; project-level is committed and shared with the whole team. To keep a project file lean you modularize — `@import` pulls in external standards files (e.g. per-package standards), and `.claude/rules/` holds focused topic files (`testing.md`, `api-conventions.md`, `deployment.md`) instead of one monolithic CLAUDE.md. When behavior is inconsistent across sessions, `/memory` shows exactly which memory files are loaded so you can diagnose where an instruction actually lives.

## 2. Question

> A team's coding standards are followed when one senior engineer runs Claude Code, but a newly onboarded teammate reports that Claude ignores those same standards on the identical repo. Investigating, you find the standards were written into the senior engineer's `~/.claude/CLAUDE.md`. What is the correct fix so every team member's Claude Code session picks up the standards?

## 3. Answer options

- **A.** Move the standards into the project's `.claude/CLAUDE.md` (or root `CLAUDE.md`) and commit it, so they are version-controlled and shared with everyone on the repo. — ✅ **Correct**
- **B.** Have each developer copy the standards into their own `~/.claude/CLAUDE.md`. — ⚠️ **Most common wrong answer**
- **C.** Package the standards as a skill so they load on demand.
- **D.** Raise the model's max context window so the standards are guaranteed to fit.

## 4. Correct answer — A

`~/.claude/CLAUDE.md` is **user-level**: it applies only to that one user's machine and is not shared via version control. The standards never reach teammates because they live outside the repo. Moving them to **project-level** (`.claude/CLAUDE.md` or root `CLAUDE.md`) and committing them places them in the shared, version-controlled hierarchy that loads for anyone who clones the repo. Generalize: **scope = sharing boundary** (user = just you; project = the team). Modularize the project file with `@import` (selectively include per-package standards) or `.claude/rules/` (topic files), and use `/memory` to verify which files are actually loaded when behavior differs across sessions.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **B — "have each developer copy the standards into their own `~/.claude/CLAUDE.md`."** It is seductive because it appears to solve the immediate symptom: the new teammate's Claude does start following the standards once the file lands on their machine. The tell that it's wrong: the standards are still at **user-level** — unversioned, scattered across machines, and free to drift apart, so the very next new hire silently misses them again. That is treating the symptom (one person doesn't see the rules) instead of the root cause (the rules live in the wrong scope). The correct move addresses the scope itself: commit the standards to project-level, where the shared, version-controlled hierarchy delivers them to everyone who clones the repo, once. Reaching for "make each person copy it locally" instead of "put it in the shared scope" is the classic symptom-over-root-cause trap.

## 6. Distractor analysis — look-alikes to watch for

- **B —** Manually copying into each `~/.claude/CLAUDE.md` "works" temporarily but keeps the standards user-level: unversioned, drift-prone, and silently missed by the next new hire. It treats the symptom, not the wrong scope.
- **C —** Skills load on demand, not at session start; always-on team standards belong in project-level CLAUDE.md (or `.claude/rules/`), not a skill. Wrong mechanism for persistent, shared instructions.
- **D —** A red herring: the standards aren't being truncated, they're simply not in a shared location. Context size is irrelevant to the hierarchy/scoping problem.

## 7. Key takeaways

- User-level `~/.claude/CLAUDE.md` is personal and **not** version-controlled; team standards must be **project-level** to be shared.
- The hierarchy loads broadest→narrowest: user → project (`.claude/CLAUDE.md` or root `CLAUDE.md`) → directory-level.
- Keep project CLAUDE.md modular: `@import` external/per-package standards files; split topics into `.claude/rules/` (`testing.md`, `api-conventions.md`, `deployment.md`).
- Use `/memory` to confirm which memory files are loaded and diagnose inconsistent cross-session behavior.

## 8. Official documentation

- Manage Claude's memory (CLAUDE.md hierarchy, `@import`, `.claude/rules/`, `/memory`): https://code.claude.com/docs/en/memory
- Claude Code settings (`.claude/` layout, scopes, sharing): https://code.claude.com/docs/en/settings
