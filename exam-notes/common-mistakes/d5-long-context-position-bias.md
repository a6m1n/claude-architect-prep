# Long-context position bias — front-load summaries and add section headers

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.1 (mitigating "lost in the middle" position effects)
> **Scenario:** Multi-Agent Research System · **Study area:** Long Context Position Effects
> **Trap level:** 🔴 High — "just shrink the context" sounds safe but quietly discards the findings
> **Trap archetype:** Position bias / lost-in-the-middle
> **Source:** Claude Certified Architect practice exam, Q17 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
Long-context models do not attend uniformly across their input. Attention is strongest at the very start (primacy) and the very end (recency) of a long sequence, and weakest in the middle — the well-documented "lost in the middle" effect. When you aggregate ~75K tokens of subagent output, content that lands in the middle 50K is structurally disadvantaged regardless of how relevant it is. The architect's job is to fix this with input *structure*, not just shorter input: position the most critical material where attention is reliable, and give the model navigation cues (headers) so it can locate middle content on demand. This transfers to any aggregation/synthesis stage where multiple sources are concatenated into one context.

## 2. Question
> Production monitoring reveals inconsistent synthesis quality. When aggregated results total ~75K tokens, the synthesis agent reliably cites information from the first 15K tokens (web search headlines and snippets) and the final 10K tokens (document analysis conclusions), but frequently omits critical findings that appear in the middle 50K tokens—even when those findings directly address the research question. How should you restructure the aggregated input?

## 3. Answer options
- **A.** Place a key findings summary at the beginning of the aggregated input and organize detailed results with explicit section headers for easier navigation. — ✅ **Correct**
- **B.** Summarize all subagent outputs to under 20K tokens total before aggregation, allowing content to stay within the model's reliable processing range. — ⚠️ **Most common wrong answer**
- **C.** Stream subagent results to the synthesis agent incrementally, processing web search results to completion before introducing document analysis findings.
- **D.** Implement rotation that alternates which subagent's results appear first across different research tasks, ensuring both sources receive primacy positioning equally over time.

## 4. Correct answer — A
**Place a key findings summary at the beginning of the aggregated input and organize detailed results with explicit section headers for easier navigation.**

Placing a key findings summary at the beginning of the aggregated input leverages the primacy effect, ensuring critical information occupies the most reliably attended position. Adding explicit section headers throughout the aggregated input helps the model navigate and attend to middle-section content, directly mitigating the "lost in the middle" phenomenon. The generalizable principle: when position bias is the problem, fix it structurally — move the highest-value content into high-attention positions and index the rest so the model can find it, rather than throwing information away.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "summarize all subagent outputs to under 20K tokens before aggregation."** It is seductive because shorter context literally dodges the lost-in-the-middle effect: if everything fits in the model's reliably attended range, there is no neglected middle to worry about. The tell that it's wrong: blanket compression to 20K discards the very detailed findings the synthesis agent needs, trading a position problem that can be fixed structurally for an irreversible content-loss problem that is strictly worse. The correct move is to restructure — front-load a key-findings summary into the primacy slot and add section headers to index the middle — preserving every detail while solving the position bias.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — front-loads a summary (primacy) and adds headers to index the middle, mitigating position bias without losing detail.
- **B.** Tempting because shorter context dodges lost-in-the-middle, but blanket compression to 20K discards the very findings you need; information loss can exceed the position loss.
- **C.** Streaming/sequential processing sounds like it preserves order, but it doesn't guarantee critical findings land in an attended position — and processing web results "to completion" first reintroduces a middle for the document findings.
- **D.** Rotation only changes *which source* gets primacy across tasks; within any single task the bulk of findings still sits in the unattended middle, so it doesn't solve the per-task problem.

## 7. Key takeaways
- Long-context attention favors the start (primacy) and end (recency); the middle is "lost" — treat position as a first-class design variable.
- Mitigate structurally: front-load a key-findings summary and add explicit section headers so the model can navigate to middle content.
- Prefer restructuring over aggressive compression — discarding detail to shrink context can lose the exact findings you needed.
- Streaming and source-rotation don't guarantee critical information lands in a reliably attended position.

## 8. Official documentation
- [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Context windows](https://platform.claude.com/docs/en/build-with-claude/context-windows)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
