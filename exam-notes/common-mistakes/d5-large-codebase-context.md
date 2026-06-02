# Counteract context degradation with scratchpads, subagent delegation, and `/compact`

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.4 (context in large codebase exploration)
> **Scenario:** Developer Productivity with Claude · **Study area:** Large-codebase context (scratchpads, subagent delegation, `/compact`)
> **Trap level:** 🟡 Medium — three plausible "give the model more room/memory" fixes, but only one curates the budget
> **Trap archetype:** Externalize state vs. cram the window
> **Source:** Concept note grounded in the official exam guide, Task 5.4.

## 1. Topic — what this really tests

During extended exploration of a large/legacy codebase, the agent's context window fills with verbose file reads and discovery output, and answers degrade: the model starts referencing *"typical patterns"* instead of the specific classes and flows it actually found earlier. This tests the mitigation toolkit — persisting key findings to **scratchpad files** so they survive context boundaries, **delegating verbose exploration to subagents** (which read in their own window and return only summaries), **summarizing between phases**, and **`/compact`** to shrink a bloated session. It frames context as a finite budget the architect must actively curate, not let drift.

## 2. Question

> You are using Claude Code to explore a large legacy service. After a long session of reading files and tracing flows, the agent begins answering questions about the refund pipeline with generic statements about how "a typical refund flow usually works" instead of naming the specific classes it identified an hour earlier. What is the most effective way to restore and sustain accurate, codebase-specific answers?
>
> - **A.** Have agents persist key findings to scratchpad files and delegate further verbose exploration to subagents, summarizing findings between phases and reloading them into context.
> - **B.** Keep asking follow-up questions in the same session and trust the model to recall the earlier details once prompted firmly enough.
> - **C.** Paste the entire repository into the context window so every class is always available.
> - **D.** Raise `max_tokens` on the requests so the model has more room to remember the earlier discoveries.

## 3. Answer options

- **A.** Persist findings to scratchpad files + delegate verbose exploration to subagents + summarize between phases. — ✅ **Correct**
- **B.** Keep going in the same session and prompt harder for recall.
- **C.** Paste the whole repo into context. — ⚠️ **Most common wrong answer**
- **D.** Raise `max_tokens`.

## 4. Correct answer — A

The degradation symptom (generic "typical pattern" answers replacing specific findings) is **context rot**: as the window fills, recall of specific tokens drops. The fix is to *externalize durable findings* into scratchpad files that survive context boundaries, *isolate verbose work* by spawning subagents that explore in their own clean windows and return only summaries, and *compress* — summarize each phase before the next and reload those summaries, optionally running `/compact`. The principle generalizes: actively curate a finite context budget rather than letting raw discovery output accumulate.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **C — "paste the entire repository into the context window so every class is always available."** It is seductive because it sounds like it directly addresses the gap: if the model forgot the specific classes, just make sure all of them are present at all times. The tell that it's wrong is that it treats a saturated window as a too-small window — but the recall failure was *caused* by an overloaded context, so dumping the whole repo maximizes the very token load that produced context rot and accelerates the degradation. The correct move runs the opposite direction: shrink and curate the budget by externalizing findings to scratchpads, delegating verbose reads to subagents, and summarizing between phases. The same cram-the-window reflex picks D (more `max_tokens`) — both confuse "more raw context" with "better recall," when the architect's job is to externalize state, not cram the window.

## 6. Distractor analysis — look-alikes to watch for

- **A — correct.** Combines all three documented levers: scratchpad persistence, subagent delegation, inter-phase summarization.
- **B — wrong.** "Prompt harder" does not reverse context rot; the specific details are already buried under verbose output. Plausible because re-prompting *sometimes* helps, but it ignores the structural cause.
- **C — wrong.** Pasting the whole repo *worsens* the problem — it maximizes the token load that caused recall to degrade in the first place.
- **D — wrong.** `max_tokens` caps *output* length, not memory; it has nothing to do with input-context recall. A pure misconception distractor.

## 7. Key takeaways

- **Symptom = context rot:** generic "typical pattern" answers replacing the specific classes/flows discovered earlier signal a saturated window.
- **Scratchpad files** persist key findings across context boundaries; reference them when answering later questions.
- **Subagent delegation** isolates verbose exploration ("find all test files," "trace refund flow dependencies") so the main agent keeps only high-level coordination.
- **Summarize between phases** and inject the summary into the next phase's initial context; use `/compact` when discovery output bloats the session.
- **Crash recovery:** have each agent export structured state to a known location; the coordinator loads a **manifest** on resume and injects it into agent prompts.

## 8. Official documentation

- Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Claude Code common workflows (delegate research to subagents) — https://code.claude.com/docs/en/common-workflows
