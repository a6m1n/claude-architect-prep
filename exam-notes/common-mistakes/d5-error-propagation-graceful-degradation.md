# Error Propagation — graceful degradation with coverage annotations

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.3 (error propagation)
> **Scenario:** Multi-Agent Research System · **Study area:** Error Propagation
> **Trap level:** 🔴 High — "ensure complete data before synthesis" sounds rigorous but over-escalates
> **Trap archetype:** Transparent degradation vs. silent masking
> **Source:** Claude Certified Architect practice exam, Q29 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question tests how a multi-agent system propagates partial upstream failures through to downstream consumers. In a fan-out/fan-in topology, a subagent rarely returns a clean all-or-nothing result — it returns *mixed-quality* output where some work succeeded and some did not. The architectural decision is whether the synthesis stage hides the gaps, blocks on speculative recovery, hard-fails, or transparently annotates what is and isn't supported. The transferable principle is *graceful degradation with transparency*: preserve the value of completed work while propagating uncertainty so the end user (or a downstream agent) can make an informed confidence judgment. It also tests separation of concerns — which component owns retry policy.

## 2. Question
> The web search subagent returns results for only 3 of 5 requested source categories (competitor websites and industry reports succeeded, but news archives and social media feeds timed out). The document analysis subagent successfully processed all provided documents. The synthesis subagent must now produce a findings summary from this mixed-quality input. What's the most effective error propagation strategy?

## 3. Answer options
- **A.** Structure the synthesis output with coverage annotations indicating which findings are well-supported versus which topic areas have gaps or unavailable sources. — ✅ **Correct**
- **B.** Have the synthesis subagent request the coordinator retry the timed-out sources with extended timeouts before proceeding, ensuring complete data coverage before synthesis begins. — ⚠️ **Most common wrong answer**
- **C.** Proceed with synthesis using only the successful sources, generating output without indicating which data was unavailable.
- **D.** Have the synthesis subagent return an error to the coordinator indicating incomplete upstream data, triggering a full retry or task failure.

## 4. Correct answer — A
**Structure the synthesis output with coverage annotations indicating which findings are well-supported versus which topic areas have gaps or unavailable sources.**

Per the official explanation, structuring the synthesis output with coverage annotations embodies graceful degradation with transparency, allowing downstream consumers and end users to understand which findings are well-supported and which topic areas have gaps. This approach preserves the value of completed work while propagating uncertainty information so informed decisions can be made about confidence levels. Generalized: when upstream input is partial but still useful, the right error-propagation strategy is to *deliver the available value plus explicit metadata about coverage and confidence* — not to discard, hide, or block on it.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "have synthesis ask the coordinator to retry the timed-out sources before proceeding, ensuring complete data coverage."** It is seductive because "complete data coverage" sounds like the rigorous, thorough choice — surely a findings summary is more trustworthy when nothing is missing. The tell that it's wrong: a downstream subagent dictating the coordinator's retry policy breaks separation of concerns, and the move assumes the retries will succeed while stalling output that is already usable. Anyone reasoning "don't synthesize until the input is whole" lands on B. The correct move is transparent graceful degradation — ship the completed work and annotate the gaps — rather than silently masking the shortfall or blocking on speculative recovery.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — transparent graceful degradation; ships completed work while annotating gaps and confidence.
- **B.** Tempting because "complete data" sounds rigorous, but a subagent dictating coordinator retry policy breaks separation of concerns, assumes retries succeed, and stalls useful output.
- **C.** Tempting because it ships results fast, but silently omitting the unavailable sources removes the uncertainty signal and misleads consumers about how well-supported the findings are.
- **D.** Tempting as a "fail loud" stance, but hard-failing or triggering a full retry over a *partial* success throws away completed work and over-escalates a degraded-but-usable result.

## 7. Key takeaways
- With partial upstream success, prefer transparent graceful degradation — annotate coverage and confidence — over silent omission, hard failure, or speculative recovery.
- Propagate uncertainty as structured metadata so downstream agents and end users can calibrate trust, rather than presenting partial results as complete.
- Respect separation of concerns: retry/timeout policy belongs to the coordinator, not to a downstream subagent.
- Don't block on speculative retries that assume success and delay value; ship what's verified now and flag the gaps.

## 8. Official documentation
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
