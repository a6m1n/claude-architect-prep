---
name: progress-tracker
description: >-
  Owns exam-notes/progress.json — the single source of truth for concept
  mastery, spaced-repetition scheduling (SM-2 + Leitner), and exam-readiness
  scoring for the Claude Certified Architect – Foundations cert. Use when the
  user asks "what should I study next", "track/update my progress", "record an
  attempt", "am I ready", "readiness score", or "initialize my study tracker",
  and when sibling skills [[exam-tutor]], [[quiz-me]], [[mock-exam]] need to read
  what's due or record results. Skip when the user only wants to study/quiz a
  topic without touching saved state, or for general (non-progress) questions.
allowed-tools: Read, Write
argument-hint: "[init | next | record | readiness]"
---

# progress-tracker

Authoritative state + scheduling + readiness for the **Claude Certified
Architect – Foundations** exam (60 MCQs, scaled 100–1000, **pass = 720**).

This skill owns `exam-notes/progress.json`. It is the **only** skill that may
write that file. Sibling skills read "what's due" and "readiness" from here and
hand attempts back here to be recorded:

- [[exam-tutor]] — teaches a concept (quiz-first), then calls `record`.
- [[deep-teach]] — teaches a concept **teach-first** (plain language + analogies + the user's mistakes), appends the distilled rule to `exam-notes/learned-rules.md`, then calls `record`.
- [[quiz-me]] — pulls the `next` queue, then calls `record` per answer.
- [[mock-exam]] — runs a full 60-Q sim, then bulk-`record`s and reads `readiness`.

The **full progress.json schema, the SM-2 + Leitner algorithms, and the
readiness math** live in [reference.md](reference.md) — that file is the
authoritative spec. SKILL.md is the workflow; consult reference.md for any
formula or field. The learning-science *why* behind spacing, the Leitner box
cadence, and Laplace-smoothed mastery is in [[teaching-method]] (§7 crosswalk).

## Quick start

| User says | Run command | Effect |
|---|---|---|
| "set up / initialize my tracker" | **init** | build progress.json from INDEX.md + gap topics |
| "what should I study next" | **next** | interleaved due queue across domains |
| "I got concept X right/wrong (q=4)" | **record** | update stats + reschedule |
| "am I ready / readiness score" | **readiness** | scaled score vs 720 + weak domains |

Parse `$ARGUMENTS` for the leading verb (`init`/`next`/`record`/`readiness`).
With no verb: if progress.json is missing → suggest `init`; else show
`readiness` then `next`.

Domains & weights (see reference.md for the canonical map — **Claude exam, not
AWS**): D1 Agentic Architecture & Orchestration 27% · D2 Tool Design & MCP
Integration 18% · D3 Claude Code Configuration & Workflows 20% · D4 Prompt
Engineering & Structured Output 20% · D5 Context Management & Reliability 15%.

## Workflow

Always `Read` `exam-notes/progress.json` before any read/compute, and again
right before `Write` so you never clobber concurrent updates. Use forward-slash
paths. Today's date = the harness `currentDate`.

### 1. init  (build the tracker)

Only if `exam-notes/progress.json` does **not** exist (if it does, refuse and
say it is already initialized unless the user says "reset").

1. `Read` `exam-notes/INDEX.md` — enumerate all 43 case notes in
   `common-mistakes/`. Each maps to one concept; capture its note file and its
   trap-level priority tag: 🔴 High-trap (→ `"red"`) · 🟡 Medium (→ `"green"`)
   · 🔵 gap-fill from the guide (→ `"blue"`). (Personal correct/incorrect history
   accrues later from attempts, not from the note.)
2. `Read` `exam-notes/00-EXAM-GUIDE.md` — add the coverage-gap topics it lists
   that aren't already covered (tag them 🔵, `gap: true`).
3. Assign each concept a `domain` (D1–D5) and `scenario` (one of the 6) from the
   guide. Make a stable kebab `id`: `<domain>-<short-slug>`
   (e.g. `D1-coordinator-hub-spoke`).
4. **Seed** box/EF from the tag (see reference.md §Initialization):
   - 🔴 → `box:1`, `ef:2.3`, `reps:0`, `interval:0`, `next_due` = today (study now).
   - 🟢 → `box:2` or `3`, `ef:2.6`, `reps:1`, `interval:6`, `next_due` = today+interval.
   - 🔵 gap → `box:1`, `ef:2.5`, `reps:0`, `next_due` = today, `gap:true`.
   All start `attempts:0, correct:0, incorrect:0, last_seen:null, last_quality:null`.
5. Build the top-level object (exam, pass_threshold 720, scale_max 1000, the
   `domains` map, the `concepts` array) per reference.md schema and `Write` it.
6. Report: # concepts, count per domain, and how many are due today.

### 2. record  (log an attempt + reschedule)

Inputs: `concept id`, `correct` (bool), recall-quality `q ∈ 0–5`
(5 perfect · 3 correct-but-hard · <3 fail). If only correct/incorrect is given,
default q=4 on correct, q=1 on incorrect.

1. `Read` progress.json; find the concept by `id`.
2. `attempts++`; if correct `correct++` else `incorrect++`; `last_seen = today`,
   `last_quality = q`.
3. **SM-2 reschedule** (reference.md §SM-2): update `ef`, `reps`, `interval`,
   set `next_due = today + interval`.
4. **Leitner box** (human-readable mastery tier): correct → up one box
   (max 5), wrong → box 1.
5. `Write` progress.json. Report new box, interval, next_due, and the updated
   per-concept mastery.

### 3. next  (study queue)

1. `Read` progress.json. Candidate set = concepts with `next_due ≤ today`
   (always include 🔵 gap topics even if seeded ahead).
2. Score each candidate by **priority = domain.weight · (1 − concept_mastery)**,
   with a boost for 🔴 items and for currently low-box concepts
   (see reference.md §Prioritization).
3. **Interleave** the sorted queue so no two consecutive items share a `domain`
   (round-robin across domains by descending domain priority).
4. Return an ordered list: `id · domain · scenario · note · box · mastery% ·
   why-now`. Cap at the count the caller requests (default 10).
5. For any concept that also has a block in `exam-notes/learned-rules.md`, add a
   `↻ re-read learned-rules` hint so the learner resurfaces the plain-language
   cheat-sheet at spaced intervals (the consolidation loop owned by [[deep-teach]]).

### 4. readiness  (scaled score + weak domains)

1. `Read` progress.json.
2. Per concept: `mastery = (correct+1)/(attempts+2)` (Laplace-smoothed;
   optionally × `min(1, box/4)`).
3. `domain_mastery` = mean of its concepts' mastery.
4. `overall = Σ weightᵈ · domain_masteryᵈ`; `scaled = round(100 + overall·900)`.
5. **ready if scaled ≥ 720** (recommend targeting ≥ 760 for margin).
6. Rank domains by **weight · (1 − domain_mastery)** = expected points
   recoverable; surface the top 2–3 as "focus here next".

## Output contract

- **init** → confirmation + counts (total / per-domain / due today). Writes file.
- **record** → one line per concept: `id → box B, q=Q, next_due=YYYY-MM-DD,
  mastery=NN%`. Writes file.
- **next** → numbered table: rank · id · domain · scenario · note · box ·
  mastery% · why-now. Read-only.
- **readiness** → `Scaled: NNN / 1000 (pass 720) — READY/NOT READY (Δ vs 720)`,
  then a per-domain table (weight · mastery% · recoverable pts), then ranked
  "focus" domains. Read-only.

All four cite reference.md as the formula source. `record`/`init` are the only
state-mutating commands.

## Example

```
> /progress-tracker readiness
Scaled: 681 / 1000  (pass 720) — NOT READY (−39)

Domain                                   Wt    Mastery  Recoverable
D1 Agentic Architecture & Orchestration  0.27    58%      0.113  ← focus
D4 Prompt Engineering & Structured Out.   0.20    62%      0.076  ← focus
D2 Tool Design & MCP Integration          0.18    66%      0.061
D3 Claude Code Config & Workflows         0.20    74%      0.052
D5 Context Management & Reliability       0.15    71%      0.044

Focus next (most points to gain): D1, then D4. Run `next` for the queue.
```

See [reference.md](reference.md) for the full schema, both scheduling
algorithms, the seeding table, and a fully worked numeric example.
