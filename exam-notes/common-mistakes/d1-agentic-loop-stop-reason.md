# Loop termination must be driven by `stop_reason`, not by text or iteration counts

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.1 (agentic loops; `stop_reason` `tool_use`/`end_turn`)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Agentic loop control flow (`stop_reason`)
> **Trap level:** 🟡 Medium — three plausible "when to stop the loop" heuristics, but only one is contractual
> **Trap archetype:** Fragile proxy vs. authoritative signal
> **Source:** Concept note grounded in the official exam guide, Task 1.1.

## 1. Topic — what this really tests

The agentic loop is a structured contract, not a guess. Each iteration: send the request, inspect `stop_reason`, and branch on it. While `stop_reason` is `"tool_use"`, execute the requested tools, append their results to the conversation history, and send the next request; when `stop_reason` is `"end_turn"`, the model has produced its final answer and the loop terminates. This is **model-driven** control — Claude reasons from the accumulated context about which tool to call next — as opposed to a pre-configured decision tree or fixed tool sequence. The trap is substituting fragile proxies (parsing the model's prose, capping iterations, or watching for assistant text) for the one authoritative signal the API already gives you.

## 2. Question

> You are building a Customer Support Resolution Agent on the Claude Agent SDK with custom MCP tools (`get_customer`, `lookup_order`, `process_refund`). A refund case may need one tool call or several, and you cannot predict how many in advance. How should the agent's loop decide whether to call another tool or stop and reply to the customer?
>
> - **A.** Continue the loop while `stop_reason` is `"tool_use"` — execute the requested tools and append their `tool_result`s to the conversation before the next request — and terminate when `stop_reason` is `"end_turn"`.
> - **B.** Scan the assistant's natural-language output for phrases like "I've resolved this" or "let me check that" and stop the loop when a resolution phrase appears.
> - **C.** Run the loop for a fixed cap of 5 iterations, then stop and return whatever the model last produced.
> - **D.** Stop as soon as the response contains any assistant text block, on the assumption that text means the answer is ready.

## 3. Answer options

- **A.** Drive the loop off `stop_reason`; append tool results; terminate on `"end_turn"`. — ✅ **Correct**
- **B.** Parse natural-language signals to decide when to stop.
- **C.** Use an arbitrary iteration cap as the primary stopping mechanism. — ⚠️ **Most common wrong answer**
- **D.** Treat presence of assistant text as the completion indicator.

## 4. Correct answer — A

`stop_reason` is the contractual signal the API emits for exactly this purpose. `"tool_use"` means Claude is requesting tools; you run them, append each `tool_result` so the model can reason over the outcome, and iterate. `"end_turn"` means Claude is finished. Because the loop keys on this field rather than a predicted step count, it naturally handles the open-ended, high-ambiguity support cases where the number of steps cannot be hardcoded — the model decides the next action from context each turn.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **C — "cap the loop at 5 iterations and return whatever's last."** It is seductive because a hard cap feels like prudent safety engineering: it guarantees the loop can't run forever. The tell that it's wrong: a fixed count is blind to the actual work — it truncates legitimate multi-step refunds that need six calls and wastes turns on simple ones, because the count has no relationship to whether Claude is actually done. A cap is at best a backstop *alongside* the real signal, never the primary stop. Anyone who reaches for "limit the iterations" instead of "read the field the API emits for exactly this" lands on C. The same reflex picks B (parse the prose) or D (text means done) — all three replace the authoritative `stop_reason` with a fragile proxy.

## 6. Distractor analysis — look-alikes to watch for

- **B — parsing NL to stop.** Free-form text is unreliable: the model can emit "let me check" mid-resolution or narrate alongside a real `tool_use`. If you are writing a regex to extract a decision from model output, that decision should have been read from `stop_reason`. Anti-pattern.
- **C — arbitrary iteration cap as primary stop.** A fixed count truncates legitimate multi-step refunds and wastes calls on simple ones. A cap is at best a safety backstop, never the primary termination signal. Anti-pattern.
- **D — assistant text as completion.** Claude commonly emits explanatory text *in the same turn* as a `tool_use` block, so text presence does not mean the turn is done. Only `stop_reason == "end_turn"` does. Anti-pattern.

## 7. Key takeaways

- Loop control is a `while stop_reason == "tool_use"` over the API field — never over prose, counts, or text presence.
- Append every `tool_result` to conversation history between iterations so the model reasons about the next action.
- `"end_turn"` is the authoritative completion signal; handle other reasons (`"max_tokens"`, `"stop_sequence"`, `"refusal"`) explicitly too.
- Model-driven > fixed sequence when step count is unpredictable, which is exactly the high-ambiguity support case.

## 8. Official documentation

- How tool use works (the `stop_reason`-keyed agentic loop): <https://platform.claude.com/docs/en/agents-and-tools/tool-use/how-tool-use-works>
- Building effective agents (model-driven agents vs. fixed workflows): <https://www.anthropic.com/engineering/building-effective-agents>
- Claude Agent SDK overview (the tool loop keyed on `stop_reason == "tool_use"`): <https://code.claude.com/docs/en/agent-sdk/overview>
