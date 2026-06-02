# Session state: `--resume`, `fork_session`, and fresh-vs-stale recovery

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.7 (session state, resumption, forking)
> **Scenario:** Developer Productivity with Claude · **Study area:** Session state — `--resume`, `fork_session`, fresh-vs-stale
> **Trap level:** 🟡 Medium — three plausible "continue the session" options, but each hides a stale-context flaw
> **Trap archetype:** Resume vs. fork session state
> **Source:** Concept note grounded in the official exam guide, Task 1.7.

## 1. Topic — what this really tests

Resuming a session replays the prior conversation history: the prompt, every tool call, and — critically — every cached tool *result* (file reads, greps, command output). That is exactly what you want when prior context is *mostly still valid*, because the agent keeps everything it already learned. But after substantial code changes, those cached reads become **stale**: the agent reasons over a snapshot that no longer matches disk. This task tests the judgment to choose between (a) **resuming** when context is good, (b) **resuming but explicitly informing the agent which files changed** so it does *targeted* re-analysis, and (c) **starting fresh with a structured summary** when the cached results are too stale to trust. It also tests not mistaking `fork_session` — a divergent-exploration tool — for a stale-context recovery tool.

## 2. Question

> You ran a named investigation session two days ago that read and analyzed ~15 files across the `payments/` module. Since then, a teammate merged a large refactor that renamed functions and moved several of those files. You want to continue the investigation. Which approach is the most reliable?
>
> - **A.** Start a fresh session and seed it with a structured summary of the prior findings (key decisions + open questions), letting the agent re-read the current files from disk.
> - **B.** Run `--resume <session-name>` and immediately ask a follow-up, trusting the agent's cached file reads from two days ago.
> - **C.** Use `fork_session` on the prior session to branch the stale analysis into a new session before asking the follow-up.
> - **D.** Run `--resume <session-name>` but make no mention of the refactor, since the agent will automatically detect that disk has changed.

## 3. Answer options

- **A.** ✅ **Correct**
- **B.** Resumes with stale tool results. — ⚠️ **Most common wrong answer**
- **C.** Forks the staleness instead of fixing it.
- **D.** Assumes auto-detection that does not happen.

## 4. Correct answer — A

After a large refactor, the session's cached tool results describe code that no longer exists, and the agent has no built-in mechanism to notice that disk diverged from its replayed history. Starting fresh and **injecting a structured summary** (what was concluded, what remains open) gives the agent durable, accurate context while forcing it to re-read the *current* files — eliminating the stale-snapshot risk entirely. The general principle: when prior **tool results** are stale, prefer a fresh session seeded with distilled *conclusions* over resuming raw, outdated context. (A close second, valid for smaller changes, is to resume and explicitly name the changed files for *targeted* re-analysis — far cheaper than full re-exploration. Here the refactor is large enough that fresh-with-summary is the more reliable call.)

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **B — "`--resume` the session and just ask the follow-up, trusting the cached reads."** It is seductive because resumption *is* the purpose-built tool for continuing prior work, and reusing two days of analysis feels efficient — why re-read 15 files you already understand? The tell that it's wrong: a resumed session replays the *cached tool results* verbatim, so after a large refactor the agent confidently reasons over renamed and moved files it thinks still exist, with no mechanism to notice disk has diverged. The correct move recognizes that the value of resuming is the cached context, and once that context is stale the tool's advantage becomes its liability — so start fresh and seed distilled *conclusions* instead. This is the resume-vs-fork-vs-fresh trap: matching the recovery mechanism to whether the cached state is still authoritative, not to which option sounds like "continue."

## 6. Distractor analysis — look-alikes to watch for

- **B — resume + trust cache.** The trap: resumption *is* the right tool when context is mostly valid, but here the cache is stale. Resuming blindly makes the agent reason over renamed/moved files it thinks still exist.
- **C — `fork_session`.** Right tool, wrong problem. Forking is for **divergent exploration** from a shared, *valid* baseline (e.g., compare two refactoring or testing strategies in parallel). Forking a stale session just copies the staleness into a new branch — it never refreshes anything.
- **D — resume + assume auto-detection.** Plausible-sounding but false: the SDK replays stored history; it does not diff disk against cached reads. The changed files must be named explicitly to a resumed session, or start fresh.

## 7. Key takeaways

- **Resume** = `--resume <session-name>` (named) — best when prior context is *mostly valid*.
- **Stale tool results** → start fresh with a **structured summary**; injecting distilled conclusions beats replaying outdated reads.
- **Lighter fix:** resume, then **name the specific changed files** so the agent does *targeted* re-analysis instead of full re-exploration.
- **`fork_session`** = parallel **divergent** branches from a *good* shared baseline (two strategies), never a stale-context recovery tool.
- Resumption does **not** auto-detect on-disk changes — the human must inform the agent.

## 8. Official documentation

- Agent SDK — Work with sessions (continue / resume / fork, fresh-vs-resume guidance): https://code.claude.com/docs/en/agent-sdk/sessions
- Agent SDK — Overview (Sessions capability): https://code.claude.com/docs/en/agent-sdk/overview
- Claude Code — Common workflows (Resume previous conversations): https://code.claude.com/docs/en/common-workflows
