# Project-scoped slash commands live in the repo's `.claude/commands/`

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.2 (custom slash commands & skills)
> **Scenario:** Code Generation with Claude Code · **Study area:** Custom slash commands — project vs user scope
> **Trap level:** 🟡 Medium — the real-location distractor sits at the wrong scope, easy to miss
> **Trap archetype:** Real location, wrong scope
> **Source:** Official Claude Certified Architect exam guide — Sample Question 4.

## 1. Topic — what this really tests

The decision of *where* a custom slash command lives is a distribution choice, not just a file-placement detail. Claude Code resolves commands from two scopes: a **project** scope checked into the repo (`.claude/commands/`) and a **personal/user** scope under the developer's home (`~/.claude/`). Designing an agentic dev workflow that the whole team inherits — e.g. a standardized `/review` checklist — means putting the definition where version control carries it to every clone and pull. Picking the wrong scope produces a command that works on one machine but silently doesn't exist for teammates.

## 2. Question

> You want to create a custom `/review` slash command that runs your team's standard code review checklist. This command should be available to every developer when they clone or pull the repository. Where should you create this command file?
>
> **A)** In the `.claude/commands/` directory in the project repository
> **B)** In `~/.claude/commands/` in each developer's home directory
> **C)** In the `CLAUDE.md` file at the project root
> **D)** In a `.claude/config.json` file with a `commands` array

## 3. Answer options

- **A.** `.claude/commands/` in the project repo — ✅ **Correct**
- **B.** `~/.claude/commands/` in each developer's home directory — ⚠️ **Most common wrong answer**
- **C.** Inside the project-root `CLAUDE.md`
- **D.** A `.claude/config.json` with a `commands` array

## 4. Correct answer — A

Project-scoped custom slash commands live in `.claude/commands/` inside the repository. Because that directory is committed to version control, every developer who clones or pulls gets the command automatically — no per-machine setup. A file `.claude/commands/review.md` becomes `/review` for everyone on the project. The general principle: **scope follows audience.** Anything the team must share goes in the repo's `.claude/` (project scope); anything personal stays in `~/.claude/` (user scope). Note that Claude Code has since merged custom commands into Skills (`.claude/skills/<name>/SKILL.md`), but `.claude/commands/*.md` files still create slash commands and remain the correct project-scoped answer.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **B — `~/.claude/commands/` in each developer's home directory.** It is seductive because it names a *real* command location that genuinely works: a file there does register a slash command, so the surface logic ("commands live under `.claude/commands/`") feels satisfied. The tell that exposes it: `~/.claude/` is the *personal/user* scope, never committed to version control, so a command placed there exists only on one machine and teammates never receive it on clone or pull — directly violating the requirement that every developer inherit it. The correct move keys on the audience: team-shared commands belong in the repo's `.claude/commands/` (project scope), which travels with the codebase. This is the **real location, wrong scope** trap — the file path is plausible, but the scope mismatches the audience.

## 6. Distractor analysis — look-alikes to watch for

- **A.** Correct — repo-tracked project scope, shared on clone/pull.
- **B.** Real location, **wrong scope** — `~/.claude/` is *personal*, not version-controlled, so teammates never receive it; the most tempting trap.
- **C.** `CLAUDE.md` carries project *instructions/context*, not invokable command definitions — it cannot register a `/review` command.
- **D.** Plausible-sounding but fabricated — Claude Code has no `.claude/config.json` with a `commands` array; commands are file-per-command, not a JSON registry.

## 7. Key takeaways

- **Scope follows audience:** team-shared → `.claude/commands/` (repo); personal → `~/.claude/`.
- Project scope is shared precisely because `.claude/` is committed to version control and travels with clone/pull.
- A command is a Markdown file; the filename (sans `.md`) becomes the command name (`review.md` → `/review`).
- `CLAUDE.md` = always-on project context/instructions, not command definitions — different mechanism.
- Custom commands are now subsumed by Skills (`SKILL.md`, with frontmatter like `context: fork`, `allowed-tools`, `argument-hint`); legacy `.claude/commands/*.md` still works.

## 8. Official documentation

- Custom commands & skills (scope table: project `.claude/` vs personal `~/.claude/`, `argument-hint`, `allowed-tools`): <https://code.claude.com/docs/en/skills>
- Common workflows (project-level slash commands in dev workflows): <https://code.claude.com/docs/en/common-workflows>
