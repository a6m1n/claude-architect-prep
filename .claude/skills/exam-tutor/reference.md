# Exam Tutor — Reference

Supporting detail for [[exam-tutor]]. The SKILL.md body is the operating procedure; this file holds the longer material it points to. Schedule/readiness math is **owned by [[progress-tracker]]** and summarized here only for context — that skill is the source of truth.

## Table of contents
1. [Full session loop](#1-full-session-loop)
2. [Queue-building heuristics](#2-queue-building-heuristics)
3. [Distractor-archetype table](#3-distractor-archetype-table)
4. [Per-domain official doc map](#4-per-domain-official-doc-map)
5. [Readiness & scheduling math (summary)](#5-readiness--scheduling-math-summary)
6. [Worked transcript (two concepts)](#6-worked-transcript-two-concepts)

---

## 1. Full session loop

```
read INDEX.md + progress.json  →  [progress-tracker] readiness score, gap to 720
resolve argument  →  build interleaved spaced queue (§2)
for each concept in queue:
    TEACH principle (generalized, cited doc)          # SKILL step 3
    QUIZ one fresh MCQ (conventions from [quiz-me])   # SKILL step 4
    WAIT for the user's answer (retrieval-first)      # SKILL step 5
    FEEDBACK: name archetype, why it fails here,       # SKILL step 6
              why correct wins, cite a doc
    UPDATE via [progress-tracker]: attempt + SM-2 grade + reschedule
    if miss: brief re-teach, re-queue later in session
until queue empty OR time budget hit
recompute readiness  →  show before→after delta
name weakest high-weight domain (max weightᵈ·(1−masteryᵈ))
state what is due next session
```

**Time-budget variant.** If the user gives a time box (e.g. "20 minutes"), estimate ~3–4 minutes per teach-then-test concept and cap the queue length accordingly; always reserve time for the closing readiness summary.

**Modes.** Full mode runs all steps. `teach-only` runs read → teach (steps 1, 3) and skips quiz/feedback/progress-update.

---

## 2. Queue-building heuristics

Build the queue from three buckets, then interleave:

| Bucket | Selection rule | Typical share |
|--------|----------------|---------------|
| **Due** | `next_due ≤ today` (overdue first) | ~60% |
| **New** | concepts with `attempts == 0`, picked by domain priority | ~25% |
| **Warm-keepers** | recently mastered (`box`/`reps` high) kept for retention | ~15% |

**Priority weighting.** Within and across buckets, rank concepts by `priority = weightᵈ · (1 − concept_mastery)`, where `weightᵈ` is the domain weight (D1 .27, D3 .20, D4 .20, D2 .18, D5 .15). This pushes effort toward concepts that are both weak and heavily tested.

**Extra biases (apply after the base ranking):**
- Boost 🔴 High-trap items (and the user's own previously-missed items from [[progress-tracker]]).
- Boost the two historically under-sampled scenarios — **Developer Productivity** and **Structured Data Extraction**; teach these from `exam-notes/00-EXAM-GUIDE.md` and the case notes in `exam-notes/common-mistakes/` (all named `dN-<slug>.md`, e.g. `d3-claudemd-hierarchy.md`).
- Keep a spread across all 5 domains so the session is representative of the real 4-of-6-scenario exam.

**Interleaving (the shuffle).** After ranking, reorder so **no two consecutive concepts share a domain**. Interleaving > blocking for durable recall; do not drill one domain back-to-back even if it is weakest.

**Re-queue on miss.** A missed concept goes back into the queue ~2–3 items later (not immediately — spacing within the session aids consolidation), unless the time budget is nearly spent.

---

## 3. Distractor-archetype table

Every quiz MCQ has 1 correct option + 3 distractors drawn from these archetypes. Naming the archetype in feedback (SKILL step 6) is what makes the miss instructive. ([[quiz-me]] owns full question construction; this table is the shared vocabulary; [[teaching-method]] is the authoritative source for *why* these archetypes boost recall and how they map to growth-framed feedback.)

| Archetype | What it looks like | Why a test-taker falls for it |
|-----------|--------------------|-------------------------------|
| **common-misconception** | A widely-believed-but-wrong "fact" | Matches prior (incorrect) intuition |
| **right-idea-wrong-scope** | Correct mechanism applied at the wrong layer/agent/breadth | The concept is real, just misapplied |
| **true-but-irrelevant** | A true statement that doesn't answer *this* question | Truthiness feels safe |
| **over-engineered** | A heavier solution than the problem needs | "More controls = safer" bias |
| **under-engineered** | Too thin; ignores a required guardrail/edge case | "Simpler = better" bias |
| **symptom-not-root-cause** | Treats the symptom (e.g. tweak the prompt) instead of the root cause (e.g. fix the tool contract / decomposition) | Quick fix is salient |

When grading a wrong answer, map the chosen option to one archetype, explain why it fails **in that specific scenario**, then contrast with why the correct option wins. Frame as a trap to recognize next time, not as a personal failing.

---

## 4. Per-domain official doc map

Cite from these per domain. `docs.claude.com` redirects to the canonical hosts below — prefer the canonical URLs. Verify resolution with WebFetch before citing if unsure. Highest authority overall: Anthropic's official exam guide (distilled in `exam-notes/00-EXAM-GUIDE.md`).

**D1 — Agentic Architecture & Orchestration (27%)**
- https://code.claude.com/docs/en/agent-sdk/overview
- https://code.claude.com/docs/en/agent-sdk/subagents · https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/hooks · https://code.claude.com/docs/en/agent-sdk/sessions
- https://platform.claude.com/docs/en/build-with-claude/tool-use/overview
- https://www.anthropic.com/engineering/building-effective-agents

**D2 — Tool Design & MCP Integration (18%)**
- https://www.anthropic.com/engineering/writing-tools-for-agents
- https://platform.claude.com/docs/en/build-with-claude/tool-use/implement-tool-use
- https://modelcontextprotocol.io/docs/getting-started/intro · https://code.claude.com/docs/en/mcp
- https://modelcontextprotocol.io/specification/2025-06-18/server/tools

**D3 — Claude Code Configuration & Workflows (20%)**
- https://code.claude.com/docs/en/memory · https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/slash-commands · https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/permission-modes (plan mode)
- https://code.claude.com/docs/en/headless (-p, --output-format json, --json-schema) · https://code.claude.com/docs/en/cli-reference

**D4 — Prompt Engineering & Structured Output (20%)**
- https://platform.claude.com/docs/en/build-with-claude/structured-outputs
- https://platform.claude.com/docs/en/build-with-claude/tool-use/implement-tool-use
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/multishot-prompting
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview

**D5 — Context Management & Reliability (15%)**
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/long-context-tips
- https://platform.claude.com/docs/en/build-with-claude/batch-processing
- https://platform.claude.com/docs/en/build-with-claude/prompt-caching
- https://platform.claude.com/docs/en/build-with-claude/context-windows
- https://code.claude.com/docs/en/costs (/compact)

---

## 5. Readiness & scheduling math (summary)

**Authoritative implementation lives in [[progress-tracker]].** Reproduced here only so the tutor can narrate scores; do not fork the logic.

Per-concept record (minimal shape):
```json
{"id":"", "domain":"D1", "scenario":"", "note":"", "attempts":0, "correct":0,
 "incorrect":0, "last_seen":"", "box":0, "ef":2.5, "reps":0, "interval":0,
 "last_quality":0, "next_due":""}
```

**Spaced repetition (SM-2).** Grade recall `q ∈ 0..5`.
- If `q < 3`: `reps = 0`, `interval = 1` (failed — review tomorrow).
- Else: `interval` progresses `1 → 6 → round(interval · EF)`; `reps += 1`.
- `EF += 0.1 − (5 − q)·(0.08 + (5 − q)·0.02)`, floored at `1.3`.
- `next_due = last_seen + interval` days.

**Readiness.**
- `concept_mastery = (correct + 1) / (attempts + 2)` (Laplace-smoothed).
- `domain_mastery = mean(concept_mastery)` over that domain's concepts.
- `overall = Σ weightᵈ · domain_masteryᵈ`.
- `scaled = round(100 + overall · 900)` → ready when `scaled ≥ 720`.
- **Prioritize domains** by `weightᵈ · (1 − domain_masteryᵈ)` (also drives §2 queueing). The weakest high-weight domain reported at session close is the `argmax` of this quantity.

---

## 6. Worked transcript (two concepts)

Illustrates interleaving (D5 then D1), retrieval-first, archetype-named feedback, and progress updates.

**Open.** "Read INDEX.md + progress.json. Readiness **685/1000**, gap **−35** to 720. Weakest high-weight domain: **D1 (27%, mastery .58)**. Queue (interleaved): [D5 long-context] → [D1 error-propagation] → [D3 plan-mode] → … Today's bias: your 🔴 items + D1."

**Concept 1 — D5, long-context position bias ("lost in the middle").**
- *Teach:* Models attend least to the middle of a long context, so critical facts buried mid-prompt get dropped. Counter it: put durable, decision-relevant facts at the **top** (and optionally restate at the bottom), add section headers, and summarize before the long body. Generalizes to any retrieval/multi-doc agent. Source: [Long context tips](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/long-context-tips).
- *Quiz (answer first):* You're stuffing 40 retrieved support tickets into one prompt; the key SLA clause is in ticket #20 and the model keeps ignoring it. Best fix? (A) lower temperature (B) move the SLA clause into a summary block at the top of the prompt (C) add "please read carefully" (D) switch to a smaller model.
- *[user picks A]*
- *Feedback:* A is **symptom-not-root-cause** — temperature controls sampling randomness, not positional attention, so the buried clause is still buried. (C is **common-misconception**: politeness doesn't move attention.) **B wins**: front-loading the durable fact defeats the middle-of-context blind spot. Source: [Long context tips](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/long-context-tips).
- *Update via [[progress-tracker]]:* incorrect; `q=2` → `reps=0`, `interval=1`; re-queue ~3 items later.

**Concept 2 — D1, error propagation (different domain → interleaved).**
- *Teach:* In hub-and-spoke multi-agent systems, a subagent should handle recoverable errors locally and escalate the rest **with context**, preserving the failure-vs-empty distinction so the coordinator can decide (retry, annotate coverage, or degrade gracefully) rather than silently swallow gaps. Source: [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents).
- *Quiz (answer first):* A subagent can't reach a data source. It returns `[]` (empty results) to the coordinator. What's the architectural flaw? (A) nothing, empty is fine (B) it conflates "access failed" with "no records exist," so the coordinator stops looking and the gap propagates silently (C) it should retry forever (D) it should crash the whole run.
- *[user picks B]* — correct.
- *Feedback:* Right — B preserves the semantic distinction; the coordinator needs a structured, retryable error, not a misleading empty set. (C is **over-engineered**/unbounded; D is **under-engineered**/brittle; A is **common-misconception**.) Source: [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents).
- *Update via [[progress-tracker]]:* correct; `q=4` → `reps=1`, `interval=6`, `EF` up.

**Close.** "Session done. Readiness **685 → 701** (Δ **+16**). Still short of 720; weakest high-weight domain remains **D1 (27%)** — error-propagation and tool-distribution concepts. **Due next:** the long-context concept (tomorrow, after the miss) plus 2 D3 plan-mode items. Want another round or a [[mock-exam]]?"
