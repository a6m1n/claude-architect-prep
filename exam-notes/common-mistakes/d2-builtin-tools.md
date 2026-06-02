# Choosing the right built-in tool & exploring incrementally

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.5 (built-in tools)
> **Scenario:** Developer Productivity with Claude · **Study area:** Built-in tools (Grep/Glob/Read/Write/Edit) selection
> **Trap level:** 🟡 Medium — every option uses a real tool, so each looks defensible until you check signal-to-noise
> **Trap archetype:** Right built-in tool for the job
> **Source:** Concept note grounded in the official exam guide, Task 2.5.

## 1. Topic — what this really tests

Match the built-in tool to the job. `Grep` searches file *contents* for patterns (function names, error strings, import statements); `Glob` matches file *paths* by name/extension (e.g. `**/*.test.tsx`); `Read`/`Write` do full-file load/replace; `Edit` makes targeted in-place edits anchored on *unique* text — when that anchor isn't unique, fall back to `Read` + `Write`. The deeper skill is *incremental* codebase understanding: start narrow with `Grep` to find entry points, then `Read` to follow imports and trace flows, rather than ingesting every file upfront and burning context.

## 2. Question

> You join a team and must understand a large, unfamiliar legacy codebase to add a feature touching its authentication flow. What is the most effective first move?
>
> - **A.** `Read` every source file in the repository up front so you have complete context before doing anything.
> - **B.** Use `Grep` to locate entry points and key symbols (e.g. the auth handler, callers of `validate_token`), then `Read` those files and follow their imports to trace the flow incrementally.
> - **C.** Use `Glob` alone to list all file paths and infer the architecture from filenames.
> - **D.** Run `Bash` `cat` on the whole `src/` tree and skim the concatenated output.

## 3. Answer options

- **A.** Read every file upfront.
- **B.** `Grep` for entry points, then `Read` and follow imports incrementally. — ✅ **Correct**
- **C.** `Glob` alone from filenames. — ⚠️ **Most common wrong answer**
- **D.** `Bash` `cat` everything.

## 4. Correct answer — B

`Grep` targets *content*, so it surfaces the exact entry points and symbol usages that matter (handlers, callers of a function, error messages) without reading unrelated code. From those anchors you `Read` selectively and follow imports to trace the real execution path. This incremental discovery preserves the context window and converges on the relevant subsystem instead of drowning in noise. General principle: pick the tool whose semantics match the question (content → `Grep`, paths → `Glob`, full file → `Read`/`Write`, surgical change → `Edit`), and explore on demand.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **C — "use `Glob` alone to list all file paths and infer the architecture from filenames."** It is seductive because `Glob` *is* the right lightweight, context-cheap discovery tool, and skimming a file tree feels like a sensible first orientation pass. The tell that exposes it: `Glob` matches *paths*, not *contents* — filenames alone cannot reveal how auth actually works, where `validate_token` is defined, or who calls it, so the architecture inference is a guess. The correct move keys on the right *semantics*: the question is about content and call flow, so it belongs to `Grep` (find the symbols) followed by selective `Read` (trace the imports). This is the recurring "right built-in tool for the job" trap — a plausible-but-wrong tool whose semantics don't match what the task is actually asking for.

## 6. Distractor analysis — look-alikes to watch for

- **A.** Reading everything upfront floods context, degrades performance, and most of it is irrelevant — the opposite of incremental exploration.
- **C.** `Glob` matches *paths*, not contents; filenames alone can't reveal how auth actually works or who calls what.
- **D.** `Bash` `cat` dumps raw content with no targeting — same context blowup as A, with worse signal-to-noise. Use `Grep` to find, then `Read` to inspect.

## 7. Key takeaways

- Content search → `Grep` (find all callers of a function, locate an error message, find imports). Path/name match → `Glob` (e.g. `**/*.test.tsx`).
- Targeted change → `Edit` on *unique* anchor text. When the anchor matches multiple places (non-unique), `Edit` fails — fall back to `Read` + `Write` for a reliable full-file modification.
- Explore incrementally: `Grep` for entry points → `Read` to follow imports/trace flows. Don't read the whole repo upfront.
- To trace usage across wrapper modules, first identify all exported names, then `Grep` each across the codebase.

## 8. Official documentation

- Common workflows (explore codebases, find code, trace flows): <https://code.claude.com/docs/en/common-workflows>
- Best practices (explore-first-then-plan, manage context aggressively): <https://code.claude.com/docs/en/best-practices>
