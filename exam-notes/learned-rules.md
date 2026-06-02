# Learned rules — exam cheat-sheet

> Core exam principles, in plain language + how to spot them on the exam.
> Each block is tied to an exam domain and to the official documentation.
> Updated as new topics are covered.

---

## Topic 1. Error Propagation — handling errors in multi-agent systems
**Domain:** D1/D5 · task 5.3 · scenario Multi-Agent Research
**Common miss:** the tempting move is "hide / overdo it"

### Main principle
> Handle an error at the **lowest level that can actually fix it**; everything else — **escalate upward with context**, keeping the meaning of the outcome. Never destroy information that an upper layer needs to make a decision.

A subagent is not just a worker but an **outcome reporter**. Its signal must be precise enough that the coordinator can decide (retry / skip / accept / degrade) without re-investigating the problem itself.

### Three different questions — don't mix them up
1. **Who fixes it?** (mechanics) — a transient failure within the agent's own task → it fixes it itself.
2. **Does the coordinator know what happened?** (visibility) — **always** report, even if you fixed it yourself.
3. **Who decides how much to retry?** (policy/budget) — if a shared resource is spent → the coordinator decides.

> "Fixed it myself" ≠ "stayed silent". A local retry is fine. A **silent** retry is not.

### Transient vs permanent failure (in plain words)
- **Transient:** it goes away if you try again. Like "refresh the page" — a timeout, "server busy", a one-second hiccup. → the agent retries itself 1–2 times.
- **Permanent:** retrying won't help. A password-protected/corrupt file, no access. → don't retry, skip or escalate.
- **Test:** "If I just retry, is there a chance it works?" Yes → transient. No → permanent.

### Timeout — depends on scale
- Cheap and within the agent's own task (parse **one** file) → **retry yourself** 1–2 times.
- Spends the system's shared budget (expensive queries to external databases) → **report to the coordinator**, it decides.

### Keep the meaning of the outcome — don't collapse it
Four outcomes require **different** reactions; you can't merge them into "success/failure":

| Outcome | What it is | Coordinator's reaction |
|---|---|---|
| 15 papers | success with data | use it |
| `0 results` | **successful** query, a valid finding | accept, don't retry |
| `timeout` | access failure | decide on retry/budget |
| corrupt/password-protected | unfixable | escalate with a note |

The sin: merging `0 results` and `timeout` into one metric ("67% coverage") or into "failure".

### Partial success → graceful degradation with transparency
3 of 5 sources answered? **Ship what's ready + annotate the gaps** (which conclusions are supported, where the holes are). Don't hide the gaps, don't hard-fail everything, don't block on a speculative retry. The retry policy belongs to the coordinator, not to a downstream agent.

### Trap filter for the exam
An option that **hides / averages / blocks for the sake of completeness / moves the decision to the wrong layer** → distractor.
The correct one is almost always: **deliver the ready value + structured metadata about what failed and why.**

**Documentation:** [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents) · [Multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)

---

## Topic 2. Tool Distribution — the principle of least privilege
**Domain:** D2 · tasks 2.1/2.3 · scenario Multi-Agent Research
**Typical trap:** people swing between "remove everything" and "give everything", and are tempted to fix it with the prompt

### Rule A. An agent's capabilities = its tools, not the prompt
What an agent **can** do is determined by its tools, not by an instruction. A prompt that says "don't do X" is a request; the capability remains.
**Analogy:** tools = keys. A master key + a note "only go into your own office" is useless — hand over only the key to that one office.
**Example:** `run_sql` (full access) + a prompt "read only" is bad, it can `DELETE`. Give `get_orders(customer_id)` — it physically can't delete.

### Rule B. The key exactly the size of the lock
A tool = the agent's job, **no wider and no narrower**.
- Too wide → it does extra things.
- Removed entirely → it can't do its job.
- Just right → a narrow tool fit to the task.
**Example:** to load a PDF → not `fetch_url` (any URL, it'll wander off to Google), not "forbid URLs" (you broke the job), but `load_document` with a format check.

### Rule C. A tool's name/description = the "signboard" for routing
The coordinator decides who to hand a task to based on tool names and descriptions. If descriptions overlap → the coordinator guesses.
**Analogy:** two doors with similar signs → the visitor goes to the wrong one. Rewrite the signs, don't post a traffic cop.

### Rule D. Fix the root, not the symptom
The temptation to patch from above (a hint in the prompt, a filter, another classifier) is fragile. The root is usually in the tool itself.

### Three common mistakes — two opposite extremes
| Scenario | Common wrong choice | Extreme | The right way | Rule |
|---|---|---|---|---|
| over-broad `fetch_url` | remove `fetch_url`, everything through the coordinator | **too little** privilege | replace with `load_document` + validation | B+A |
| confusing routing | few-shot examples in the coordinator's prompt | **wrong layer** (the prompt) | rename to `extract_web_results` + rewrite the description | C+D |
| fact-checking | give **all** search tools | **too much** privilege | a narrow `verify_fact` for 85%, hard cases via the coordinator | B+D |

The shared "why it's correct": in all three — **reshape the tool itself to fit the agent's job**, not remove it / not give everything / not patch with the prompt.

### Trap filter for the exam
1. Is there "change/narrow the tool itself or its description"? → almost always the answer.
2. Prompt hint / few-shot / domain filter / a new classifier → symptom, distractor.
3. Remove a needed capability or give all the tools → extreme, distractor.

**Documentation:** [Writing effective tools for agents](https://www.anthropic.com/engineering/writing-effective-tools-for-agents) · [Define tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools)

---

## Topic 3. Determinism — code/hooks and explicit criteria vs "persuading" the prompt
**Domain:** D4 (+D1) · tasks 4.1/4.2/1.4 · scenarios CI and Customer Support
**Common traps:** reaching for few-shot or a human-in-the-loop where an explicit criterion (or code) is what's needed; for contrast, a programmatic block is the correct hard-guarantee move

### Main idea
An LLM is **probabilistic**: it follows an instruction "most of the time", not "always". Where you need reliability — **remove the uncertainty**, replace the "model's mood" with a clear rule.
**Analogy:** telling an employee "be more careful with refunds" (they'll forget) vs making it so the "refund" button can't be pressed without identity confirmation (you can't forget).

### Reliability ladder (from worst to best) — the key to the whole cluster
| Level | What | Reliability |
|---|---|---|
| 1. Vague instruction | "check that the comments are accurate" | the model improvises |
| 2. Few-shot examples | "here are 3 examples of bad ones" | pattern-matches, doesn't generalize |
| 3. **Explicit criterion/rubric** | "flag ONLY IF the stated behavior contradicts the code" | the model applies the rule → works on new cases |
| 4. **Code / hook (determinism)** | a programmatic block on the call | 100% guarantee, can't be broken |

> The gist: **replace "vibe/probability" with an explicit definition.** Code is the strongest form (determinism), an explicit criterion is a prompt-level form. Few-shot/filters/a human after the fact are weaker, they don't define the rule.

### Two questions — which level you need
1. **Need a 100% guarantee** (irreversible action, call ordering, safety)? → **level 4 (code/hook).** The prompt = probabilistic, won't do.
2. **The model *judges* inconsistently** (classification, "what counts as a problem" is fuzzy)? → **level 3: define the criterion explicitly.** Don't patch with few-shot, don't call a human, don't slip in metadata.

### Examples
- "Flag stale comments" (fuzzy) → correct: "flag only if the stated behavior **contradicts** the actual code".
- Inconsistent severity → correct: a rubric = a criterion for each level + a concrete code example under each.
- "First check the customer, then the refund" (12% missed on the prompt) → correct: **code** blocks `process_refund` until `get_customer` has returned a verified ID.
- Once the rule is defined — examples are useful as **anchors** for the boundaries. Examples **complement** the rule, they don't replace it.

### What "an explicit criterion" vs examples means — analogies (this part is hard)
**The difference:** examples (few-shot) = "**show**" (here are samples, catch the similar ones). Criterion/rubric = "**state the rule**" (a precise yes/no condition). The criterion answers "**what counts as** a problem", examples answer "**how** a problem looks".

**Analogy 1 — a guard at the door.** Give them 3 photos of teenagers "don't let these in" → a fourth one who isn't in the photos shows up, the guard **guesses**. Give them the rule "don't admit anyone born after 2007" → it works for **anyone**, no photos needed. → a rule applies to people you've never seen; examples only to similar ones.

**Analogy 2 — a ripe banana.** Photos of three ripe bananas vs the rule "ripe = soft to the touch AND smells sweet". The rule works even for an unfamiliar variety.

**Breaking down the criterion itself** "flag ONLY IF the stated behavior contradicts the actual code":
- a comment = a **claim** about the code (`// returns a sorted list`)
- the code = the **actual behavior** (returns unsorted)
- claim ≠ reality → **contradiction → flag**
- `// TODO: rewrite` — this is not a claim about behavior → no contradiction → **don't flag** (removes false positives)
- `// caches`, but the cache was removed → contradiction → **flag** (catches misses)
One rule sorts even new, unseen comments on its own — there's no need to enumerate cases.

**Lifehacks — how to recognize/build a criterion:**
1. **The two-strangers test:** a good criterion = two different people, without colluding, assign the same label. If they guess → still fuzzy.
2. **"What counts?" vs "How does it look?"** — an answer with "what counts as a problem" (a rule) is almost always stronger than an answer with "here are samples".
3. **Template:** "Flag [X] ONLY IF [a measurable, checkable condition]". If you can point at it and verify yes/no → a criterion. "Good/current/quality" without a definition → fuzziness.
4. **A robot with no intuition:** imagine a dumb robot following the instruction strictly to the letter. A vague one will fail it, a criterion it will execute. If it works only because "the model will figure it out" → not explicit enough.

### Common mistakes
| Scenario | Common wrong choice | The trap | The right way | Level |
|---|---|---|---|---|
| stale-comment flagging | few-shot examples | lvl 2 instead of 3 (didn't define the rule) | explicit criterion "contradicts the code" | 3 |
| inconsistent severity | a human calibrates after the fact | left the ladder, doesn't scale | severity criteria + a code example per level | 3 |
| refund ordering ✅ | a programmatic block | **correct** | (same) | 4 |

Common gap: when the model judges inconsistently — the temptation is to reach for **examples/a human** instead of an **explicit criterion**. Remember: **the rule first, then examples as anchors.**

### Trap filter for the exam
1. Need a 100% guarantee → the answer is "in code / a hook / a programmatic block". A prompt instruction = distractor (12% misses).
2. Inconsistent classification → the answer is "an explicit criterion/rubric". Distractors: few-shot without a rule, git blame/metadata, filters, a human after the fact, relative scoring within a single PR.
3. If the rule is already defined → concrete examples per level = legitimate reinforcement (don't confuse with "examples only instead of a rule").

**Documentation:** [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) · [Strict tool use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/strict-tool-use) · [Prompt engineering overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

---

## Topic 4. Context Engineering — restructure, don't throw away
**Domain:** D5 · task 5.1 · scenarios Multi-Agent and Customer Support
**Common trap:** reaching for compression/summarization when the fix is to restructure; for contrast, a durable facts block outside compression is the correct move

### Main idea
When the model "doesn't see" what's needed — the problem isn't the volume, it's the **layout** of the context. Compression (summarization) = **irreversible loss of detail**, it's a **trap**. The right move is to **restructure**, not throw away.

### Problem 1: "Lost in the middle" (position)
The model reads unevenly: it remembers the **beginning** (primacy) and the **end** (recency), and loses the **middle**.
**Analogy:** a 3-hour lecture — people remember the intro and the finale, not the middle.
**Fix (structurally, NOT by throwing away):** a summary of the key points — **at the beginning** (primacy) + **explicit headings** for sections, so the model can find the middle. Move and index the detail, don't delete it.

### Problem 2: precise facts get lost under compression (layering)
Compression is good for a narrative, but **blurs precise details** ("15% discount" → "discussed pricing").
**Analogy:** meeting minutes — you keep the key numbers in a separate table verbatim, apart from the recap.
**Fix:** 2 layers — **durable facts** (a structured block, verbatim in every prompt, OUTSIDE compression) + narrative (can be compressed). First decide what must never degrade → keep it out of the compression path.

### Cross-cutting principle
> Don't throw away information for the sake of layout. Restructure (front-load + headings), keep critical facts as a separate verbatim layer outside compression. **Compression is a trap, not a solution.**

### Common mistakes
| Scenario | Common wrong choice | The right way | Lesson |
|---|---|---|---|
| info ignored in the middle | compress everything to <20K tokens | a summary at the beginning + section headings | ❌ traded a fixable position problem for an irreversible loss of content |
| precise fact lost over time | a durable "case facts" block outside compression | (same) ✅ | correctly rejects compression/tweaking the threshold |

**Common risk:** with "lots of context" the temptation is to reach for **compression**. Remember: for context, compression is almost always a distractor; think "how to rearrange and label it".

### Trap filter for the exam
1. The model ignores info that IS there (especially the middle) → a position problem → the answer is "**a summary at the beginning + headings**". Not compress/stream/rotation.
2. A precise detail got lost over time → a lossy-compression problem → the answer is "**a durable facts block outside compression**". Not "tune the summarizer", not "raise the threshold", not "retrieval on triggers".
3. Any answer "compress harder / summarize / raise the threshold" for a context problem → almost always a distractor.

**Documentation:** [Effective context engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) · [Context windows](https://platform.claude.com/docs/en/build-with-claude/context-windows)

---

## Topic 5. Escalation — escalate when you CAN'T, not when you DON'T WANT TO
**Domain:** D5 · task 5.2 · scenario Customer Support
**Common trap:** escalating out of discomfort rather than a genuine gap in authority or data; for contrast, fixing calibration with explicit criteria + few-shot is the correct move

### The main idea, simply
Escalation = "call the manager". You call in two cases: (1) **no authority** (no rule for the situation, you can't make one up), (2) **no information** (too little data to act safely).
You DON'T call: the customer is angry / the conversation is awkward / two questions / "what if they change their mind".
> **Golden rule: escalate when you CAN'T (no rule/data), not when you DON'T WANT TO (it's uncomfortable).**

### Decision frame: the "facts × rule" table
| | Rule EXISTS and applies | NO rule / silent / ambiguous |
|---|---|---|
| **Facts present** | ✅ Act (run the procedure) | 🆘 Escalate (no authority to invent a rule) |
| **Few facts** | 🔎 Gather data → act | 🔎 Gather data → if there's no rule → escalate |

The clearest escalation signal — **facts are present but the rule is silent** (top-right corner).

### Trap-detector lifehack
🚩 A justification "escalate because it's uncomfortable / the customer will be upset / the topic is sensitive / the relationship" = **emotional avoidance** = almost always a trap. Feelings aren't the trigger; the trigger is a hole in authority or data.

### Common mistake
| Scenario | Common wrong choice | The right way | Lesson |
|---|---|---|---|
| silent policy on price match | escalate, because presenting the tracking "will hurt the relationship" (D) | price match while the policy is silent (C) | ❌ there are facts + a procedure → you must act; awkwardness ≠ a reason to escalate |

*Other traps in that scenario:* A (two questions = just work back-to-back); B ("what if they change their mind" = guessing about the future).

### Bonus: how to fix bad calibration (the correct contrast case)
Symptom: it escalates easy cases, takes on hard ones → the boundary is fuzzy. Fix (A): **explicit escalation criteria + few-shot in the system prompt**.
**Link to Topic 3:** here few-shot is in the correct answer (in Topic 3 it was wrong), because escalation is a **judgment** (a fuzzy boundary), not a hard invariant. The order is the same: **the criterion first, examples as anchors.**
*Traps:* B (self-confidence 1–10 — calibrates poorly); C (sentiment — anger ≠ difficulty); D (a separate classifier — over-engineered).

### Reflex cheat-sheet
> "Can't" (no rule/data) → escalate. "Don't want to" (awkward, angry customer) → decide yourself.

### Trap filter for the exam
1. When to escalate → "the rule is silent / no authority / not enough data". 🚩 Reject "uncomfortable / relationship / will be upset / what if they change their mind / two questions".
2. How to fix calibration → "explicit criteria + few-shot in the prompt". 🚩 Reject confidence-score, sentiment, a separate classifier.

**Documentation:** [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents) · [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

---

## Topic 6. Coordinator / hub-and-spoke — structural vs operational
**Domain:** D1 (27%) · tasks 1.2/1.6 · scenario Multi-Agent Research
**Common trap:** picking an operational perk (retry/batch/cache) as the coordinator's defining advantage instead of the structural one; for contrast, the structural advantages are the correct answer

### The main idea, simply
The coordinator = the **control tower**: all subagents communicate through it, not directly. Why:
1. **sees everything** (visibility);
2. **handles errors uniformly** (one place);
3. **decides who knows what** (information gating = context isolation).
Plus the coordinator **owns the decomposition** of the task → topic coverage.

### Key distinction: STRUCTURAL vs OPERATIONAL
- **Structural** = arises from the topology (everything through one node), can't be had otherwise → visibility, uniform error handling, gating.
- **Operational** = can be bolted on at any layer → retries, batching, cache, logging, serialization.

🚩 **"False dichotomy" detector:** an option says "**only** the coordinator can X" / "direct calls **can't** X", where X is an operational feature (retry/batch/cache) → trap. Check: "is it really only through the coordinator?" A retry can be wrapped around any call.

### Lifehack "read the failure backwards"
All the pieces were done correctly, but the whole doesn't cover the topic → the culprit isn't the worker, but the **split** (the coordinator, further upstream). A subagent is no more complete than the piece it was given.

### Common mistake
| Scenario | Common wrong choice | The right way | Lesson |
|---|---|---|---|
| "why centralize?" | retry "only through the coordinator" (D) | visibility + uniform error handling + gating (B) | ❌ false dichotomy: picked an operational perk instead of the structural advantage |

*Other traps in that scenario:* A (serialization "only the coordinator" — an invented constraint); C (batching — an orthogonal optimization, not the defining advantage).

### Reflex cheat-sheet
> Coordinator = tower: sees everything, fixes in one place, decides who knows what + slices the task.
> Retry/batch/cache — anywhere (operational). Visibility/error-handling/gating — only through the hub (structural).

### Trap filter for the exam
1. "Why centralize?" → the answer is about visibility / uniform error handling / information control. 🚩 Reject retry/batch/cache as "unique" (false dichotomy).
2. "All the agents are fine, but the result is incomplete" → the root is in the coordinator's decomposition, not in the workers.
3. The words "only through X" / "can't" + an operational feature → 🚩 false dichotomy.

**Documentation:** [Multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) · [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents) · [Agent SDK subagents](https://code.claude.com/docs/en/agent-sdk/subagents)

---

## How to read a question without getting confused (test strategy)
A long scenario = ~90% decoration. Protocol:
1. **Read from the end** — the last sentence = what is really being asked (most effective fix? / main advantage? / when to X?).
2. **Find the 1 symptom sentence** (misses 12%, routed wrong 45%, loses the middle, scores are inconsistent). The rest is background.
3. **Name the principle BEFORE the options** (error propagation / tool distribution / determinism / context / escalation / hub structural-vs-operational).
4. **Predict the fix before reading the options**, then look for a similar one — so the distractors don't pull you away.
5. **Elimination method:** throw out the 2 clearly weak ones (over-engineered / symptom-patch), and of the 2 remaining decide by "the right layer + the minimal dose".

### 🚩 Trap detectors (one line each)
- "Most effective / root cause" → the root, not a symptom-patch (retry/filter/hint).
- A prompt where a tool/code is needed → trap (the lever ladder).
- "Compress/summarize" for a context problem → trap (rearrange).
- "Only X can / can't" + an operational feature → false dichotomy.
- "Escalate because it's uncomfortable/the relationship" → emotional avoidance.
- "Give all / remove entirely" → extreme.
- "always/never/only/entirely" → suspicious.
- A failure percentage (12%, 8%) in the question → a hint that "code/structure is needed, not a prompt".

> **Read from the end → 1 symptom → name the principle → predict the fix → filter out symptoms and extremes → pick the root with the minimal dose.**

---

## The cross-cutting meta-idea of all the topics
Most distractors on this exam are either **a fix at the wrong layer** or **the wrong dose**:
- treating with a prompt what should be solved by a tool/code (symptom vs root);
- hiding/averaging information that an upper layer needs;
- the extremes "remove everything" / "give everything" instead of precise tuning to the task.
The correct answer is **a minimal, targeted intervention at the right layer**, preserving the needed information and capabilities.

### The master cheat-sheet: "which lever to pull?" (unites all the topics)
When an agent misbehaves, choose **the weakest lever that's enough** — but if you need a guarantee, go higher. Layers from soft to hard:

| # | Lever | When it's the right answer | Guarantee |
|---|---|---|---|
| 1 | **Prompt instruction** | a soft nudge where a rare deviation is acceptable | low (probabilistic) |
| 2 | **Few-shot examples** | show the format / anchor the boundary — but ONLY together with a criterion | low (recognizes the similar) |
| 3 | **Explicit criterion / rubric** | an inconsistent *judgment* (classification, escalation) | medium (the rule generalizes) |
| 4 | **Tool design** (narrow/rename/validation, least privilege) | the agent does extra things / gets confused on routing / over-broad access | high (by construction) |
| 5 | **Code / hook (determinism)** | a 100% invariant is needed: call ordering, irreversible action, safety | absolute |

**How to use it on the exam (a reflex):**
- Symptom "the model *judges* inconsistently" → lever **3** (a criterion), not 1–2.
- Symptom "the agent *can* do extra things / wrong routing" → lever **4** (the tool), not the prompt.
- Symptom "the invariant is broken in N% of cases" → lever **5** (code), not the prompt/few-shot.
- 🚩 An answer that treats with a prompt what requires lever 4–5 → trap (symptom, not root).
- 🚩 An answer that jumps to lever 5 where 3–4 is enough, or removes something needed → over-engineered / extreme.

> Mantra: **the right layer + the minimal sufficient dose.** Weaker — won't work; stronger without need — over-engineered.
