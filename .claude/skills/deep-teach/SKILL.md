---
name: deep-teach
description: >-
  Runs a teach-FIRST deep lesson on one concept for the Claude Certified
  Architect – Foundations prep, in a teach-first format: plain-language
  theory with everyday analogies FIRST, then a breakdown of the user's own
  recorded wrong answers (what they picked → why it's wrong → the correct answer
  → why), each tagged with the trap archetype, plus a "🚩 trap-detector" lifehack
  and a rhythmic cheat-sheet, closing with ONE retrieval question. Use this
  whenever the user says "teach me X", "explain this topic", "break down my
  mistakes", "theory first, then my mistakes", "make a cheat-sheet with
  lifehacks", "explain it simply / in plain terms", asks to study/learn a domain
  or concept WITHOUT asking to be quizzed first, or wants a deep dive on an exam
  topic. Prefer this over exam-tutor when the user wants to be TAUGHT first
  rather than tested first. Skip for a single graded question (quiz-me), a full
  timed simulation (mock-exam), or editing progress data (progress-tracker).
allowed-tools: Read, Write, Edit, WebFetch
argument-hint: "[concept | domain | scenario | note-id]"
---

# Deep Teach — the teach-first lesson format

A concrete, repeatable lesson recipe. It is the
**teach-first** complement to [[exam-tutor]] (which is quiz-first/adaptive): open
a concept with a worked walkthrough, generalize the principle, then drive
mastery through the user's *own* mistakes. The pedagogy *why* behind every step
is in [[teaching-method]] — this skill is the **how**, fixed into a repeatable
shape so lessons feel consistent.

**Prime directive:** teach the **principle** (the transferable design rule), not
the specific question. A learner who can apply the rule to a *new* scenario has
the real thing; one who memorized the answer key does not.

## Pick the topic first (priority order)

Unless the user names a topic, pick the **highest-leverage** one:

1. Read `exam-notes/INDEX.md` (trap-level tags 🔴 High · 🟡 Medium; personal miss-history is in `progress.json`).
2. **Cluster the 🔴 misses by theme** and teach the theme with the **most
   repeated mistakes first** — recurring errors in high-weight domains (D1 27%,
   D3/D4 20%) are the cheapest points to recover. Prioritize by
   `weight × (1 − mastery)`.
3. **Interleave** across sessions — don't teach the same domain back-to-back.
4. Read the relevant note(s) in `exam-notes/common-mistakes/`
   (all case notes are named `dN-<slug>.md`, e.g. `d3-claudemd-hierarchy.md`) to ground the lesson in the note's
   *Common mistake* (§5, the trap most people fall for) and its *Distractor
   analysis* (§6); layer in the user's own miss-history from [[progress-tracker]] when present.

**Source material to teach from:** `exam-notes/` (the user's recorded mistakes +
`learned-rules.md` for already-distilled anchors) **and** the official-guide-derived kit
`exam-prep/` — each `exam-prep/domain-*/N.N-*.md` already carries a
plain-language summary block, trap analysis, and practice MCQs, and
`exam-prep/ROADMAP.md` is the simple path through the hard topics built on the
same emoji anchors + lever-ladder. **Reuse the existing anchors so they compound;
never invent a parallel set.**

## The lesson shape (follow this order every time)

Keep this exact order every time; it is load-bearing
(you cannot understand a mistake before you have the rule to judge it against).

### Part 1 — Theory FIRST (worked example)
- State the **one principle** in a single bolded sentence.
- Explain it in **plain language** — define any jargon in everyday words
  (e.g. "transient" → "a temporary failure that passes on retry").
- Anchor it with a **vivid everyday analogy** + an emoji image (dual coding:
  give memory a second, pictorial route). Reuse stable anchors so they
  compound — e.g. 🔑 keys (least privilege), 🗼 control tower (coordinator),
  🪜 ladder (determinism), 🎤 long speech + 📋 receipt (context).
- Where a topic has a decision boundary, draw it as a small **table or 2×2**.

### Part 2 — Break down the USER's mistakes
For each relevant miss, in this micro-structure:
- **Question** (briefly).
- **❌ What they picked** — quote their actual recorded answer.
- **Why it's wrong** — name the failure precisely.
- **✅ Correct** — quote it.
- **Why it's right** — tie back to the Part-1 principle.
- **Tag the trap archetype** (common-misconception · right-idea-wrong-scope ·
  true-but-irrelevant · over-engineered · under-engineered ·
  symptom-not-root-cause). Naming the trap is what makes the miss instructive.
- If a related item was answered **correctly**, include it as a 🟢 contrast.

### Part 3 — Personal pattern
Name the user's **recurring tendency** across the misses ("you swing to
extremes", "you reach for the prompt instead of a tool/code", "you hide
information"). A pattern is more actionable than isolated corrections.

### Part 4 — 🚩 Trap-detector + cheat-sheet
- A **trap-detector**: an observable signal the user can apply mid-exam
  ("🚩 if an answer says 'only X can' + an operational feature → false dichotomy").
- A **rhythmic cheat-sheet line** / mnemonic, short enough to repeat from memory
  ("Escalate when I CAN'T, not when I don't WANT to").
- An **exam trap-filter**: 1–3 lines on what the right answer looks like and
  which distractor shapes to reject.

### Part 5 — One retrieval question (retrieval-first)
Close with **exactly one** fresh self-check question in a new scenario. **Do not
reveal the answer** until the user commits — retrieval is the study, not a check
after it. Frame it as low-stakes ("not graded, just talk it through").

## Maintain the running cheat-sheet

After each lesson, **append** the topic's distilled rules to
`exam-notes/learned-rules.md` (same structure: main idea · analogy ·
ladder/table if any · my mistakes · trap-detector · trap-filter · sources). That
file is the user's spaced-repetition artifact — they re-read it to resurface
concepts at expanding intervals. Keep entries tight and skimmable; do not
duplicate — update an existing block if the topic already has one.

## Standing rules

- **Lifehacks & cheat-sheets every time**, with dead-simple plain examples and
  analogies — this is non-negotiable.
- **Simple language.** No unexplained jargon. Short sentences.
- **Theory before errors**, always — never analyze a mistake before the rule
  exists to judge it.
- **Cite an official source for every exam claim** (Anthropic's official exam guide →
  docs.claude.com / canonical `code.claude.com`·`platform.claude.com` →
  modelcontextprotocol.io → Anthropic engineering posts). Verify a URL resolves
  with WebFetch before citing. Teaching technique is grounded in
  [[teaching-method]], not the exam docs.
- **Fade the scaffolding** as mastery rises: heavy worked examples early, colder
  retrieval questions later.

## When NOT to use

- Single standalone graded question → [[quiz-me]].
- Full timed 60-question simulation → [[mock-exam]].
- Quiz-first adaptive/spaced session → [[exam-tutor]].
- Only inspect/update progress data → [[progress-tracker]].
- Asking *how/why* to study (meta) → [[teaching-method]].

## Example (abbreviated)

> **User:** "Teach me the next, highest-priority topic."
>
> → Read INDEX.md, cluster 🔴 misses, pick **Error Propagation** (3 repeated
> misses in high-weight D1). Read the 3 notes for the user's actual answers.
>
> **Part 1 — Theory:** "📢 A subagent is an **outcome reporter**: fix only the
> cheap, temporary failures yourself; escalate the rest *with context*; never
> hide or collapse meaning (`0 results` ≠ `timeout`)." + a table of the four
> outcomes. Source: [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents).
>
> **Part 2 — Mistakes:** Q18 ❌ picked B (mask the error as success) →
> symptom-not-root-cause → ✅ C (local recovery + escalation with context) …
>
> **Part 3 — Pattern:** "In all three you picked 'hide the signal'."
>
> **Part 4 — Lifehack:** "🚩 An option that hides / averages / blocks → trap."
> Cheat-sheet: "Fix the small stuff yourself, shout about the big stuff with
> details, hide nothing."
>
> **Part 5 — Question:** one fresh scenario; don't reveal the answer until they
> answer.
>
> → Append the distilled block to `exam-notes/learned-rules.md`.
