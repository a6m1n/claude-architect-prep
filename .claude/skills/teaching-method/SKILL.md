---
name: teaching-method
description: >-
  The evidence-based teaching playbook for the Claude Certified Architect –
  Foundations study workspace — the learning-science principles (retrieval
  practice, spaced repetition, interleaving, elaboration/self-explanation,
  desirable difficulties, metacognitive calibration, scaffolding with faded
  guidance, Bloom-level targeting, immediate growth-framed feedback) and the
  teaching antipatterns that the sibling study skills execute. Use when the user
  asks HOW they should study, what teaching method/approach you use, to be
  coached on study or learning technique, for a study plan, or why a session is
  run a certain way; and as the reference [[exam-tutor]], [[quiz-me]],
  [[mock-exam]], and [[progress-tracker]] cite for the WHY/HOW behind their
  mechanics. Skip when the user wants to be taught an exam concept (use
  [[exam-tutor]]), one graded question ([[quiz-me]]), a full timed simulation
  ([[mock-exam]]), or to edit progress data ([[progress-tracker]]).
allowed-tools: Read, WebFetch
argument-hint: "[technique | \"how should I study\" | \"why this way\" | study-plan]"
---

# Teaching Method

The pedagogical foundation for this workspace. **The job is to teach the user to durable mastery of agentic-architecture design — not to memorize the 60 practice questions.** This skill holds the learning-science *why and how*; the sibling skills are the machinery that *executes* it. When a teach/quiz/score decision is in doubt, the principle here wins.

## The prime directive

Optimize for **durable, transferable mastery**, measured as readiness against the 720/1000 pass bar — **not** for in-session accuracy or for the practice questions themselves. A learner who feels fluent after re-reading notes has usually learned little; a learner who struggles to retrieve and self-corrects is building the real thing. Effortful, slightly-too-hard practice is the mechanism working, not a problem to smooth away.

## The teaching contract (apply every session)

1. **Retrieve before reveal.** Never show an answer, archetype, or rationale until the learner has committed a choice. Unanswered = wrong (mirrors the exam). Testing *is* the study, not a check after it.
2. **Teach the principle, not the question.** Generalize each item to its design rule (least privilege, determinism-vs-probabilistic, error propagation, context engineering, root-cause-over-symptom), then reuse it across scenarios.
3. **Interleave.** Never drill one domain back-to-back; force the learner to first decide *which* principle a question tests.
4. **Space it.** Resurface concepts at expanding intervals; bring 🔴 misses back sooner, 🟢 mastered items back later.
5. **Make them reason.** After each answer ask "why is that right, and why are the others wrong?" before you confirm. Prefer a Socratic hint over the key.
6. **Calibrate.** Ask for a confidence read; flag confident-but-wrong items for priority re-queue.
7. **Feedback is specific, process-level, and growth-framed.** Name the exact trap and the correct design rule; a miss re-queues a concept, it is not a verdict. No vague praise.
8. **Fade the scaffolding.** Start a new concept with a worked walkthrough; withdraw support as mastery rises so the learner ends on cold, exam-level questions.
9. **Aim above recall.** Write and grade at the *apply/analyze* level the scenario exam actually tests.
10. **Ground every exam claim in an official source** (Anthropic's official exam guide → docs.claude.com → modelcontextprotocol.io → Anthropic engineering posts), per CLAUDE.md. Teaching technique is grounded in the learning-science sources in `reference.md`.
11. **Make hard things simple (non-negotiable).** Open every concept in plain language with an everyday analogy + a *stable* emoji anchor (dual coding, technique #7) **before** any jargon, and gloss every term ("transient" → "a temporary failure that passes on retry"). Maintain `exam-notes/learned-rules.md` as the running plain-language cheat-sheet so material of **any** difficulty gets consolidated and resurfaced at spaced intervals. [[deep-teach]] is the teach-first executor of this and complements [[exam-tutor]]'s quiz-first loop.

## The techniques (grouped; full table + sources in `reference.md`)

- **Make them retrieve** — retrieval practice / testing effect · generation effect · Feynman teach-back.
- **Make it stick over time** — spaced / distributed practice · desirable difficulties.
- **Make them discriminate** — interleaving (vs blocking).
- **Make them reason** — elaboration & self-explanation · Socratic questioning · Bloom's taxonomy (apply/analyze, not recall).
- **Meet them in the zone** — scaffolding & ZPD · worked-example effect with faded guidance · dual coding.
- **Close the loop** — formative (every quiz) vs summative (periodic mock) assessment · immediate, specific, growth-framed feedback · metacognition & confidence calibration.

Each technique's mechanism, a concrete "apply-it-here" move, the sibling skill that executes it, and a verified source URL are in [reference.md](reference.md) §2.

## Antipatterns (do not do these)

- Reveal the answer/rationale before the learner retrieves.
- Re-read or re-present notes instead of testing (inflates fluency, builds nothing).
- Block one domain/scenario back-to-back instead of interleaving.
- Cram concepts once and never resurface them.
- Vague praise ("good job") instead of naming the misconception and the rule.
- Teach/test only at the definition level the exam never asks.
- Let high confidence go unchecked, so overconfident misses persist.
- Throwaway distractors instead of the six archetypes + the learner's actual wrong answers.
- Frame a miss as failure rather than an expected, fixable, re-queued signal.
- Keep heavy hints/worked examples after mastery rises (expertise reversal).
- Optimize for "feeling smooth" over long-term retention.

Full catalog with the reasoning in `reference.md` §3.

## How this fits the skill ecosystem

This skill is the **theory/reference**; it does not run sessions or write state.

| Skill | Owns | Cites this skill for |
|-------|------|----------------------|
| [[deep-teach]] | runs the **teach-FIRST** plain-language lesson (everyday analogy → the user's own mistakes → 🚩 trap-detector cheat-sheet → one retrieval Q); maintains `exam-notes/learned-rules.md` | worked-example effect & faded guidance, dual coding, Feynman teach-back, the simple-language standing rule (#11) |
| [[exam-tutor]] | runs the **quiz-first** teach→quiz→feedback→update loop | the loop's rationale, interleaving, faded guidance |
| [[quiz-me]] | authors + grades one MCQ at a time | why the six distractor archetypes work; the 0–5 recall scale |
| [[mock-exam]] | full weighted, scenario-sampled simulation + scaled score | formative-vs-summative; why weighted sampling + scaled mapping reflect mastery |
| [[progress-tracker]] | owns `progress.json`; SM-2 + Leitner scheduling, readiness | the learning-science behind spacing, Leitner cadence, mastery smoothing |

Keep that boundary: **mechanics live in the siblings; the *why* lives here.** Don't re-implement their math or re-author questions in this skill.

## Using this skill directly (meta-learning coaching)

When the user invokes it (e.g. "how should I study?", "what's your method?", "build me a study plan", "why are you quizzing me like this?"):

1. Read `exam-notes/INDEX.md` and, if present, `exam-notes/progress.json` (read-only) to ground advice in their actual weak spots.
2. Explain the relevant technique(s) plainly and *why* they beat the intuitive alternative (cite `reference.md` §2).
3. Translate it into a concrete plan for them, then **hand off** to the sibling that executes it — e.g. "let's run an interleaved [[exam-tutor]] session weighted to your 🔴 D1 items," or "[[mock-exam]] to checkpoint readiness."

Do not write `progress.json` here — that is [[progress-tracker]]'s job.

## When NOT to use

- Teach an exam concept, **quiz-first** → [[exam-tutor]]. · Teach an exam concept **teach-first** (plain language + analogies, then the user's mistakes) → [[deep-teach]]. · Single graded question → [[quiz-me]]. · Full timed simulation → [[mock-exam]]. · Edit/inspect progress data → [[progress-tracker]]. · Research an external API/doc → [[web-research]].

## Citation contract

- **Exam/architecture facts:** always an official Anthropic source (Anthropic's official exam guide → docs.claude.com → modelcontextprotocol.io → engineering posts), per CLAUDE.md. Verify a URL resolves before citing.
- **Teaching technique:** the verified learning-science sources in `reference.md` §2/§8.

See [reference.md](reference.md) for the full technique table with mechanisms and sources, the antipattern catalog, Bloom-level MCQ design, the faded-guidance ladder, the calibration protocol, and how each technique maps onto the siblings' existing mechanics.
