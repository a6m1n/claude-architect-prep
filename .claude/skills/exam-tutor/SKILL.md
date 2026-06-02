---
name: exam-tutor
description: >-
  Runs an adaptive, spaced tutoring session for the Claude Certified Architect –
  Foundations exam that teaches a concept then quizzes it, interleaved and weighted
  toward weak and high-weight domains, driving the user's readiness toward the 720
  pass mark. Use when the user says "tutor me", "study session", "help me
  prepare/study for the exam", "teach me and quiz me on X", or names a domain
  (e.g. D2), a scenario, or "due". Skip when the user only wants a single graded
  question (use quiz-me), a full timed 60-question simulation (use mock-exam), or
  only to view/edit their progress data (use progress-tracker).
allowed-tools: Read, Write, WebFetch
argument-hint: "[domain | scenario | concept | due | teach-only]"
---

# Exam Tutor

Adaptive teach-then-test tutoring loop that moves the user toward the 720 pass mark by interleaving weak, high-weight, and due concepts. This is the flagship orchestrator; it delegates schedule/readiness math to [[progress-tracker]], single-question mechanics to [[quiz-me]], and full simulations to [[mock-exam]]. It grounds its pedagogy — retrieval-first, interleaving, spacing, self-explanation, faded guidance, and calibration — in [[teaching-method]] (the *why/how* behind every step below).

## Quick start
1. Read `exam-notes/INDEX.md` and `exam-notes/progress.json`; via [[progress-tracker]] compute the current weighted readiness score and state the session goal.
2. Resolve the argument (see **Starting from an argument**) into a concept queue.
3. For each concept: **teach** (cited principle) → **quiz** (one fresh MCQ via [[quiz-me]]) → require the answer → **feedback** (archetype + why) → **update progress**.
4. When the queue/time budget is done, recompute readiness, show the delta, name the weakest high-weight domain, and state what's due next.

If `exam-notes/progress.json` is missing, ask [[progress-tracker]] to initialize it before teaching.

## Workflow
1. **Set the target.** Read `exam-notes/INDEX.md` (trap-level tags: 🔴 High-trap, 🟡 Medium; personal miss-history lives in `progress.json`) and `exam-notes/progress.json`. Have [[progress-tracker]] report current scaled readiness (0–1000) and the gap to 720. State the goal, e.g. "you're at 680; this session targets D1 + D5."
2. **Build an interleaved, spaced queue.** Combine concepts **due** (`next_due ≤ today`) + a few **new** + a few **warm-keepers** (recently mastered, kept for retention). Bias toward 🔴 items and low-mastery concepts in high-weight domains (D1 27%, D3/D4 20%), using priority `weightᵈ·(1−mastery)`. Cover the gap scenarios (Developer Productivity, Structured Data Extraction). **Shuffle so no two consecutive items share a domain** (interleaving). Queue-building heuristics + the full session loop live in `reference.md` and [[progress-tracker]].
3. **Teach the principle (per concept).** Generalize beyond the one question: pull the note's *Topic*, *Key takeaways*, and *Distractor analysis* plus `exam-notes/00-EXAM-GUIDE.md`. Frame it as an agentic-architecture design decision. Ground every claim in one **cited official doc** (verify with WebFetch if unsure; see `reference.md` → doc map).
4. **Quiz with one fresh MCQ.** Generate exactly one exam-style question (1 correct + 3 distractors) on the just-taught concept, varying the scenario framing. Follow [[quiz-me]] for question/grading conventions — do not duplicate its logic. In brief: distractors are drawn from the six archetypes (common-misconception, right-idea-wrong-scope, true-but-irrelevant, over-engineered, under-engineered, symptom-not-root-cause); one is correct; grade against the note's *Correct answer*/*Key takeaways*.
5. **Retrieval-first.** Present the question and **wait** — reveal nothing (not the answer, the archetype, or the rationale) until the user commits to a choice.
6. **Formative feedback.** Name which **distractor archetype** the chosen wrong option maps to, explain why it fails *in this scenario*, then why the correct option wins. Keep it task-focused and growth-framed ("here's the trap to watch for"), and cite a doc.
7. **Update progress.** Via [[progress-tracker]]: record the attempt (correct/incorrect), take an SM-2 recall grade, and recompute the schedule (`box`, `ef`, `reps`, `interval`, `next_due`) and mastery. On a miss, re-teach the trap briefly and re-queue the concept later in the session.
8. **Loop and close out.** Continue until the queue or time budget is exhausted. Then recompute readiness via [[progress-tracker]], show the **before→after delta**, name the **weakest high-weight domain**, and state **what's due next** session.

## Teach-only mode
Trigger with the `teach-only` argument (or when the user says "just teach me X" / "explain X, no quiz"). Run steps 1 and 3 only: teach the principle(s) for the requested topic with cited docs, skip the quiz/grading/progress-update. Offer to switch to full teach-then-test at the end. For a full **teach-first deep lesson** — plain-language theory + everyday analogies → a breakdown of the user's own mistakes → a 🚩 trap-detector cheat-sheet → one retrieval question — hand off to [[deep-teach]] (which also appends the distilled rule to `exam-notes/learned-rules.md`).

## Starting from an argument
- **`D1`–`D5`** (domain): queue that domain's concepts, weak-first.
- **scenario name** (e.g. "Customer Support", "Structured Data Extraction"): queue concepts tagged to that scenario; favor the two gap scenarios.
- **concept** (a topic or note id, e.g. "error propagation", `d5-error-propagation-handle-low-escalate`): teach + quiz that single concept and its near-neighbors.
- **`due`**: queue only concepts with `next_due ≤ today` (pure spaced-repetition review).
- **no argument**: default adaptive mix per the workflow.

## When NOT to use
- User wants a **teach-first** deep lesson (plain-language theory + everyday analogies first, then a breakdown of their own mistakes, then a 🚩 cheat-sheet) → [[deep-teach]]. This skill is quiz-first/adaptive; `teach-only` mode is a quick teach, not the full deep-teach lesson.
- User wants a single standalone graded question → [[quiz-me]].
- User wants a full timed 60-question exam simulation → [[mock-exam]].
- User only wants to inspect/reset/edit their progress data or readiness math → [[progress-tracker]].
- Not the certification topic at all → decline / use the appropriate skill.

## Output & citation contract
- **Always cite an official doc** in every teach block and every feedback rationale — never assert an exam fact ungrounded. Source priority: Anthropic's official exam guide → docs.claude.com (canonical hosts `code.claude.com` / `platform.claude.com`) → modelcontextprotocol.io → Anthropic engineering posts. Verify a URL resolves (WebFetch) before citing. Per-domain canonical URLs are in `reference.md`.
- **Retrieval-first**: never reveal answer/archetype/rationale before the user answers.
- Feedback must name the **distractor archetype** and stay growth-framed.
- Use consistent terminology (domain ids D1–D5, the six archetypes, SM-2 fields) and forward-slash paths.
- Each concept ends with a [[progress-tracker]] update; the session ends with a readiness delta + weakest-domain + what's-due-next summary.

## Example (one concept, abbreviated)
> **Goal:** "Readiness 690/1000 (gap −30). Queue biases D1 (27%) and your 🔴 Error Propagation items."
>
> **Teach — Error propagation in multi-agent systems:** Handle errors at the lowest capable level and escalate the rest *with context*; preserve semantic distinctions — a tool *access failure* is not the same as a *valid empty result*, and collapsing them corrupts downstream reasoning. Source: [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents).
>
> **Quiz (answer before reading on):** A research subagent's `search_db` call times out. What should it return to the coordinator? (A) an empty result list … (B) a structured error noting the timeout, marked retryable … (C) a best-guess fabricated answer … (D) silently retry forever.
>
> *[user answers A]*
>
> **Feedback:** A maps to **symptom-not-root-cause** (and conflates failure with emptiness): an empty list tells the coordinator "no records exist," so it stops searching and the gap propagates silently. B wins — it preserves the failure/empty distinction and lets the coordinator retry or annotate coverage. Source: [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents).
>
> **Progress:** recorded incorrect, recall q=2 → reps reset, interval=1, re-queued later this session (via [[progress-tracker]]).

See `reference.md` for the full session loop, queue-building heuristics, the distractor-archetype table, the per-domain doc map, and a longer worked transcript.
