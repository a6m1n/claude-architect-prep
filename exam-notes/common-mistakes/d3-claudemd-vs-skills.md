# CLAUDE.md vs Skills — always-on standards vs. on-demand task workflows

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.2 (choosing between skills and CLAUDE.md)
> **Scenario:** Code Generation with Claude Code · **Study area:** CLAUDE.md vs Skills (CLAUDE.md scope)
> **Trap level:** 🔴 High — "shrink CLAUDE.md to a stub" feels like the cleanest refactor
> **Trap archetype:** Always-on context vs. on-demand procedure
> **Source:** Claude Certified Architect practice exam, Q1 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question is about **context budget allocation** between two memory mechanisms with different load semantics. `CLAUDE.md` is injected into *every* conversation at launch, so its contents are always-on and cost context tokens on every turn — that is the right home for universal, unconditional guidance. Skills load *on-demand*, surfaced by trigger keywords only when a relevant task is underway, so they are the right home for episodic, multi-step procedures. The architectural skill is matching each piece of guidance to its activation pattern: standards that must apply everywhere vs. workflows that apply only sometimes. Getting this wrong either bloats every conversation with irrelevant procedure or strips out standards that should never be optional.

## 2. Question
> Your CLAUDE.md file has grown to over 400 lines containing coding standards, testing conventions, a detailed PR review checklist, deployment workflow instructions, and database migration procedures. You want Claude to always follow the coding standards and testing conventions, but only apply PR review, deployment, and migration guidance when you're actually performing those tasks. What's the most effective restructuring approach?

## 3. Answer options
- **A.** Move all guidance to separate Skills files organized by workflow type, keeping only a brief project description in CLAUDE.md — ⚠️ **Most common wrong answer**
- **B.** Keep universal standards in CLAUDE.md and create Skills for task-specific workflows (PR reviews, deployments, migrations) with trigger keywords — ✅ **Correct**
- **C.** Split the CLAUDE.md file into .claude/rules/ with path-specific glob patterns so each rule loads only for matching file types
- **D.** Keep all content in CLAUDE.md but use `@import` syntax to organize it into separately maintained files by category

## 4. Correct answer — B
**Keep universal standards in CLAUDE.md and create Skills for task-specific workflows (PR reviews, deployments, migrations) with trigger keywords**

This is the most effective approach because CLAUDE.md content is loaded for every conversation, ensuring coding standards and testing conventions are always applied, while Skills are invoked on-demand when relevant, making them ideal for task-specific workflows like PR reviews, deployments, and migrations. The transferable principle: classify guidance by *when it must be active*. Always-on, unconditional standards belong in always-loaded memory (`CLAUDE.md`); conditional, task-scoped procedures belong in on-demand Skills gated by trigger keywords. This split keeps the baseline context lean while still making deep workflow detail available exactly when the matching task fires.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **A — "move all guidance into Skills files, leaving only a brief project description in CLAUDE.md."** It is seductive because the stated problem is a bloated 400-line CLAUDE.md, so emptying it to a stub looks like the most decisive cleanup. The tell that it's wrong: doing so demotes the always-needed coding standards and testing conventions to on-demand Skills, so they stop loading by default and Claude can silently generate code that ignores the conventions whenever the relevant Skill fails to trigger. The instinct to "just make CLAUDE.md as small as possible" treats the size as the goal rather than asking *when each piece must be active*. The correct move splits by activation pattern — keep universal standards always-on in `CLAUDE.md`, push only the conditional, task-scoped workflows into keyword-triggered Skills.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because it maximally shrinks `CLAUDE.md`, but it wrongly demotes always-needed standards to on-demand Skills, so conventions stop loading by default.
- **B.** Correct — universal standards stay always-on in `CLAUDE.md`; task workflows become keyword-triggered Skills.
- **C.** Path/glob globbing fires on *file types touched*, not on the *activity* you are doing — wrong trigger semantics for task-level workflows like deploys or migrations.
- **D.** `@import` reorganizes the files for maintainability but everything is still inlined at launch, so there is no on-demand loading and no context savings.

## 7. Key takeaways
- `CLAUDE.md` is loaded into every session — reserve it for universal, always-applicable standards (coding style, testing conventions).
- Skills load on-demand via trigger keywords — use them for multi-step, task-scoped workflows (PR review, deployment, migration).
- Classify each piece of guidance by *when it must be active*, not just by topic; this decides whether it goes in always-on memory or on-demand Skills.
- Reorganizing files (`@import`) or path-glob rules does not change load timing for task activities — only the always-on vs. on-demand split actually saves baseline context.

## 8. Official documentation
- [CLAUDE.md / memory](https://code.claude.com/docs/en/memory)
- [Skills](https://code.claude.com/docs/en/skills)
- [Common workflows](https://code.claude.com/docs/en/common-workflows)
