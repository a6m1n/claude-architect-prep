# Subagents have isolated context — pass prior findings explicitly in the `Task` prompt

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.3 (subagent invocation, context passing, spawning)
> **Scenario:** Multi-Agent Research System · **Study area:** Subagent spawning & explicit context passing (`Task`, `allowedTools`)
> **Trap level:** 🔴 High — every distractor names a real mechanism, but only one fixes the missing-input gap
> **Trap archetype:** Subagents don't inherit parent context
> **Source:** Concept note grounded in the official exam guide, Task 1.3.

## 1. Topic — what this really tests
Each subagent runs in a **fresh, isolated context**: it does NOT inherit the coordinator's conversation history, tool results, or memory between invocations. The only parent→child channel is the `Task` tool's prompt string, so the coordinator must **explicitly include the complete findings** of prior agents in the subagent's prompt. Use **structured formats** that separate content from metadata (source URLs, document names, page numbers) so attribution survives the hop. Parallel subagents are spawned by emitting **multiple `Task` calls in a single coordinator response**, and the coordinator must have `"Task"` in its `allowedTools`.

## 2. Question
> In a Multi-Agent Research System, a coordinator runs a web-search subagent and a document-analysis subagent, then spawns a **synthesis** subagent to write the report. The synthesis subagent produces a generic, near-empty report that ignores everything the first two agents found. The coordinator's prompt to the synthesis subagent only says "Write the final research report." What is the correct fix?
>
> **A.** Add a shared memory store so every subagent automatically reads the others' outputs.
> **B.** Explicitly include the prior agents' complete findings in the synthesis subagent's prompt, formatted as structured data that keeps source metadata (URLs, document names, page numbers) attached to each finding.
> **C.** Increase the synthesis subagent's `max_tokens` so it has room to recall the earlier results.
> **D.** Rely on the synthesis subagent inheriting the coordinator's conversation history, and just re-run it.

## 3. Answer options
- **A.** Shared memory store for automatic cross-agent reads
- **B.** Pass complete prior findings in the prompt, structured with source metadata — ✅ **Correct**
- **C.** Raise `max_tokens`
- **D.** Rely on inheriting the coordinator's history — ⚠️ **Most common wrong answer**

## 4. Correct answer — B
Subagent context is **not inherited** and is **not shared across invocations** — it must be supplied explicitly. The synthesis agent only knows what its `Task` prompt contains, so the coordinator must embed the web-search and document-analysis outputs directly in that prompt. Using a **structured format** that separates content from metadata preserves attribution (which source backs which claim), which is exactly what a synthesis/report step needs. Generalize: explicit context passing + content/metadata separation is the architecture-level pattern for chaining subagents.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — "rely on the synthesis subagent inheriting the coordinator's conversation history, and just re-run it."** It is seductive because subagents feel like they live inside one shared session, so it seems natural that a child would automatically see what the parent and its siblings already discovered. The tell that it's wrong: a subagent starts with a **fresh, isolated context** — it receives only its system prompt plus the `Task` prompt, never the parent's history or prior tool results — so re-running changes nothing when the findings were never passed in. The correct move is to make the parent→child channel explicit: embed the complete prior findings directly in the `Task` prompt, structured so source metadata stays attached. Generalize the archetype: subagents don't inherit parent context, so any "it'll just pick it up" answer is the trap.

## 6. Distractor analysis — look-alikes to watch for
- **A — "shared memory store":** Tempting because real systems have memory, but subagents do **not** share memory between invocations; the documented channel is the prompt. Adds infrastructure instead of fixing the actual gap.
- **C — "increase `max_tokens`":** Confuses output-length budget with missing input. The findings were never in context, so no token budget recovers them.
- **D — "inherits coordinator history":** The core misconception this task targets — subagents start with a fresh context and receive only their system prompt plus the `Task` prompt, never the parent's history or tool results.

## 7. Key takeaways
- A coordinator's `allowedTools` must include `"Task"` to invoke (auto-approve) subagents.
- Subagents are **context-isolated**: no auto-inherited parent history, no memory shared across invocations.
- The `Task` prompt string is the **only** parent→child context channel — pass complete prior findings inline.
- Use **structured data** to keep content separate from source metadata (URLs, doc names, page numbers) so attribution is preserved.
- Spawn subagents **in parallel** by emitting multiple `Task` calls in one coordinator response; configure each via its `AgentDefinition` (description, system prompt, tool restrictions).

## 8. Official documentation
- Subagents in the SDK (context isolation, `AgentDefinition`, parallel spawning, what subagents inherit): https://code.claude.com/docs/en/agent-sdk/subagents
- How we built our multi-agent research system (coordinator spawns subagents, returns findings to the lead for synthesis): https://www.anthropic.com/engineering/multi-agent-research-system
