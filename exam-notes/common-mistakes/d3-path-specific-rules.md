# Path-specific rules vs. directory-bound CLAUDE.md for cross-cutting conventions

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.3 (path-specific rules for conditional convention loading)
> **Scenario:** Code Generation with Claude Code · **Study area:** Path-specific rules (.claude/rules globs)
> **Trap level:** 🔴 High — every option is a real memory mechanism, and the closest distractor is genuinely path-aware
> **Trap archetype:** Path-scoped rules vs. global instructions
> **Source:** Official Claude Certified Architect exam guide — Sample Question 6.

## 1. Topic — what this really tests
Whether you can pick the right Claude Code memory mechanism for conventions that are tied to a *kind of file* rather than to a *location*. Files in `.claude/rules/` carry YAML frontmatter with a `paths:` glob list; a rule loads into context only when Claude reads/edits a file matching one of its globs. This makes glob-scoped rules the maintainable choice when conventions span many directories (e.g. test files like `Button.test.tsx` sitting next to their source) and keeps unrelated context out of the window, saving tokens. The key contrast is *deterministic, path-driven loading* versus mechanisms that rely on inference (root `CLAUDE.md`) or manual invocation (skills) or directory binding (nested `CLAUDE.md`).

## 2. Question
> Your codebase has distinct areas with different coding conventions: React components use functional style with hooks, API handlers use async/await with specific error handling, and database models follow a repository pattern. Test files are spread throughout the codebase alongside the code they test (e.g., `Button.test.tsx` next to `Button.tsx`), and you want all tests to follow the same conventions regardless of location. What's the most maintainable way to ensure Claude automatically applies the correct conventions when generating code?
>
> **A)** Create rule files in `.claude/rules/` with YAML frontmatter specifying glob patterns to conditionally apply conventions based on file paths
> **B)** Consolidate all conventions in the root `CLAUDE.md` file under headers for each area, relying on Claude to infer which section applies
> **C)** Create skills in `.claude/skills/` for each code type that include the relevant conventions in their `SKILL.md` files
> **D)** Place a separate `CLAUDE.md` file in each subdirectory containing that area's specific conventions

## 3. Answer options
- **A.** `.claude/rules/` files with `paths:` globs — ✅ **Correct**
- **B.** Everything in root `CLAUDE.md`, Claude infers the section
- **C.** A skill per code type in `.claude/skills/`
- **D.** A `CLAUDE.md` per subdirectory — ⚠️ **Most common wrong answer**

## 4. Correct answer — A
A glob-scoped rule (e.g. `paths: ["**/*.test.tsx"]`) applies its conventions automatically by file path, *regardless of which directory the file lives in*. This is exactly what cross-cutting concerns like test conventions need: tests scattered across the tree are matched by one pattern. Generalize: when a convention is defined by **what a file is** (extension/glob) rather than **where it lives** (directory), reach for a path-scoped rule in `.claude/rules/`. It is deterministic (matches on path, no inference), it loads only on matching files (less noise, fewer tokens than dumping everything in `CLAUDE.md`), and it is centrally maintained in one file instead of duplicated per directory.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — a separate `CLAUDE.md` in each subdirectory.** It is seductive because per-directory `CLAUDE.md` files *are* path-aware: they load based on where a file lives, which feels like the "automatic by location" behavior the scenario asks for. The tell that exposes it: directory `CLAUDE.md` files are **directory-bound** — they only cover files in or under that one folder, so tests scattered across dozens of directories would each need a `CLAUDE.md` carrying the same duplicated test rules. The correct move keys the convention to **what a file is** (the `**/*.test.tsx` glob) rather than **where it lives**, collapsing that duplication into a single rule file. The trap is reaching for location-bound global instructions when the convention is actually cross-cutting and belongs in a path-scoped rule.

## 6. Distractor analysis — look-alikes to watch for
- **B (root `CLAUDE.md` with headers):** Plausible because all conventions *are* present — but Claude must *infer* which header applies to the file at hand. Inference is unreliable and the whole block sits in context every session, wasting tokens. No path guarantee.
- **C (skills per code type):** Tempting because a `SKILL.md` can hold conventions — but skills load on **manual invocation or when Claude judges them relevant**, not deterministically by file path. That contradicts "automatically applies… by path."
- **D (per-directory `CLAUDE.md`):** Closest trap. Directory `CLAUDE.md` files *are* path-aware, but they are **directory-bound** — they only cover files in/under that folder. Tests spread across dozens of directories would need a `CLAUDE.md` (with duplicated test rules) in every one. Glob rules collapse that to a single `**/*.test.tsx` file.

## 7. Key takeaways
- `.claude/rules/*.md` + `paths:` glob frontmatter = conventions that load **only when editing matching files** → less irrelevant context, fewer tokens.
- Glob rules beat directory-level `CLAUDE.md` for conventions that **span multiple directories**; `**/*.test.tsx` matches every test file wherever it lives.
- A rule **without** a `paths:` key loads unconditionally (like `.claude/CLAUDE.md`); with `paths:`, it is conditional.
- Skills load on invocation/relevance (not path-deterministic); root `CLAUDE.md` relies on inference; per-dir `CLAUDE.md` is location-bound — none give automatic, path-driven application like glob rules.
- Mental rule of thumb: convention keyed by *file type* → path-scoped rule; convention keyed by *location* → directory `CLAUDE.md`; always-on project standard → root/`@`-imported `CLAUDE.md`.

## 8. Official documentation
- Memory — *Organize rules with `.claude/rules/`* and *Path-specific rules* (`paths:` glob frontmatter, `**/*.ts`/`*.tsx` examples): https://code.claude.com/docs/en/memory
- Settings — `.claude/` project layout and `settings.json` scopes: https://code.claude.com/docs/en/settings
