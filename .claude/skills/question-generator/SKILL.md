---
name: question-generator
description: >-
  Generates a single fresh exam-style multiple-choice question — production-scenario
  stem with specific observational data, four options with distinct distractor
  archetypes, then elaborated graded feedback after the user answers. Requires one
  argument: a topic or scenario (e.g. "Customer Support Resolution Agent", "tool
  selection", "D2", "multi-agent orchestration"). Use whenever the user says
  "generate a question about X", "create a practice question on [topic]", "give me
  a question on [scenario]", "make a question about [concept]", or any similar
  phrasing requesting a single on-demand MCQ.
  Unlike quiz-me (which pulls from progress and sequences by weakness), this is
  fully standalone — no tracking, just one high-quality question on any topic, on
  demand.
allowed-tools: Read, Glob, Grep
argument-hint: "<topic, scenario, domain, or task-id>  — e.g.:  'Customer Support Resolution Agent'  |  'tool selection'  |  D2  |  1.4  |  'CI/CD pipelines'"
---

# question-generator

Produces one fresh, exam-quality MCQ on any topic, delivered
retrieval-first. No progress file needed — the whole job is: author → present → grade.

The question format mirrors the real certification exam: a **production scenario stem** with concrete observational evidence (logs,
percentages, latency numbers, specific tool names), **four options** (1 correct key + 3
distinct-archetype distractors), and a **graded explanation** that states the principle,
names each wrong option's failure mode, and cites an official doc.

---

## Step 1 — Parse the argument

`$ARGUMENTS` = `<topic>`

| Field | Values | Fallback |
|---|---|---|
| **topic** | Domain code `D1`–`D5`, a scenario name, or any concept/keyword | Pick D1 (highest weight) |

---

## Step 2 — Resolve topic using exam-topics-index.md

**Always read `exam-notes/exam-topics-index.md` first.** This is the primary authoring
source — it is a structured navigator that gives you everything needed to build one
exam-quality question per task statement:

| Field in the index | How to use it |
|---|---|
| **Topics** | Anchor the stem and correct answer in these concepts |
| **Skills** | What the correct answer must let the learner *demonstrate* |
| **Traps** | Pre-built distractor seeds — each trap is a wrong answer real learners choose |

The Scenario details section also provides **canonical tool names** for each scenario
(e.g. `get_customer`, `lookup_order`, `process_refund`, `escalate_to_human` for Customer
Support) — use these in the stem so the question feels grounded in the real exam context.

### Resolving the topic argument to a task statement

| Argument form | Resolution |
|---|---|
| **Domain code** `D1`–`D5` | Read that domain's section; pick one task statement (e.g. 1.3, 1.6) at random |
| **Task statement ID** `1.4`, `2.3`, etc. | Jump directly to that task statement |
| **Scenario name** | Find the scenario in the Scenarios table → note its Primary Domains → pick a task statement from those domains |
| **Free-form concept/keyword** | Scan Topics fields across all domains; pick the best-matching task statement |
| **No argument** | Default to D1 (highest weight 27%), pick a task statement at random |

### Handling pending sections (D4, D5)

If the chosen task statement falls in a domain section marked `*(section to be filled)*`,
fall back to the corresponding `exam-prep/domain-N-*/` files via `Glob` and read the
relevant topic file. Extract the concept, common wrong answers from any *Distractor
analysis* sections, and the official doc URL.

---

## Step 3 — Author one fresh question

Write a completely new scenario (new company name, different tool names, fresh numbers).
Never copy a verbatim question from the notes.

### Stem
3–5 sentences. Include:
- **Observable production evidence**: a specific metric ("in 14% of turns"), log observation
  ("production logs show the agent calls X without first calling Y"), or measured outcome
  ("latency increased by 35%")
- **Concrete tool or config names** from the scenario (use the index's Scenario details
  tool names when the topic is scenario-anchored)
- **A direct closing question**: "What change would most effectively address this?" or
  "What is the most likely root cause?" or "What is the best first step?"

The stem must put the reader *inside* a real decision — not ask them to recall a definition.

### Options

Exactly 4 options, labeled A–D. One correct key + 3 distractors from **distinct archetypes**.

#### Distractor archetypes

| Archetype | What it looks like |
|---|---|
| **common-misconception** | A widely-believed-but-false claim; sounds like standard advice |
| **right-idea-wrong-scope** | Correct mechanism applied at the wrong level (user vs project, single-agent vs multi-agent) |
| **true-but-irrelevant** | A factually accurate statement that doesn't address the actual problem |
| **over-engineered** | Adds multi-agent layers, caching, batching, or pipelines where a simpler primitive suffices |
| **under-engineered** | Too simple; ignores a requirement explicitly stated in the stem |
| **symptom-not-root-cause** | Patches the surface failure (retries, bigger prompts) while the real cause persists |

#### Building distractors from Traps

The index's **Traps** field for each task statement gives you the exact misconceptions
real learners hold. Map each trap phrase directly to an archetype and flesh it out into
a plausible option:

| Trap phrase pattern | Archetype |
|---|---|
| "Relying on system prompt / prompt instructions for compliance-critical ordering" | common-misconception |
| "Correct mechanism at wrong scope (user-level vs project-level, all-agents vs one-agent)" | right-idea-wrong-scope |
| "Adding pipelines / extra agents / caching layers when a simpler primitive suffices" | over-engineered |
| "Ignoring a stated requirement (e.g. missing error categories, omitting root cause)" | under-engineered |
| "Patching surface failure (retries, bigger context) without fixing root cause" | symptom-not-root-cause |
| "Stating a true fact (about context windows, MCP resources, etc.) that doesn't fix the problem" | true-but-irrelevant |

**Example — task statement 1.4** (Traps: "Relying on system prompt to enforce
compliance-critical ordering · omitting root cause from handoffs · sequential investigation
of independent concerns"):
- Distractor A (common-misconception): strengthen the system prompt to mandate tool ordering
- Distractor B (under-engineered): send an escalation handoff that omits root cause
- Distractor C (under-engineered): run independent investigation steps sequentially instead of in parallel

**Domain pairing guide** (use 3 distinct archetypes per question):
- D1 architecture: common-misconception + under-engineered + over-engineered
- D2 tool design: symptom-not-root-cause + true-but-irrelevant + over-engineered
- D3 config/workflow: right-idea-wrong-scope + under-engineered + true-but-irrelevant
- D4 prompt/output: common-misconception + under-engineered + true-but-irrelevant
- D5 context/reliability: over-engineered + symptom-not-root-cause + common-misconception

**Option quality rules**:
- All 4 options roughly the same length and grammatical form
- No "always" / "never" absolutes
- Distractors must be plausible to a learner who doesn't know the concept cold — not
  obviously silly
- Only one option is defensibly correct

### Correct answer
The key must apply the principle named in the **Skills** field of the task statement —
address the root cause, not patch a symptom or over-engineer beyond what the scenario demands.

---

## Step 4 — Present (retrieval-first)

Output **only** the stem and the four options A–D. Reveal nothing else — no answer, no
archetype labels, no hint about which option is correct.

Wait for the user to commit to a letter before continuing.

---

## Step 5 — Grade after the user answers

Once the user provides their letter:

1. State **Correct Answer: [Letter]** (matching the standard exam question format)
2. Explain why the correct answer works — state the **principle** it applies, generalized
   beyond this one scenario (e.g. "programmatic enforcement provides deterministic guarantees
   that prompt-based approaches cannot")
3. For each wrong option, state why it fails *in this specific scenario*. Name the failure
   mode explicitly (e.g. "relies on probabilistic LLM compliance", "addresses tool
   availability rather than tool ordering", "treats the symptom rather than the root cause").
   Follow the compact style of the examples: "Options B and C rely on X. Option D addresses Y
   rather than Z, which is not the actual problem."
4. Close with **≥1 official doc URL** relevant to the concept

**Citation fallback by domain** (use the source note's URL first; fall back to these):

| Domain | Canonical URLs |
|---|---|
| D1 | https://www.anthropic.com/engineering/building-effective-agents · https://code.claude.com/docs/en/sub-agents |
| D2 | https://www.anthropic.com/engineering/writing-tools-for-agents · https://modelcontextprotocol.io/docs/getting-started/intro |
| D3 | https://code.claude.com/docs/en/memory · https://code.claude.com/docs/en/settings · https://code.claude.com/docs/en/slash-commands |
| D4 | https://platform.claude.com/docs/en/build-with-claude/structured-outputs · https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview |
| D5 | https://platform.claude.com/docs/en/build-with-claude/prompt-caching · https://platform.claude.com/docs/en/build-with-claude/context-windows |

---

## Output format contract

**Presentation turn** (before the user answers):
```
[Stem — 3–5 sentences of production context with specific data]

A) [Option]
B) [Option]
C) [Option]
D) [Option]
```

**Grading turn** (after the user answers — mirror the worked example format exactly):
```
Correct Answer: [Letter]
[Why the key is correct — the principle, generalized]
[Why each wrong option fails — failure mode named per option, compact]
```

---

## When NOT to use

- **Multiple questions / spaced repetition** → [[quiz-me]] (tracks progress, sequences by weakness)
- **Adaptive teach-then-quiz session** → [[exam-tutor]]
- **Full timed 60Q simulation** → [[mock-exam]]
- **Learn the concept first** → [[deep-teach]]

---

## Worked example (abbreviated)

Argument: `"Customer Support Resolution Agent"`

**Step 1 — Parse**: topic = "Customer Support Resolution Agent"

**Step 2 — Index lookup**: Read `exam-notes/exam-topics-index.md`.
- Scenario 1 → Primary Domains: D1, D2, D5
- Canonical tools: `get_customer`, `lookup_order`, `process_refund`, `escalate_to_human`
- Pick task statement **1.4** (Multi-step workflows: enforcement and handoff patterns)
  - Topics: programmatic enforcement (hooks, gates) vs. prompt-based guidance
  - Skills: implement gates that physically block downstream tools until prerequisites met
  - Traps: "Relying on system prompt to enforce compliance-critical ordering · omitting root
    cause from handoffs · sequential investigation of independent concerns"

**Distractor mapping from Traps**:
- Trap 1 "system prompt" → common-misconception → Option B
- Trap 2 "omitting root cause" → under-engineered → Option D (reacts after the fact)
- Trap 3 "sequential vs parallel" / scope → right-idea-wrong-scope → Option C (availability ≠ ordering)

**Presentation**:

> Your customer support agent uses four tools: `get_customer`, `lookup_order`,
> `process_refund`, and `escalate_to_human`. Production logs show that in 11% of sessions
> the agent calls `process_refund` before `get_customer` has confirmed the customer's
> identity — occasionally crediting the wrong account. The current system prompt states:
> "Always verify customer identity via get_customer before processing any refund." The
> pattern persists.
>
> What change would most effectively eliminate the unauthorized-refund pattern?
>
> A) Add a programmatic gate that blocks `process_refund` from executing unless
>    `get_customer` has returned a verified customer ID in the current turn.
> B) Rewrite the system prompt rule with stronger language and add three few-shot
>    examples showing correct tool ordering across representative scenarios.
> C) Implement a routing classifier that detects "refund intent" and exposes only
>    `get_customer` and `lookup_order` during that phase, hiding `process_refund`.
> D) Wrap `process_refund` in an error handler that detects a missing customer ID
>    and retroactively calls `get_customer` before completing the refund.

*(Wait for the user's choice.)*

**After user answers B**:

> Correct Answer: A
> When a specific tool sequence is required for critical business logic, programmatic
> enforcement (gates, hooks) provides deterministic guarantees that prompt-based approaches
> cannot. Option B relies on probabilistic LLM compliance — the stem already shows that a
> system prompt rule fails 11% of the time, and more examples compound rather than fix this.
> Option C misidentifies tool *availability* as the root problem rather than tool *ordering*,
> which is not the actual constraint being violated. Option D reacts after the out-of-order
> call occurs rather than preventing it — symptom treatment, not root-cause resolution.
> Source: https://www.anthropic.com/engineering/building-effective-agents
