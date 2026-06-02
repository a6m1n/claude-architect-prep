# Error Propagation — handle errors at the lowest capable level, escalate with context

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.3 (subagents recover locally, escalate only what they can't resolve, with context)
> **Scenario:** Multi-Agent Research System · **Study area:** Error Propagation
> **Trap level:** 🔴 High — "always return success with errors in metadata" mimics resilient design
> **Trap archetype:** Handle locally vs. escalate with context
> **Source:** Claude Certified Architect practice exam, Q18 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question is about where error handling belongs in a multi-agent system. The durable principle is to resolve faults at the lowest level that is capable of resolving them: a subagent owning a task should absorb its own transient, routine failures rather than escalating every exception to its coordinator. Escalation is reserved for errors the subagent genuinely cannot resolve, and it must carry context — what was attempted and any partial results — so the coordinator can make an informed decision. The wrong instinct is to either centralize all error logic in the coordinator (or a separate error agent), or to hide failures behind a uniform "success" response. Good error propagation balances autonomy with observability.

## 2. Question
> The document analysis subagent frequently encounters failures when processing PDF files—some have corrupted sections causing parsing exceptions, others are password-protected, and occasionally the parsing library times out on large files. Currently, any exception immediately terminates the subagent and returns an error to the coordinator, which must decide whether to retry, skip the document, or fail the entire research task. This is causing excessive coordinator involvement in routine error handling. What's the most effective architectural improvement?

## 3. Answer options
- **A.** Have the coordinator validate all documents before dispatching to the subagent, rejecting documents likely to cause failures to ensure the subagent only receives processable files.
- **B.** Configure the subagent to always return partial results with success status, embedding error details in metadata. The coordinator treats all responses as successful and filters problematic items during synthesis. — ⚠️ **Most common wrong answer**
- **C.** Have the subagent implement local recovery for transient failures and only propagate errors it cannot resolve to the coordinator, including what was attempted and any partial results obtained. — ✅ **Correct**
- **D.** Create a dedicated error-handling agent that monitors all subagent failures via a shared queue and makes recovery decisions independently, dispatching retry commands directly to subagents.

## 4. Correct answer — C
**Have the subagent implement local recovery for transient failures and only propagate errors it cannot resolve to the coordinator, including what was attempted and any partial results obtained.**

Implementing local recovery for transient failures within the subagent follows the principle of handling errors at the lowest level capable of resolving them. This reduces excessive coordinator involvement while still escalating truly unresolvable issues with full context, including what recovery was attempted and any partial results obtained. Generalized: give each agent ownership of the faults it can fix (retry with backoff on timeouts, skip a corrupted or password-protected file), and propagate upward only the residual, unresolvable cases — annotated with enough context that the layer above can act intelligently rather than re-investigate.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "always return a success status with error details buried in metadata."** It is seductive because uniform "success" responses look like graceful resilience and simplify the coordinator's branching: nothing crashes, every call comes back clean, and problematic items are quietly filtered out during synthesis. The tell that it's wrong: masking errors as success destroys observability — the coordinator can no longer distinguish a genuinely unresolvable failure from a healthy result, so silent data-quality problems flow straight into synthesis unchallenged. That is the opposite of error propagation; it hides faults instead of resolving them at the right level. The correct move is to recover transient faults locally in the subagent and escalate only the unresolvable ones with full context, preserving the coordinator's ability to make informed decisions.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because pre-validation sounds like prevention, but it pushes failure handling up to the coordinator and duplicates parsing logic; many failures (timeouts, hidden corruption) can't be predicted without actually processing the file.
- **B.** Tempting because uniform "success" responses simplify the coordinator's branching, but it destroys observability and lets silent data-quality problems flow into synthesis unchallenged.
- **C.** Correct — local recovery for transient faults, escalating only unresolvable errors with full context.
- **D.** Tempting because a dedicated error agent looks like clean separation of concerns, but it adds coupling and a shared-queue bottleneck, and centralizes decisions an owning subagent could resolve locally.

## 7. Key takeaways
- Handle errors at the lowest level capable of resolving them; subagents should absorb routine, transient faults (retry/backoff, skip) instead of escalating every exception.
- Escalate only unresolvable errors, and always include context — what was attempted plus any partial results — so the coordinator can decide without re-investigating.
- Never mask failures as success: doing so trades observability for convenience and lets silent data-quality issues corrupt downstream synthesis.
- Centralizing all error logic (coordinator pre-validation or a separate error agent) adds coupling and complexity without the locality that makes recovery cheap.

## 8. Official documentation
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Agent SDK subagents](https://code.claude.com/docs/en/agent-sdk/subagents)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
