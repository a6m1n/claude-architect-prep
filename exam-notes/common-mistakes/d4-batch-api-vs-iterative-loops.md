# Batch API vs. iterative tool loops — the async fire-and-forget constraint

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.5 (batch processing)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Batch API constraints — iterative (client-side) tool use
> **Trap level:** 🟡 Medium — "24h latency is too slow" sounds right but names the wrong limit
> **Trap archetype:** Match the workload to the API
> **Source:** Claude Certified Architect practice exam, Q17 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
Client-executed tool use is a **synchronous control-flow loop**: Claude emits a `tool_use`, your application pauses, runs the tool, and feeds a `tool_result` back so Claude can continue reasoning — often over several rounds within one logical interaction. The Message Batches API is a **fire-and-forget** processing model: you submit fully-formed requests and retrieve completed outputs asynchronously, with no channel to intercept a request mid-flight. The real test is recognizing that these two models are architecturally incompatible at the *control-flow* level, not at the level of latency, schema support, or output correlation. An architect must distinguish a fundamental capability mismatch from a tunable cost/performance tradeoff before reaching for batch to "reduce costs."

## 2. Question
> The code review component works iteratively: Claude analyzes a changed file, then may request related files (imports, base classes, tests) via tool calling to understand context before providing final feedback. Your application defines a tool that lets Claude request file contents; Claude invokes this tool, receives results, and continues its analysis. You're evaluating batch processing to reduce API costs. What is the primary technical constraint when considering batch processing for this workflow?

## 3. Answer options
- **A.** Batch processing latency of up to 24 hours is too slow for pull request feedback, though the workflow could otherwise function. — ⚠️ **Most common wrong answer**
- **B.** The asynchronous model prevents executing tools mid-request and returning results for Claude to continue analysis. — ✅ **Correct**
- **C.** The batch API doesn't support tool definitions in request parameters.
- **D.** Batch processing lacks request correlation identifiers for matching outputs to input requests.

## 4. Correct answer — B
**The asynchronous model prevents executing tools mid-request and returning results for Claude to continue analysis.**

The batch API's asynchronous fire-and-forget model means there is no mechanism to intercept a tool call mid-request, execute the tool, and return results for Claude to continue its analysis. This fundamentally breaks iterative tool-calling workflows that require multiple rounds of tool invocation and response within a single logical interaction. Generalized: whenever a tool is **executed by your client**, the workflow needs a live request → `tool_result` → continue loop, which is inherently synchronous. Batch is the right lever only for *independent, self-contained* prompts that need no mid-request interaction — not for agentic loops that must pause and resume.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **A — "24-hour batch latency is too slow for PR feedback."** It is seductive because the latency *is* real and obviously unfit for fast pull-request turnaround, so it reads as a correct objection. The tell that it's wrong is the qualifier "though the workflow could otherwise function" — it frames the problem as mere slowness, implying that with patience batch would still work, when in fact the iterative tool loop cannot run *at all* under a fire-and-forget model. Picking A means matching the workload to the wrong dimension of the API — treating a hard capability mismatch as a tunable cost/performance tradeoff. The correct move names the actual control-flow limitation: batch has no point to pause mid-request, execute a client tool, and resume.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because 24-hour latency *is* real and clearly unfit for PR feedback — but it frames the issue as mere slowness ("could otherwise function"), masking that the loop cannot run at all.
- **B.** Correct: names the actual control-flow limitation — batch cannot pause mid-request to run a client tool and resume.
- **C.** False: the batch API *does* accept the same `tools` definitions as standard Messages requests; the problem isn't declaring tools, it's executing them mid-request.
- **D.** False: batch supports per-request `custom_id` for correlating outputs to inputs; correlation is a solved problem and not the blocker here.

## 7. Key takeaways
- Client-side tool use requires a synchronous `tool_use` → execute → `tool_result` → continue loop; batch's fire-and-forget model has no mid-request intercept point.
- The constraint is **control flow**, not latency, schema support, or correlation IDs — distinguish a capability mismatch from a tunable tradeoff.
- Batch fits independent, self-contained prompts (no mid-request interaction); reach for it to cut cost only when the workload doesn't need an agentic loop.
- Batch *does* support tool definitions and `custom_id` correlation — don't pick a distractor that denies those.

## 8. Official documentation
- [Batch processing (Message Batches API)](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [How tool use works](https://platform.claude.com/docs/en/agents-and-tools/tool-use/how-tool-use-works)
- [Tool use overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
