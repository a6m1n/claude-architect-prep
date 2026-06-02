---
name: mock-exam
description: >-
  Simulates the full Claude Certified Architect – Foundations exam: samples 4 of
  6 scenarios, distributes fresh MCQs across the five domains by official
  weighting, administers them under test conditions, scores on the 100–1000
  scale, and returns a PASS/NOT-YET verdict vs 720 plus a ranked study plan. Use
  when the user asks for a "mock exam", "full practice exam", "simulate the
  exam", a "readiness check / am I ready", or a "timed exam". Skip when the user
  wants a quick single-topic drill (use quiz-me) or to be taught a concept (use
  exam-tutor).
allowed-tools: Read, Write, WebFetch
argument-hint: "[num-questions]  (default 20; use 60 for full-length)"
---

# mock-exam

Estimate readiness for the **Claude Certified Architect – Foundations** exam by
running a weighted, scenario-sampled simulation, then convert the result to the
official 100–1000 scaled score and a targeted study plan. Mirrors the real test:
**60 MCQs · 1 correct + 3 distractors · pass = 720 · unanswered = wrong.**

This is the full-simulation orchestrator: it samples scenarios, allocates by
weight, calls [[quiz-me]] conventions to author questions, scores with the
[[progress-tracker]] formula, and records attempts. For a quick drill use
[[quiz-me]]; to be taught a concept use [[exam-tutor]]. It is the **summative**
checkpoint in the formative-vs-summative split explained in [[teaching-method]]
(every drill is formative; the timed mock is the periodic readiness verdict).

## Quick start

- "Give me a mock exam" → 20-question short mock (default).
- "Full practice exam" / "60-question exam" → full-length 60Q.
- "Am I ready?" → run a 20Q mock, then read the PASS/NOT-YET verdict + plan.

Always read `exam-notes/00-EXAM-GUIDE.md` and `exam-notes/INDEX.md` first so
questions match the in-scope task statements and target weak (🔴) areas.

## Workflow

1. **Configure the run.**
   - Total questions = `$ARGUMENTS` if given, else **20**. Support **60** for
     full-length.
   - **Sample 4 of the 6 scenarios at random** (mirrors the real exam):
     Customer Support Resolution Agent · Code Generation with Claude Code ·
     Multi-Agent Research System · Developer Productivity with Claude ·
     Claude Code for Continuous Integration · Structured Data Extraction.
   - **Allocate questions across D1–D5 by weighting**: count = `round(weight ×
     total)`; adjust by ±1 so counts sum to `total` (give any remainder to the
     highest-weight domain). Weights: D1 27% · D2 18% · D3 20% · D4 20% ·
     D5 15%. See `reference.md` for the 20Q / 60Q blueprint tables.

2. **Generate fresh MCQs** per the [[quiz-me]] conventions: each item =
   **1 correct + 3 distinct-archetype distractors** (common-misconception,
   right-idea-wrong-scope, true-but-irrelevant, over-engineered,
   under-engineered, symptom-not-root-cause). Spread items across the 4 sampled
   scenarios and all 5 domains, covering in-scope topics (task statements
   1.1–5.6) from `00-EXAM-GUIDE.md` — including the coverage-gap scenarios
   (Developer Productivity, Structured Data Extraction) when sampled. Do not
   reuse verbatim questions from the notes.

3. **Administer under test conditions.** Present all questions (or one-by-one if
   asked) and **collect every answer BEFORE revealing any answer key.** Do not
   leak correctness mid-exam. Unanswered = wrong (no guessing penalty, so prompt
   the user to answer every item).

4. **Grade & score.**
   - Per concept: `mastery = (correct + 1) / (attempts + 2)`.
   - Per domain: `domain_mastery = mean(concept masteries)`.
   - Overall: `overall = Σ (weightᵈ × domain_masteryᵈ)`.
   - **Scaled score = round(100 + overall × 900)** (range 100–1000).
   - Verdict: **PASS if scaled ≥ 720, else NOT-YET.** Recommend aiming **≥ 760**
     to absorb estimate error from the small sample. Worked example in
     `reference.md`.

5. **Report.**
   - Per-domain table: correct/total · mastery · scaled contribution
     (`weightᵈ × domain_masteryᵈ × 900`).
   - **Weakest high-weight domains ranked by `weight × (1 − mastery)`.**
   - Concrete study plan pointing at specific 🔴 High-trap notes in
     `exam-notes/common-mistakes/` (all case notes are named `dN-<slug>.md`,
     e.g. `d3-claudemd-hierarchy.md`), indexed in
     `exam-notes/common-mistakes/README.md` and `INDEX.md`.
   - For every missed question, cite the relevant official doc (URL list in
     `reference.md`, grouped by domain).

6. **Record attempts.** Append every item (concept, domain, correct?) to
   `exam-notes/progress.json` via the [[progress-tracker]] conventions so the
   mock updates the spaced-repetition schedule. Preserve existing JSON; never
   overwrite unrelated entries.

## Scoring & readiness verdict

- Map raw % to scaled via the formula above (raw % alone is **not** the score).
- 720 = pass; treat **720–759 as borderline** given sampling variance — advise a
  retake or targeted drills before booking the real exam.
- Always close with: top 2–3 domains to study next (by `weight × (1 − mastery)`)
  and the exact note files to open.

## When NOT to use

- Quick drill on one topic → use [[quiz-me]].
- Learn / be taught a concept → use [[exam-tutor]].
- Just update or read the schedule/score → use [[progress-tracker]].

## Example

User: "Am I ready? Give me a mock exam."
→ Read the guide + index. Pick 4 random scenarios (e.g. Customer Support,
Multi-Agent Research, Developer Productivity, Structured Data Extraction).
Allocate 20Q → D1 5, D2 4, D3 4, D4 4, D5 3. Generate and administer all 20,
collecting answers first. Grade: 14/20 raw; overall mastery 0.68 →
scaled = round(100 + 0.68 × 900) = **712 → NOT-YET** (aim ≥ 760). Report
per-domain table, rank D1 and D3 as weakest high-weight gaps, point to the
relevant 🔴 notes, cite docs for missed items, and append results to
`exam-notes/progress.json`.
