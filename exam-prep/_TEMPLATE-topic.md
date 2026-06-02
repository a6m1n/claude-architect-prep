<!--
TEMPLATE for an exam-prep topic file. Copy to domain-N-*/N.N-slug.md and fill it in.
Rules: keep the questions and their four options A–D in the professional exam register
(production scenario, precise); write the theory, traps, and rationales in clear, plain
prose; put technical terms / flags / paths in `code`. Verify every link with WebFetch
(canonical hosts code.claude.com / platform.claude.com / modelcontextprotocol.io).
Keep it focused, ~130–240 lines, not huge.
Structure (strict order): TL;DR → In plain words → Theory → Traps →
Remember → Practice (3–4 MCQs of rising difficulty + 1 tricky `**`) → Documentation.
-->
# {N.N} — {Title}

> **Domain {D}: {Domain name}** ({weight}%) · **Task Statement {N.N}** | **Scenarios:** {…} | **What it tests:** {one line}

## ⚡ TL;DR
- {3–5 key decision rules, in plain words, terms in `code`}

## 🧠 In plain words

> **Analogy:** {emoji anchor — reuse the stable ones: 🔑 keys · 🗼 control tower · 🪜 ladder · 🎤📋 context} {an everyday metaphor in one phrase}.
>
> {2–3 simple sentences: the core idea AND the catch}.
>
> 🚩 **Detector:** if an answer says {signal} — that's the {trap-archetype name}; the right move is {what's actually correct}.
>
> 🧷 **Reflex:** {a rhythmic rule line that's easy to repeat from memory}.

## 📘 Theory
### {subsection}
{An explanation tied to the task statement. Name the design principle: least privilege /
determinism vs probabilistic / root-cause-over-symptom / context engineering / error
propagation / matching workload to mechanism — whichever applies.}

## ⚠️ Traps and distractors
| Trap archetype | Why it's wrong |
| --- | --- |
| **{archetype}** | {analysis} |

## 🔑 Remember
- {exact flags / paths / behavior for the exam}

## 📝 Practice

*Answer it yourself first, then expand "Answer".*

**Q1 · easy** — {scenario stem}

A) … B) … C) … D) …

<details><summary>Show answer</summary>

**Correct answer: X.** {Rationale: why it's right and, briefly, why each of the others is a trap (name the archetype).}
</details>

<!-- repeat for Q2 · medium and Q3 · hard (for high-weight topics — add Q4) -->

### Tricky question **

**Q★★ (tricky):** — {a subtler scenario stem}

A) … B) … C) … D) …

<details><summary>Show answer</summary>

**Correct answer: X.** {Rationale + the exact reason each trap fails.}
</details>

## 🔗 Official documentation
- [{Title}]({verified-URL}) — {what's inside and why it's relevant}
