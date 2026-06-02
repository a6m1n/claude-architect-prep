# Task decomposition & parallel investigation for complex multi-concern requests

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.4 (multi-step workflows)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Complex request handling / parallel investigation
> **Trap level:** 🟡 Medium — "add checkpoints between steps" sounds like rigor but enforces the wrong flow
> **Trap archetype:** Right workload, wrong mechanism (sequential gating vs. parallel decomposition)
> **Source:** Claude Certified Architect practice exam, Q57 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question tests how to scale an agent from single-concern tasks to compound, multi-concern requests without an explosion in tool calls. The key insight is recognizing that a complex request is often a bundle of *independent* sub-problems that share a common context (here, the same customer). The architectural move is to decompose first, then exploit the independence by investigating concerns in parallel over that shared context, and only synthesize at the end. Sequential, concern-by-concern loops fail because they re-derive the same context for every concern, inflating tool calls and degrading reliability. The transferable principle: match the agent's control flow to the dependency structure of the work — parallelize what is independent, share what is common.

## 2. Question
> Production logs show that for simple requests like 'refund order #1234', your agent succeeds in 3-4 tool calls with 91% resolution rate. However, for complex requests like 'I've been charged twice, my discount didn't apply, and I want to cancel', the agent averages 12+ tool calls with only 54% resolution—often investigating concerns sequentially and gathering redundant customer data for each one. What's the most effective change to improve complex request handling?

## 3. Answer options
- **A.** Decompose the request into distinct concerns, then investigate each in parallel using shared customer context before synthesizing a resolution. — ✅ **Correct**
- **B.** Add few-shot examples demonstrating ideal tool call sequences for various multi-part billing scenarios to your system prompt.
- **C.** Add explicit verification gates between steps requiring the agent to checkpoint after resolving each concern before moving to the next. — ⚠️ **Most common wrong answer**
- **D.** Reduce the number of available tools by consolidating `get_customer`, `lookup_order`, and billing-related lookups into a single `investigate_issue` tool.

## 4. Correct answer — A
**Decompose the request into distinct concerns, then investigate each in parallel using shared customer context before synthesizing a resolution.**

Per the official explanation: "Decomposing the request into distinct concerns and investigating them in parallel with shared customer context directly addresses both core issues: it eliminates redundant data fetching by reusing shared context across concerns and reduces total tool calls by parallelizing investigations before synthesizing a unified resolution." This works because the two failure modes named in the logs — sequential investigation and redundant per-concern data gathering — are both symptoms of treating one compound request as a serial chain. Decomposition exposes the independent sub-concerns; a single shared context fetch removes the duplication; parallel investigation collapses the latency and call count; final synthesis reconciles the results into one coherent resolution. Generalized: structure the work to mirror the problem's dependency graph — fetch shared context once, fan out across independent units, then fan in.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **C — "add verification gates/checkpoints between steps."** It is seductive because the agent is visibly failing on complex requests, so the instinct is to impose more control and discipline — checkpoint after each concern before moving on — which *sounds* like the responsible, reliability-first move. The tell that it's wrong: checkpoints between steps explicitly enforce a *sequential* flow, which is precisely the behavior the logs blame for the 12+ tool calls and redundant data fetching; adding gates makes the serial chain longer, not shorter. Anyone reasoning "the agent is unreliable, so add checkpoints" applies the right instinct (more structure) through the wrong mechanism (serial gating). The correct move is to match control flow to the work's dependency structure — decompose, fan out across independent concerns over shared context, then synthesize — which removes the sequential bottleneck instead of reinforcing it.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — decomposition + shared context + parallel investigation + synthesis attacks both named failure modes (sequential work and redundant data fetching) at their root.
- **B.** Few-shot exemplars may nudge tool-call style, but they teach better *sequences*, not a better *structure*; they leave the agent investigating serially and re-fetching context, so the redundancy and call-count problems persist.
- **C.** Verification gates / checkpoints between steps explicitly enforce a *sequential* flow — the opposite of what the data shows is needed — adding more steps and overhead rather than parallelizing independent concerns.
- **D.** Merging `get_customer`, `lookup_order`, and billing lookups into one `investigate_issue` tool hides the redundancy behind a coarse tool but does not eliminate it; it reduces tool *granularity* and observability without enabling parallelism or shared-context reuse.

## 7. Key takeaways
- Decompose compound requests into distinct concerns before acting; the dependency structure of the work should drive the agent's control flow.
- Fetch shared context once and reuse it across concerns — redundant per-concern data gathering is a primary driver of tool-call bloat and lower resolution.
- Parallelize independent sub-investigations, then synthesize a unified resolution; reserve sequential gating only for genuinely dependent steps.
- More examples or coarser tools treat symptoms; the structural fix (decompose → fan out → synthesize) addresses the root cause.

## 8. Official documentation
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Parallel tool use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/parallel-tool-use)
