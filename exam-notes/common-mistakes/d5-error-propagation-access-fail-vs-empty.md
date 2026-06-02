# Error Propagation — distinguish access failures from valid empty results

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.3 (access failures vs. valid empty results)
> **Scenario:** Multi-Agent Research System · **Study area:** Error Propagation
> **Trap level:** 🔴 High — every distractor is a real resilience pattern applied at the wrong layer
> **Trap archetype:** Preserve semantic distinctions / failure ≠ empty
> **Source:** Claude Certified Architect practice exam, Q27 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
In a multi-agent system, a subagent's job is not just to do work but to report outcomes with enough fidelity that the coordinator can make good control decisions. The core skill here is designing an error/result schema that *preserves the semantics* of each outcome. A query that times out (an access failure) and a query that returns "0 results" (a valid, completed query with an empty set) are categorically different events, even though both are "non-positive" outcomes. Collapsing them — into a single metric, into hidden internal retries, or into a generic "failure" label — destroys the very signal the coordinator needs to allocate retries, time, and budget. The transferable principle: structure outcomes so the consumer can branch on them, never flatten distinct meanings into one channel.

## 2. Question
> During a materials research task, the web search subagent queries three source categories with different outcomes: academic databases returned 15 relevant papers, industry reports returned '0 results found,' and patent databases returned 'Connection timeout.' When designing error reporting to the coordinator, what approach enables the best recovery decisions?

## 3. Answer options
- **A.** Aggregate outcomes into a single success rate metric (e.g., '67% source coverage') with detailed logs available on request.
- **B.** Have the subagent retry transient failures internally and only report persistent errors. — ⚠️ **Most common wrong answer**
- **C.** Distinguish access failures (timeout) needing retry decisions from valid empty results ('0 results') representing successful queries. — ✅ **Correct**
- **D.** Report both the timeout and '0 results' as failures requiring coordinator intervention.

## 4. Correct answer — C
**Distinguish access failures (timeout) needing retry decisions from valid empty results ('0 results') representing successful queries.**

This is correct because a timeout (access failure) and '0 results' (valid empty result) are semantically distinct outcomes requiring different responses. Distinguishing them enables the coordinator to retry the timed-out patent database while accepting the empty industry report result as a valid and informative finding. Generalized: the error schema should encode *why* an outcome occurred, not just *whether* it was positive, so the coordinator can branch — retry on access failures, accept and reason over valid empty sets. Preserving outcome semantics at the reporting boundary is what makes intelligent, resource-aware recovery possible.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "have the subagent retry transient failures internally and only report persistent errors."** It is seductive because internal retry of transient errors is a genuine, well-known resilience pattern, so handling the timeout locally feels like the responsible, self-healing choice. The tell that it's wrong: silently absorbing retries hides the failure from the coordinator, which strips it of the visibility it needs to manage time and resource budgets and to own the retry policy — invisible retries can burn the budget without anyone deciding they should. The correct move keeps retry authority and budget control with the coordinator by reporting outcomes with their semantics intact, rather than resolving them at the subagent and escalating only a summarized verdict. Generalizing the archetype: never flatten distinct outcomes into one channel — preserve the distinction between an access failure and a valid empty result so the consumer can branch.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because a single coverage metric looks clean and "67%" feels actionable; the flaw is that aggregation erases the per-source semantics (timeout vs. empty vs. success), so the coordinator can't decide what to retry without digging through logs.
- **B.** Tempting because internal retry of transient errors is a real resilience pattern; the flaw is that hiding retries removes the coordinator's visibility into failures, breaking its ability to manage time/resource budgets and own retry strategy.
- **C.** Correct — separates access failures (timeout → retry decision) from valid empty results ('0 results' → accept as a finding), giving the coordinator exactly the signal it needs.
- **D.** Tempting because both outcomes are "not 15 papers" and escalating feels safe; the flaw is that labeling a valid empty result as a failure wastes coordinator attention and discards an informative finding (industry reports genuinely have nothing).

## 7. Key takeaways
- Design error/result schemas to preserve semantics: encode *why* an outcome happened, not just pass/fail, so the consumer can branch correctly.
- A valid empty result ('0 results') is a *successful* query and an informative finding — not a failure; never conflate it with an access failure like a timeout.
- Keep retry policy and budget decisions with the coordinator; subagents should report failures (including transient ones) rather than silently absorbing them.
- Flattening distinct outcomes — into one metric, hidden retries, or a blanket "failure" label — destroys the information needed for good recovery decisions.

## 8. Official documentation
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
