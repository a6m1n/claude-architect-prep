# Parallel tool calls — batching independent tool requests to cut round-trips

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.4 (multi-step workflows)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Parallel tool use / reducing round-trips
> **Trap level:** 🟡 Medium — "give Claude more room to plan" sounds plausible but targets the wrong bottleneck
> **Trap archetype:** Right workload, wrong mechanism
> **Source:** Claude Certified Architect practice exam, Q50 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
Each API round-trip in an agent loop is a full request/response cycle: latency, tokens, and cost all scale with the number of turns. When two lookups (`get_customer`, `lookup_order`) are both needed upfront and independent, issuing them in separate sequential turns doubles the trips for no benefit. Claude 4 supports *native parallel tool use* — it can emit multiple `tool_use` blocks in a single assistant turn — so the architectural goal is to let it surface all independent calls at once and to hand back every result together. The transferable principle: reduce round-trips by maximizing the work done per turn, not by tweaking unrelated knobs or adding rigid infrastructure.

## 2. Question
> Production metrics show your agent averages 4+ API round-trips per resolution. Analysis reveals Claude frequently requests `get_customer` and `lookup_order` in separate sequential turns even when both are needed upfront. What's the most effective way to reduce round-trips?

## 3. Answer options
- **A.** Prompt Claude to batch tool requests per turn, and return all tool results together before the next API call. — ✅ **Correct**
- **B.** Increase `max_tokens` to give Claude more space to plan ahead and naturally batch its tool requests. — ⚠️ **Most common wrong answer**
- **C.** Implement speculative execution that automatically calls likely-needed tools alongside any requested tool, returning all results regardless of what was requested.
- **D.** Create composite tools like `get_customer_with_orders` that bundle common lookup combinations into single calls.

## 4. Correct answer — A
**Prompt Claude to batch tool requests per turn, and return all tool results together before the next API call.**

Prompting Claude to batch related tool requests in a single turn, and returning all results together before the next API call, leverages Claude's native ability to request multiple tools simultaneously. This is the most effective approach because it directly addresses the sequential calling pattern with minimal architectural changes. Generalized: when independent tool calls are needed, the lever is behavioral (prompt for parallelism) plus protocol-correct (return all `tool_result` blocks in one user message) — both halves matter, since batched requests still serialize if you reply to them one at a time.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "increase `max_tokens` so Claude has room to plan ahead and batch its requests."** It is seductive because batching feels like a planning behavior, so the instinct is that giving the model more output space will let it think further and naturally group its calls. The tell that it's wrong: output length was never the constraint — `max_tokens` caps how much Claude can *write* in a turn, not whether it *chooses* to emit two `tool_use` blocks at once, so raising it changes nothing about the serial pattern. Anyone reasoning "the model needs more room to plan" turns a knob that has no bearing on the actual bottleneck. The correct move targets the real cause: prompt for parallel tool use and return all results together — the right mechanism for the round-trip workload, not an unrelated capacity setting.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — targets the actual cause (sequential calling) using the model's built-in parallel tool use, with no new infrastructure.
- **B.** Tempting because more planning space sounds helpful, but `max_tokens` is the wrong bottleneck — output length never forced the serial pattern, so raising it changes nothing about round-trips.
- **C.** Speculative execution can cut trips but is wasteful: it fires tools that may not be needed, burning latency, cost, and side effects regardless of what Claude actually asked for.
- **D.** Composite tools work but are rigid and supplementary — each bundle is a hand-built combination that doesn't generalize to new pairings; parallel tool use scales to any set of independent calls without new endpoints.

## 7. Key takeaways
- Claude 4 supports native parallel tool use — it can emit multiple `tool_use` blocks in one turn when prompted to do so.
- Round-trips drop only when you *both* prompt for batched requests *and* return all `tool_result` blocks in a single user message; replying one result at a time re-serializes the loop.
- `max_tokens` is unrelated to round-trip count — diagnose the real bottleneck before turning knobs.
- Composite/bundled tools and speculative execution are supplementary, not the primary lever: one is rigid, the other wasteful.

## 8. Official documentation
- [Parallel tool use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/parallel-tool-use)
- [Tool use overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
