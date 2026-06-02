# Teaching Method — Reference

Long-form material for [[teaching-method]]. The SKILL.md body is the operating contract; this file holds the evidence base, the full technique table with sources, and how each technique maps onto the sibling skills' mechanics. Pull only the section you need.

## Table of contents

1. [The teaching goal & the operating loop](#1-the-teaching-goal--the-operating-loop)
2. [The evidence-based techniques (mechanism · apply · executor · source)](#2-the-evidence-based-techniques)
3. [Antipattern catalog](#3-antipattern-catalog)
4. [Bloom-level targeting for MCQ design](#4-bloom-level-targeting-for-mcq-design)
5. [Scaffolding, ZPD & the faded-guidance ladder](#5-scaffolding-zpd--the-faded-guidance-ladder)
6. [Metacognition & calibration protocol](#6-metacognition--calibration-protocol)
7. [How techniques map onto the existing mechanics](#7-how-techniques-map-onto-the-existing-mechanics)
8. [Sources](#8-sources)

---

## 1. The teaching goal & the operating loop

**Goal:** durable, transferable mastery of agentic-architecture design, measured against the **720/1000** pass bar (target ≥ 760 for margin) — *not* in-session accuracy and *not* the 60 practice questions themselves.

**Per-concept loop** (what [[exam-tutor]] runs; the science behind each step is §2):

```
TEACH the principle (generalized, cited official doc) — but keep it brief; teaching is not the study
QUIZ one fresh MCQ on it (via [[quiz-me]] conventions)        → retrieval practice + generation effect
WAIT for the learner's committed answer (+ confidence)        → retrieve-before-reveal; calibration
ASK "why right? why are the others wrong?"                    → elaboration / self-explanation / Socratic
FEEDBACK: name the distractor archetype, why it fails HERE,   → immediate, specific, growth-framed feedback
          why the key wins; cite a doc
UPDATE via [[progress-tracker]] (attempt + recall grade)      → spaced repetition (SM-2 + Leitner)
if miss: brief re-teach, re-queue ~2–3 items later            → spacing within session; desirable difficulty
interleave so no two consecutive items share a domain         → interleaving
fade hints/worked examples as mastery rises                   → worked-example effect / scaffolding
```

The session opens with a readiness/goal statement and closes with a before→after readiness delta, the weakest high-weight domain, and what's due next (summative reflection feeding the next spaced session).

---

## 2. The evidence-based techniques

Use these as the rationale library. **Executor** = the sibling skill that operationalizes the technique; this skill owns only the *why/how*. All source URLs were verified to resolve.

| # | Technique | Mechanism (why it produces durable learning) | Apply it here | Executor | Source |
|---|-----------|----------------------------------------------|---------------|----------|--------|
| 1 | **Retrieval practice (testing effect)** | Reconstructing knowledge from memory (not re-reading) strengthens and reconsolidates retrieval routes, producing more durable, transfer-ready memory. | Open every concept with a fresh MCQ or free recall before any re-teaching; force a committed answer; make generated questions the primary study mode, not re-reading notes. | [[quiz-me]], [[exam-tutor]] | https://www.learningscientists.org/blog/2016/6/23-1 |
| 2 | **Spaced / distributed practice** | Letting partial forgetting occur before each retrieval forces effortful reconstruction, slowing the forgetting curve vs massed cramming. | Resurface concepts at expanding intervals; re-quiz items the learner got right days ago; 🔴 misses return sooner, 🟢 mastered later. | [[progress-tracker]] (SM-2) | https://www.learningscientists.org/blog/2016/7/21-1 |
| 3 | **Interleaving (vs blocking)** | Mixing topics forces the learner to discriminate *which* principle applies, building the cue→strategy mapping blocked practice never exercises; improves transfer. | Shuffle MCQs across D1–D5 and the 6 scenarios; never drill one domain back-to-back even when it's weakest. | [[exam-tutor]], [[progress-tracker]] (queue) | https://www.learningscientists.org/blog/2016/8/11-1 |
| 4 | **Elaboration & self-explanation** | Explaining *why* an answer is true and how it connects to prior knowledge builds a richer associative network → more retrieval cues + transfer. | After each answer, have the learner justify the key and refute the distractors before you confirm; use the note's *Distractor analysis* as the elaboration target. | [[exam-tutor]] | https://learning.northeastern.edu/the-power-of-self-explanation/ |
| 5 | **Generation effect** | Information the learner produces themselves is retained better than the same information read, due to deeper processing at encoding. | Have the learner predict the rationale / draft the design decision in their own words first; occasionally ask them to write a plausible distractor for a concept. | [[exam-tutor]] | https://openbooks.library.baylor.edu/cognitionlab/chapter/generationeffect/ |
| 6 | **Desirable difficulties** | Conditions that *feel* harder (spacing, testing, interleaving, variation) drive long-term retention; fluency from easy study is an illusion of competence. | Keep retrieval effortful; accept that in-session accuracy may dip while mastery rises; tell the learner "this feeling hard is the method working." | [[exam-tutor]] | https://bjorklab.psych.ucla.edu/research/ |
| 7 | **Dual coding** | Pairing a verbal explanation with a complementary visual/analogical trace creates two reinforcing memory routes. | Pair each principle with a plain-language everyday analogy + a **stable** emoji anchor reused across topics so anchors compound (🔑 keys = least privilege · 🗼 control tower = coordinator · 🪜 ladder = lever-of-determinism · 🎤 speech + 📋 receipt = context); also sketch topologies and have the learner redraw the flow from memory. | [[deep-teach]], [[exam-tutor]] | https://www.learningscientists.org/blog/2016/9/1-1 |
| 8 | **Worked-example effect + faded guidance** | A full worked solution lowers extraneous load for novices; progressively removing steps transfers responsibility before "expertise reversal" makes examples redundant. | New scenario → teach the principle in plain language with a worked walkthrough → give a half-solved one to finish → then a cold question; fade per rising domain mastery (§5). | [[deep-teach]] (teach-first), [[exam-tutor]] | https://en.wikipedia.org/wiki/Worked-example_effect |
| 9 | **Socratic questioning** | Probing questions make the learner construct and validate their own reasoning → deeper understanding than being told the conclusion. | On a wrong answer don't reveal the key — ask "what does least privilege imply here?" / "what happens to errors as they propagate?" to lead self-correction. | [[exam-tutor]] | https://cetl.uconn.edu/resources/teaching-your-course/leading-effective-discussions/socratic-questions/ |
| 10 | **Metacognition & calibration** | Training the learner to predict their own performance closes the confidence↔accuracy gap (counters Dunning-Kruger), so they study the right things. | Ask for a confidence rating before each answer; flag confident-but-wrong items for priority re-queue; run an end-of-session "where were you sure but wrong?" wrapper (§6). | [[exam-tutor]], [[progress-tracker]] | https://derekbruff.org/vanderbilt-cft-teaching-guides-archive/metacognition/ |
| 11 | **Formative vs summative assessment** | Frequent low-stakes formative checks surface gaps early and let teaching adjust; summative checkpoints evaluate readiness. | Treat every quiz as formative data feeding mastery tracking (not a verdict); reserve timed 60-Q mocks as summative readiness checkpoints vs 720. | [[quiz-me]] (formative), [[mock-exam]] (summative) | https://www.cmu.edu/teaching/assessment/basics/formative-summative.html |
| 12 | **Immediate, specific, growth-framed feedback** | Timely feedback aimed at the task/process (not the person), framing errors as fixable, reduces misconception persistence and sustains effort. | Right after the commit: "you picked the symptom fix; the root cause is the tool contract." Name the archetype; never "good job"; a miss re-queues, it doesn't condemn. | [[exam-tutor]], [[quiz-me]] | https://www.cmu.edu/teaching/designteach/teach/assesslearningteaching.html |
| 13 | **Bloom's taxonomy (apply/analyze, not recall)** | Targeting higher cognitive levels builds the conditional, transferable knowledge scenario problems demand; understanding is exercised at the level it's tested. | Write MCQs at apply/analyze ("which orchestration fits this batch-vs-sync workload and why"), not definition recall; push the level up as a concept is mastered (§4). | [[quiz-me]] | https://derekbruff.org/vanderbilt-cft-teaching-guides-archive/blooms-taxonomy/ |
| 14 | **Scaffolding & the zone of proximal development** | Temporary support lets a learner succeed just beyond their independent reach; fading it as competence grows keeps practice in the productive zone. | Calibrate difficulty per-domain to sit just above current mastery; offer hints on hard items; withdraw support as the domain's mastery score rises (§5). | [[exam-tutor]], [[progress-tracker]] | https://www.simplypsychology.org/zone-of-proximal-development.html |
| 15 | **Feynman technique (teach-back)** | Explaining a concept in plain language as if teaching a novice exposes exactly where understanding breaks down, forcing a return to the source. | Periodically: "explain MCP tool design + least privilege to a junior dev." Where it stalls, send them to the cited official doc, then re-quiz that gap next round. | [[deep-teach]], [[exam-tutor]] | https://subjectguides.york.ac.uk/study-revision/feynman-technique |

---

## 3. Antipattern catalog

Each is a violation of a §2 technique. Naming the violated principle is what makes correcting it instructive.

| Antipattern | Violates | Why it fails |
|-------------|----------|--------------|
| Reveal the answer/rationale before the learner retrieves | #1, #6 | Removes the testing effect and the desirable difficulty; the learner recognizes, never recalls. |
| Massed re-reading / re-presenting notes instead of testing | #1 | Inflates fluency and confidence without building durable memory. |
| Blocking one domain/scenario back-to-back | #3 | Learner never practices choosing which principle applies; transfer collapses on a mixed exam. |
| Cram once, never resurface | #2 | Ignores the forgetting curve; gains evaporate before exam day. |
| Vague praise ("nice job") | #12 | No information; doesn't name the misconception or the rule, so nothing changes. |
| Teach/test only at recall level | #13 | The exam asks apply/analyze scenario questions; definition recall doesn't transfer. |
| Leave high confidence unchecked | #10 | Overconfident misconceptions (Dunning-Kruger) persist and mislead study time. |
| Throwaway distractors | #1, #12 | Distractors stop being diagnostic; build them from the six archetypes + the learner's recorded wrong answers. |
| Frame a miss as failure | #6, #12 | Discourages the effortful struggle that produces learning; a miss should just re-queue the concept. |
| Keep heavy hints/worked examples after mastery | #8, #14 | Expertise reversal; leaves the learner untested at true exam difficulty. |
| Optimize for "feeling smooth" over retention | #6 | Mistakes current performance for durable learning — the core illusion the method exists to defeat. |
| Assert an exam fact without an official citation | (CLAUDE.md rule) | Breaks the non-negotiable grounding contract; ungrounded "facts" propagate errors. |

---

## 4. Bloom-level targeting for MCQ design

The exam tests *design judgment*, so questions should sit at **Apply / Analyze / Evaluate**, not **Remember / Understand**. Climb the level as a concept is mastered.

| Level | Question stem feels like | Use when |
|-------|--------------------------|----------|
| Remember (avoid as the target) | "What does `tool_choice: any` do?" | only to confirm a definitional prerequisite |
| Understand | "Why does a coordinator preserve the failure-vs-empty distinction?" | first exposure to a concept |
| **Apply** | "Given this batch-vs-sync workload, which mechanism fits?" | default exam-level |
| **Analyze** | "This multi-agent system drops findings silently — which design flaw causes it?" | default exam-level |
| **Evaluate** | "Two engineers propose A and B; which is the better trade-off here and why?" | a mastered concept, for stretch |

Every generated MCQ is one correct key + three distractors drawn from **distinct** archetypes (common-misconception, right-idea-wrong-scope, true-but-irrelevant, over-engineered, under-engineered, symptom-not-root-cause). The archetypes are themselves a teaching device: each maps to a *named reasoning error*, so feedback can label it. Authoring lives in [[quiz-me]]; the archetype theory is shared with it.

---

## 5. Scaffolding, ZPD & the faded-guidance ladder

Keep each concept in the **zone of proximal development** — just beyond independent reach — and withdraw support as the per-domain mastery score (owned by [[progress-tracker]]) rises:

1. **Worked example.** Model a full reasoning walkthrough of one MCQ aloud: read the stem, eliminate each distractor by archetype, justify the key, cite the doc.
2. **Completion problem.** Give a half-solved item — e.g. the stem + the eliminated distractors — and have the learner finish the rationale and pick the key.
3. **Cold question with a hint available.** Full MCQ; offer a Socratic hint only if they stall.
4. **Unaided, exam-level.** No hint, exam timing/phrasing. This is where a concept must end before it counts as mastered.

Match the rung to mastery: low mastery → rung 1–2; rising → 3; high → 4. Holding rungs 1–2 after mastery causes **expertise reversal** (the worked example becomes noise) — that's why the ladder *fades*.

---

## 6. Metacognition & calibration protocol

1. **Pre-answer confidence.** Before revealing, ask the learner to rate confidence (e.g. low / medium / high), then commit.
2. **Calibration check.** Compare confidence to correctness. The dangerous quadrant is **high-confidence + wrong** — prioritize those for the soonest re-queue (a confident misconception is costlier than a known gap).
3. **Recall-quality grade (0–5)** passed to [[progress-tracker]] to drive SM-2 spacing:
   - **5** correct, fast, confident, can explain · **4** correct, minor hesitation · **3** correct but unsure/guessed · **2** incorrect but close (near-miss like right-idea-wrong-scope) · **1** incorrect, chose a common-misconception · **0** incorrect, no idea / true-but-irrelevant.
   - Re-queue anything ≤ 2.
4. **Exam wrapper (session close).** Ask: where were you sure but wrong? which domain felt hardest? what will you do differently next session? Feed the answers into the next spaced queue.

---

## 7. How techniques map onto the existing mechanics

The siblings already implement the science; this is the crosswalk so the rationale and the machinery stay in sync. **Do not fork the math or re-author questions here** — cite the executor.

| Existing mechanic (executor) | The technique it implements |
|------------------------------|-----------------------------|
| **SM-2 spacing** — `interval` 1 → 6 → round(interval·EF); `EF += 0.1 − (5−q)(0.08+(5−q)·0.02)`, floor 1.3 ([[progress-tracker]]) | Spaced repetition (#2): expanding intervals after each successful retrieval; a fail (`q<3`) resets to review tomorrow. |
| **Leitner box** 1→5, cadence ≈ 1d/2d/4d/9d/21d ([[progress-tracker]]) | Spaced repetition (#2) made human-readable: a missed item drops to box 1 (seen soon), a mastered one climbs to long cadence. |
| **Interleaved queue** — round-robin so no two consecutive items share a domain ([[progress-tracker]] `next`, [[exam-tutor]]) | Interleaving (#3). |
| **Priority = weightᵈ·(1−mastery)** + 🔴 boost + low-box boost ([[progress-tracker]]) | Desirable difficulty (#6) + scaffolding/ZPD (#14): spend effort where it's both weak and heavily weighted. |
| **Six distractor archetypes** ([[quiz-me]]) | Each archetype is a named reasoning error → enables specific, growth-framed feedback (#12) and Bloom apply/analyze stems (#13). |
| **Recall-quality 0–5 grade** ([[quiz-me]] → [[progress-tracker]]) | Metacognitive calibration (#10) + the input that drives SM-2 (#2). |
| **Laplace-smoothed mastery** `(correct+1)/(attempts+2)` ([[progress-tracker]], [[mock-exam]]) | Stable formative signal (#11) — avoids 0%/100% extremes from tiny samples so the next queue isn't whipsawed. |
| **Scaled score** `round(100 + overall·900)`, pass ≥ 720 ([[mock-exam]], [[progress-tracker]]) | Summative readiness checkpoint (#11) mapped to the real test norm. |
| **Retrieve-before-reveal** (all quiz skills) | Retrieval practice (#1) + desirable difficulty (#6). |
| **Teach-only mode / brief teach step** ([[exam-tutor]]) | Worked-example effect (#8): teaching is the scaffold, not the study; keep it short and fade it. |
| **Teach-first plain-language lesson — everyday analogy + stable emoji anchors + the user's own mistakes + a 🚩 trap-detector cheat-sheet** ([[deep-teach]]) | Worked-example/faded (#8) + dual coding (#7) + Feynman (#15); makes hard topics simple before any retrieval. |
| **`exam-notes/learned-rules.md` running cheat-sheet** (appended by [[deep-teach]]) | The consolidation artifact for spaced repetition (#2): the learner re-reads it at expanding intervals so material of any difficulty resurfaces; pair with [[progress-tracker]]'s `next` queue. |

---

## 8. Sources

All verified to resolve. Learning-science sources for teaching technique (the citation contract for *exam facts* — official Anthropic docs — is in SKILL.md and CLAUDE.md).

- Retrieval practice — https://www.learningscientists.org/blog/2016/6/23-1
- Spaced practice — https://www.learningscientists.org/blog/2016/7/21-1
- Interleaving — https://www.learningscientists.org/blog/2016/8/11-1
- Self-explanation — https://learning.northeastern.edu/the-power-of-self-explanation/
- Generation effect — https://openbooks.library.baylor.edu/cognitionlab/chapter/generationeffect/
- Desirable difficulties (Bjork Lab, UCLA) — https://bjorklab.psych.ucla.edu/research/
- Dual coding — https://www.learningscientists.org/blog/2016/9/1-1
- Worked-example effect — https://en.wikipedia.org/wiki/Worked-example_effect
- Socratic questioning (UConn CETL) — https://cetl.uconn.edu/resources/teaching-your-course/leading-effective-discussions/socratic-questions/
- Metacognition (Vanderbilt CFT archive) — https://derekbruff.org/vanderbilt-cft-teaching-guides-archive/metacognition/
- Formative vs summative (CMU Eberly) — https://www.cmu.edu/teaching/assessment/basics/formative-summative.html
- Feedback / assessing learning (CMU Eberly) — https://www.cmu.edu/teaching/designteach/teach/assesslearningteaching.html
- Bloom's taxonomy (Vanderbilt CFT archive) — https://derekbruff.org/vanderbilt-cft-teaching-guides-archive/blooms-taxonomy/
- Zone of proximal development & scaffolding — https://www.simplypsychology.org/zone-of-proximal-development.html
- Feynman technique (University of York) — https://subjectguides.york.ac.uk/study-revision/feynman-technique
