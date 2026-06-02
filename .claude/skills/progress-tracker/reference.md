# progress-tracker — reference (authoritative)

This file is the **authoritative spec** for the progress store and all math used
by the study skills. Where `SKILL.md` summarizes, this file governs. Sibling
skills [[exam-tutor]], [[quiz-me]], [[mock-exam]] must conform to the schema and
formulas here.

Exam: **Claude Certified Architect – Foundations** — 60 MCQs, scaled 100–1000,
**pass = 720** (target ≥ 760 for margin).

## Table of contents

1. [Domains & weights](#1-domains--weights)
2. [progress.json schema](#2-progressjson-schema)
3. [Initialization & seeding](#3-initialization--seeding)
4. [SM-2 spaced repetition](#4-sm-2-spaced-repetition)
5. [Leitner box fallback](#5-leitner-box-fallback)
6. [Mastery, readiness & scaled score](#6-mastery-readiness--scaled-score)
7. [Prioritization & the "next" queue](#7-prioritization--the-next-queue)
8. [Worked numeric example](#8-worked-numeric-example)
9. [Invariants & edge cases](#9-invariants--edge-cases)

---

## 1. Domains & weights

These are the **real Claude exam domains** (NOT AWS). Weights sum to 1.00.

| ID | Name | Weight |
|----|------|--------|
| D1 | Agentic Architecture & Orchestration | 0.27 |
| D2 | Tool Design & MCP Integration | 0.18 |
| D3 | Claude Code Configuration & Workflows | 0.20 |
| D4 | Prompt Engineering & Structured Output | 0.20 |
| D5 | Context Management & Reliability | 0.15 |

The 6 scenarios (the exam surfaces 4 of 6) — each concept is tagged with one:

- Customer Support Resolution Agent
- Code Generation with Claude Code
- Multi-Agent Research System
- Developer Productivity with Claude
- Claude Code for Continuous Integration
- Structured Data Extraction

---

## 2. progress.json schema

Path: `exam-notes/progress.json`. UTF-8 JSON. Dates are `YYYY-MM-DD` strings or
`null`. Do **not** create this file except via the `init` workflow.

### Top-level object

| Field | Type | Notes |
|-------|------|-------|
| `exam` | string | `"Claude Certified Architect – Foundations"` |
| `pass_threshold` | int | `720` |
| `scale_max` | int | `1000` |
| `scale_min` | int | `100` (implicit floor; scaled = 100 + overall·900) |
| `created` | date | set at `init` |
| `last_updated` | date | bumped on every `Write` |
| `domains` | object | map `D1..D5` → `{name, weight}` (see §1) |
| `concepts` | array | one object per concept (below) |

### Concept object

| Field | Type | Meaning |
|-------|------|---------|
| `id` | string | stable kebab id, `<domain>-<slug>` (e.g. `D1-coordinator-hub-spoke`) |
| `domain` | string | `D1`..`D5` |
| `scenario` | string | one of the 6 scenarios |
| `note` | string | source note filename in `common-mistakes/`, e.g. `d1-coordinator-hub-and-spoke.md` |
| `tag` | string | `"red"` 🔴 / `"green"` 🟢 / `"blue"` 🔵 (origin priority) |
| `gap` | bool | true if a coverage-gap topic from 00-EXAM-GUIDE.md |
| `attempts` | int | total recorded attempts |
| `correct` | int | correct attempts |
| `incorrect` | int | incorrect attempts |
| `last_seen` | date\|null | date of last attempt |
| `box` | int | Leitner tier 1–5 (human-readable mastery) |
| `ef` | float | SM-2 easiness factor, clamp ≥ 1.3 |
| `reps` | int | SM-2 successful-repetition counter |
| `interval` | int | current interval in days |
| `last_quality` | int\|null | last recall grade q∈0–5 |
| `next_due` | date\|null | `last_seen + interval` days; when this concept is due |

### Skeleton

```json
{
  "exam": "Claude Certified Architect – Foundations",
  "pass_threshold": 720, "scale_max": 1000, "scale_min": 100,
  "created": "2026-05-31", "last_updated": "2026-05-31",
  "domains": {
    "D1": {"name": "Agentic Architecture & Orchestration", "weight": 0.27},
    "D2": {"name": "Tool Design & MCP Integration", "weight": 0.18},
    "D3": {"name": "Claude Code Configuration & Workflows", "weight": 0.20},
    "D4": {"name": "Prompt Engineering & Structured Output", "weight": 0.20},
    "D5": {"name": "Context Management & Reliability", "weight": 0.15}
  },
  "concepts": [
    {"id": "D1-coordinator-hub-spoke", "domain": "D1",
     "scenario": "Multi-Agent Research System",
     "note": "d1-coordinator-hub-and-spoke.md", "tag": "red", "gap": false,
     "attempts": 0, "correct": 0, "incorrect": 0,
     "last_seen": null, "box": 1, "ef": 2.3, "reps": 0,
     "interval": 0, "last_quality": null, "next_due": "2026-05-31"}
  ]
}
```

---

## 3. Initialization & seeding

`init` enumerates **every concept** from `exam-notes/INDEX.md` (43 case notes in
`common-mistakes/`) plus coverage-gap topics from `exam-notes/00-EXAM-GUIDE.md`. Each
INDEX entry = one concept; assign `domain`/`scenario` from the exam guide.

Seed scheduling state from the priority tag so weak concepts surface first:

| Tag | Meaning | box | ef | reps | interval | next_due |
|-----|---------|-----|----|------|----------|----------|
| 🔴 red | got it wrong → most review | 1 | 2.3 | 0 | 0 | today |
| 🟢 green | got it right → lighter review | 2–3 | 2.6 | 1 | 6 | today + 6 |
| 🔵 blue | gap-fill (never tested) | 1 | 2.5 | 0 | 0 | today |

Use box `3` for green concepts the guide marks as well-understood, else box `2`.
All seeded concepts start `attempts:0, correct:0, incorrect:0,
last_seen:null, last_quality:null`. Gap topics also set `gap:true`.

---

## 4. SM-2 spaced repetition

Primary scheduler. Grade each attempt with recall quality **q ∈ 0–5**:
5 = perfect, 4 = correct after hesitation, 3 = correct but hard, 2/1/0 = fail
(2 = wrong but familiar, 0 = blank). **q < 3 means fail.**

New concept defaults: `ef = 2.5`, `reps = 0`, `interval = 0`.

On each `record(q)`:

1. **Update EF** (always):
   ```
   EF = EF + (0.1 − (5 − q) · (0.08 + (5 − q) · 0.02))
   if EF < 1.3: EF = 1.3        // clamp, never above-bounded
   ```
2. **Update reps & interval**:
   ```
   if q < 3:                    // failed recall
       reps = 0
       interval = 1
   else:                        // successful recall
       if   reps == 0: interval = 1
       elif reps == 1: interval = 6
       else:           interval = round(interval · EF)
       reps = reps + 1
   ```
3. **Schedule**: `next_due = last_seen + interval` days (last_seen = today).

EF deltas by q (for sanity-checking): q5 +0.10, q4 +0.00, q3 −0.14,
q2 −0.32, q1 −0.54, q0 −0.80.

---

## 5. Leitner box fallback

Simpler alternative / human-readable mastery tier. `box ∈ 1..5` with cadence:

| Box | Cadence (days) |
|-----|----------------|
| 1 | 1 |
| 2 | 2 |
| 3 | 4 |
| 4 | 9 |
| 5 | 21 |

Transition: **correct → up one box** (cap 5); **wrong → reset to box 1**.
`next_due = last_seen + cadence(box)`.

We always run SM-2 for `interval`/`next_due` and additionally keep `box` updated
by the Leitner rule as a readable mastery tier (and a fallback if EF data is
missing/corrupt). If only `box` exists for a concept, schedule by the Leitner
cadence above.

---

## 6. Mastery, readiness & scaled score

**Per-concept mastery** (Laplace-smoothed so unseen ≈ 0.5, never 0/1):
```
concept_mastery = (correct + 1) / (attempts + 2)
```
Optionally damp by retention tier: `× min(1, box / 4)` (a box-1 concept counts
at 25% even if its few attempts were correct). Apply the damp consistently if
used; document the choice in output.

**Per-domain mastery** = arithmetic mean of that domain's concept_mastery.

**Overall**:
```
overall = Σ_d  weight_d · domain_mastery_d        // weights sum to 1
scaled  = round(100 + overall · 900)              // maps [0,1] → [100,1000]
```

**Readiness**: `ready` iff `scaled ≥ 720`. Recommend continuing until
`scaled ≥ 760` for a safety margin against exam-day variance.

**Recoverable points per domain** (study-priority signal):
```
recoverable_d = weight_d · (1 − domain_mastery_d)
```
Rank domains by `recoverable_d` descending → those are the highest-leverage
domains to study (most expected scaled points to gain). High-weight + low-mastery
domains dominate.

---

## 7. Prioritization & the "next" queue

Candidate set: concepts with `next_due ≤ today` (always include 🔵 gap topics).

**Per-concept priority score**:
```
priority = domain.weight · (1 − concept_mastery)
           · (1 + red_boost) · (1 + box_boost)
   red_boost  = 0.5 if tag == "red" else 0
   box_boost  = (5 − box) · 0.1     // box1 → +0.4, box5 → 0
```
Higher = study sooner. This biases toward low-mastery concepts in high-weight
domains, 🔴 items, and low-box (shaky) concepts.

**Interleaving** (no two consecutive same-domain): sort domains by their total
candidate priority descending, then round-robin pull the top remaining concept
from each domain in turn, skipping a domain that would repeat the previous pick.
If only one domain has candidates left, emit them in priority order (repetition
unavoidable). Cap the returned queue at the caller's count (default 10).

---

## 8. Worked numeric example

### 8a. One SM-2 record

Concept `D2-tool-schema-strictness`, currently `ef=2.5, reps=0, interval=0,
attempts=3, correct=2`. Today the learner recalls it well: **q = 4**.

- EF: `2.5 + (0.1 − 1·(0.08 + 1·0.02)) = 2.5 + (0.1 − 0.10) = 2.5` (unchanged).
- q ≥ 3 and reps == 0 → `interval = 1`, `reps = 1`.
- `next_due = today + 1`.
- Stats: `attempts=4, correct=3`. Leitner: correct → box up (say 2→3).
- New mastery: `(3+1)/(4+2) = 4/6 = 0.667` (66.7%).

Next time, with `reps=1`, a q≥3 → `interval = 6`; the time after,
`interval = round(6 · 2.5) = 15`.

A failed recall later (**q = 1**): EF `2.5 + (0.1 − 4·(0.08+4·0.02)) =
2.5 − 0.54 = 1.96`; reps→0, interval→1, next_due = today+1, box→1.

### 8b. Readiness across domains

Suppose domain_mastery (means of concept masteries) come out as:

| D | weight | domain_mastery | contribution (w·m) | recoverable (w·(1−m)) |
|---|--------|----------------|--------------------|------------------------|
| D1 | 0.27 | 0.58 | 0.1566 | 0.1134 |
| D2 | 0.18 | 0.66 | 0.1188 | 0.0612 |
| D3 | 0.20 | 0.74 | 0.1480 | 0.0520 |
| D4 | 0.20 | 0.62 | 0.1240 | 0.0760 |
| D5 | 0.15 | 0.71 | 0.1065 | 0.0435 |

- `overall = 0.1566+0.1188+0.1480+0.1240+0.1065 = 0.6539`.
- `scaled = round(100 + 0.6539·900) = round(688.5) = 689` → **NOT READY** (−31).
- Recoverable ranking: **D1 (0.113) > D4 (0.076) > D2 (0.061) > D3 (0.052) >
  D5 (0.044)** → tell the learner to focus D1, then D4.

To reach 720 the learner needs `overall ≥ (720−100)/900 = 0.6889` — i.e. about
+0.035 overall, most cheaply earned by raising D1 mastery (its 0.27 weight makes
each mastery point worth the most).

---

## 9. Invariants & edge cases

- **EF clamp**: `ef` never < 1.3. No upper clamp.
- **Interval ≥ 1** whenever scheduled; a brand-new unseen concept may carry
  `interval = 0` with `next_due = today` (study now).
- **Weights sum to 1.0** — if a `domains` weight is edited, re-normalize before
  computing `overall`, or the scaled score drifts.
- **Empty domain** (no concepts yet): treat `domain_mastery` as 0.5 (neutral)
  so it doesn't zero-out the scaled score; flag it as "uncovered".
- **Smoothing prevents extremes**: a 0-attempt concept reads as 0.5 mastery, not
  0 — readiness won't crater purely from un-studied concepts, but those still
  surface in `next` via low box / gap tag.
- **Single source of truth**: only this skill writes `exam-notes/progress.json`.
  Always `Read` immediately before `Write`. Bump `last_updated` on every write.
- **Idempotent init**: refuse to overwrite an existing progress.json unless the
  user explicitly asks to reset.
