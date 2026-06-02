---
name: quiz-me
description: Generates and administers fresh, exam-style multiple-choice questions for the Claude Certified Architect – Foundations cert, one at a time, retrieval-first, then grades each with elaborated, doc-cited feedback. Use when the user says "quiz me", "test me", "practice questions on X", "drill <domain/topic>", "give me a question about X", or asks for a quick drill on a domain/scenario/concept/`due`/`weak`. Skip when the user wants to be TAUGHT a concept (use exam-tutor) or wants a full timed, scaled-score simulation (use mock-exam).
allowed-tools: Read, Write, WebFetch
argument-hint: [domain | scenario | concept | due | weak] [count]
---

# quiz-me

The question-generation + grading engine for the **Claude Certified Architect – Foundations** exam. It authors NEW scenario-based MCQs (1 correct + 3 distinct-archetype distractors) grounded in the local study notes, presents them one at a time (answer required before reveal), grades each with doc-cited rationale, and records the attempt via [[progress-tracker]]. This is the reusable testing engine that [[exam-tutor]] calls for its quiz phase. For the full weighted, timed, scaled-score run use [[mock-exam]]; for quick drills use this.

## Quick start

- `/quiz-me` — default: pull `due`/`weak` items via [[progress-tracker]] + 🔴 High-trap items from `exam-notes/INDEX.md`; 5 questions.
- `/quiz-me D2 8` — 8-question quick drill on Domain 2 (Tool Design & MCP Integration).
- `/quiz-me "prompt caching"` — single-concept drill on a topic/concept.
- `/quiz-me "Customer Support Resolution Agent"` — scenario-anchored drill.
- `/quiz-me due` / `/quiz-me weak` — only items due for review / lowest recall-quality.

Default count is 5; cap at 10 (this is a drill, not a mock exam). If no count given, use 5.

## Domains (for `D#` targets)

- **D1** Agentic Architecture & Orchestration (27%)
- **D2** Tool Design & MCP Integration (18%)
- **D3** Claude Code Configuration & Workflows (20%)
- **D4** Prompt Engineering & Structured Output (20%)
- **D5** Context Management & Reliability (15%)

## Workflow

1. **Resolve the target** from `$ARGUMENTS`:
   - A domain code (`D1`–`D5`) → quiz that domain.
   - A scenario name (one of the 6 in `exam-notes/00-EXAM-GUIDE.md`) → anchor every question in that scenario.
   - A concept/topic string → quiz that concept.
   - `due` → items whose review is due per [[progress-tracker]] (`exam-notes/progress.json`).
   - `weak` → items with the lowest recorded recall-quality per [[progress-tracker]].
   - No argument → merge `due` + `weak` from [[progress-tracker]] with 🔴 High-trap items in `exam-notes/INDEX.md`. Read `exam-notes/INDEX.md` to map the target to its source note(s) in `common-mistakes/`.
2. **Author a fresh question** per item (do this question-by-question, not all up front):
   - Read the source note(s) in `exam-notes/common-mistakes/` (all case notes are named `dN-<slug>.md`) plus `exam-notes/00-EXAM-GUIDE.md` for the concept under test. Note format is 8 sections (§5 = "Common mistake — the trap most people fall for"); canonical example `exam-notes/common-mistakes/d5-escalation-policy-ambiguity.md`.
   - Write a NEW scenario-based stem testing the SAME concept. **Never copy a parsed question verbatim** — invent a different scenario (different company, data, constraints).
   - Produce exactly 4 options: 1 correct key + 3 distractors, each from a **DISTINCT** archetype (see `reference.md` for the catalog: common-misconception, right-idea-wrong-scope, true-but-irrelevant, over-engineered, under-engineered, symptom-not-root-cause).
   - Make traps convincing: reuse the source note's *Distractor analysis* (§6) and *Common mistake* (§5, the most-commonly-chosen wrong answer), plus the user's own miss-history from [[progress-tracker]] when present.
   - Keep all 4 options the same length/grammatical form; avoid absolutes ("always"/"never").
3. **Present the question ONLY** (stem + A–D). Do not reveal the answer, archetypes, or rationale. Wait for the user's letter choice (retrieval-first).
4. **Grade** after they answer:
   - State **Correct** or **Incorrect**.
   - If wrong: name the chosen distractor's **archetype** and explain why it fails *in this specific scenario*.
   - Explain why the key is correct.
   - Cite **≥1 official doc URL** mapped to the domain (see Citation contract).
   - Then move to the next question (repeat steps 2–4).
5. **Record the attempt** to `exam-notes/progress.json` via [[progress-tracker]] — pass the concept/domain, correct/incorrect, and a recall-quality grade (0–5). Do not hand-write the full schema; summarize and let [[progress-tracker]] own it. (Link: [[progress-tracker]].)
6. **Batch summary** (2 lines): score (e.g. `6/8`) and which concepts to re-queue (the ones missed or graded low recall-quality).

## Modes

- **Quick drill** — `/quiz-me D2 8`: N questions across a domain, interleave its task statements (e.g. 2.1–2.x).
- **Single concept** — `/quiz-me "MCP server scope"`: all questions hit one concept from varied angles.
- **Mixed / interleaved** — `/quiz-me` (no arg) or `/quiz-me mixed`: rotate across `due`/`weak`/🔴 items and across domains to force discrimination.

## When NOT to use

- The user wants to **learn/understand** a concept, not be tested → use [[exam-tutor]] (quiz-first) or [[deep-teach]] (teach-first: plain-language theory + everyday analogies → the user's own mistakes → a 🚩 trap-detector cheat-sheet).
- The user wants a **full, timed, weighted simulation with a scaled 100–1000 score** (pass = 720) → use [[mock-exam]]. This skill does quick ungraded-by-scale drills.
- The user wants to **edit notes, the index, or progress data directly** → that's owned by the relevant notes/[[progress-tracker]] workflow, not quiz generation.

## Output / citation contract

- Present one question at a time; never reveal before the user answers.
- Every graded answer cites at least one **official** URL. Prefer the source note's *Official documentation* section; otherwise pick by domain:
  - **D1** https://www.anthropic.com/engineering/building-effective-agents · https://code.claude.com/docs/en/agent-sdk/overview · https://code.claude.com/docs/en/sub-agents · https://platform.claude.com/docs/en/build-with-claude/tool-use/overview
  - **D2** https://www.anthropic.com/engineering/writing-tools-for-agents · https://modelcontextprotocol.io/docs/getting-started/intro · https://code.claude.com/docs/en/mcp
  - **D3** https://code.claude.com/docs/en/memory · https://code.claude.com/docs/en/settings · https://code.claude.com/docs/en/slash-commands · https://code.claude.com/docs/en/skills · https://code.claude.com/docs/en/permission-modes
  - **D4** https://platform.claude.com/docs/en/build-with-claude/structured-outputs · https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/multishot-prompting · https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
  - **D5** https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/long-context-tips · https://platform.claude.com/docs/en/build-with-claude/prompt-caching · https://platform.claude.com/docs/en/build-with-claude/context-windows · https://code.claude.com/docs/en/costs
- Use `WebFetch` only to confirm a URL/claim when a note is missing its citation; do not browse for question content (generate from local notes).
- Quote no parsed question verbatim; each generated question must be a fresh scenario.

## Example (one turn)

Target resolved: `D2`, count 1. Source note concept: *MCP server config scope*.

> **Q1 (D2 · Tool Design & MCP).** A fintech team wants a Postgres MCP server available to every engineer on the `payments` repo, version-controlled and code-reviewed, but NOT shared to their personal machines globally. Which configuration approach fits best?
> A. Add it to the project's checked-in `.mcp.json` at the repo root.
> B. Add it with user scope so it loads in every project on each machine.
> C. Add it to local project settings so only the current user sees it untracked.
> D. Define it as a slash command that shells out to `psql` on demand.

*(Wait for the user's letter — reveal nothing yet.)*

User answers **B**.

> **Incorrect.** B is *right-idea-wrong-scope*: user scope does make the server reusable, but it installs to every project on that one machine and is NOT version-controlled or shared across the team — the opposite of the "shared via the repo, reviewed" requirement. **A is correct:** a checked-in project-scope `.mcp.json` ships the server with the repo so every engineer who clones it gets the reviewed config, and nothing leaks to unrelated projects. (C is local-untracked = invisible to teammates; D abandons MCP for an ad-hoc command and loses the tool contract.)
> Docs: https://code.claude.com/docs/en/mcp

Then record via [[progress-tracker]] (concept: MCP server scope; result: incorrect; recall-quality: 2) and continue to Q2. After the batch: `Score 0/1. Re-queue: MCP server scope.`

## Reference

Full distractor-archetype catalog (definitions + how to detect each) and a bank of sample generated questions per domain live in `reference.md` (same directory).
