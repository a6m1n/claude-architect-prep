# Context management — separate durable facts from lossy summarization

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.1 (durable facts outside summarized history)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Context management / progressive summarization (fact retention)
> **Trap level:** 🟡 Medium — "just make the summarizer keep the numbers" is a very natural-sounding fix
> **Trap archetype:** Tune-the-knob vs. change-the-design (symptom over root cause)
> **Source:** Claude Certified Architect practice exam, Q56 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question tests whether you understand that not all context is equal, and that summarization is a *lossy* compression strategy. Progressive summarization is great for preserving the narrative flow of a long conversation, but it inevitably blurs precise, high-stakes details — amounts, dates, order numbers — into vague prose. The architectural insight is to split state into two layers: a *durable, structured facts layer* that is always carried verbatim into the prompt, and a *lossy narrative layer* that can be compressed freely. Tuning the summarizer (better prompts, higher thresholds) only delays the loss; it does not change the fundamental property that summarization discards detail.

## 2. Question
> Your support agent uses progressive summarization—when context reaches 70% capacity, older turns are summarized while recent ones remain verbatim. Production logs reveal a pattern: customers reference specific amounts ("the 15% discount I mentioned"), but the agent responds with incorrect values. Investigation shows these details were stated 20+ turns ago and got condensed into vague summaries like "discussed promotional pricing." What's the most effective fix?

## 3. Answer options
- **A.** Revise the summarization prompt to explicitly preserve all numerical values, dates, and customer-stated expectations verbatim. — ⚠️ **Most common wrong answer**
- **B.** Store full conversation history externally and implement retrieval to search it when the agent detects reference phrases like "as I mentioned."
- **C.** Increase the summarization threshold from 70% to 85% capacity so conversations have more room before summarization triggers.
- **D.** Extract transactional facts (amounts, dates, order numbers) into a persistent "case facts" block included in each prompt, outside the summarized history. — ✅ **Correct**

## 4. Correct answer — D
**Extract transactional facts (amounts, dates, order numbers) into a persistent "case facts" block included in each prompt, outside the summarized history.**

Extracting transactional facts (amounts, dates, order numbers) into a persistent "case facts" block addresses the root cause: summarization is inherently lossy for precise details. By preserving critical information in a structured block outside the summarized history, these facts remain reliably available in every prompt regardless of how many turns are summarized. The transferable principle is to model agent state as distinct layers — a durable structured store for facts that must survive intact, and a compressible narrative for the conversational thread. Decide *what* must never degrade, then keep it outside the path of any lossy operation.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **A — "make the summarizer preserve every value verbatim."** It is seductive because the failure happens *during summarization*, so the instinct is to fix the instruction that's doing the losing: just tell the summarizer not to drop numbers. The tell that it's wrong: a summarization prompt is *best-effort compression* — as turns keep accumulating it must still shed detail to fit, so the same incorrect-value bug resurfaces a few turns later. Anyone reasoning "tighten the instruction that's losing data" instead of "move the data out of the lossy path entirely" lands on A. The correct move is structural — a durable facts block outside summarization — not a better-worded summarizer.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because "preserve verbatim" sounds like it fixes loss, but a summarization prompt is best-effort and still compresses; as turns accumulate even a careful summarizer must shed detail, so the failure recurs.
- **B.** Plausible but fragile and costly: it depends on the agent detecting reference phrases, adds retrieval latency/failure modes, and misses facts the customer never re-references explicitly.
- **C.** A pure delay tactic — raising the threshold to 85% only postpones the same lossy summarization; in a 20+ turn conversation the details are still eventually condensed and lost.
- **D.** Correct — durable facts are stored in a structured block outside the summarized history, so they survive any amount of summarization.

## 7. Key takeaways
- Not all context is equal: precise transactional facts deserve a durable, structured state layer, separate from a lossy narrative summary.
- Summarization is inherently lossy — tuning the summarizer prompt or raising the trigger threshold only defers loss, it never eliminates it.
- Design agent memory as layers: keep "must-not-degrade" data verbatim in every prompt; let everything else compress.
- Fix the root cause (where critical state lives), not the symptom (how aggressively you summarize).

## 8. Official documentation
- [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Context windows](https://platform.claude.com/docs/en/build-with-claude/context-windows)
