# Tool Distribution — eliminating semantic overlap in tool names & descriptions

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.1 (tool interfaces & descriptions)
> **Scenario:** Multi-Agent Research System · **Study area:** Tool Distribution
> **Trap level:** 🔴 High — every distractor sounds like a reasonable routing fix
> **Trap archetype:** Symptom over root cause
> **Source:** Claude Certified Architect practice exam, Q24 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
In a multi-agent system, the coordinator decides which subagent handles a request almost entirely from the tool names and descriptions it can see — that text is the routing interface contract. When two tools describe near-identical capabilities (`analyze_content` "analyzes content and extracts key information" vs. `analyze_document` "analyzes documents and extracts key information"), the model has no reliable signal to disambiguate them, so routing degrades to guesswork. The fix is to make each tool's purpose semantically distinct at the definition level, not to add steering logic downstream. This question tests whether you treat tool definitions as a first-class design surface rather than an afterthought patched over by prompting.

## 2. Question
> Production logs reveal a consistent pattern: requests to "analyze the quarterly report I uploaded" are routed to the web search agent instead of the document analysis agent 45% of the time. Examining the tool definitions, you find the web search agent has an `analyze_content` tool described as "analyzes content and extracts key information" while the document analysis agent has an `analyze_document` tool described as "analyzes documents and extracts key information." How should you address this misrouting?

## 3. Answer options
- **A.** Add a pre-routing classifier that determines whether the user is referencing uploaded files or web content before the coordinator makes delegation decisions.
- **B.** Rename the web search tool to `extract_web_results` and update its description to "processes and returns information retrieved from web searches and URLs." — ✅ **Correct**
- **C.** Expand the document analysis tool's description to include example use cases like "Use for uploaded PDFs, Word documents, and spreadsheets" while leaving the web search tool unchanged.
- **D.** Add few-shot examples to the coordinator's prompt showing correct routing: "User uploads quarterly report → document analysis agent" and "User asks about a webpage → web search agent." — ⚠️ **Most common wrong answer**

## 4. Correct answer — B
**Rename the web search tool to `extract_web_results` and update its description to "processes and returns information retrieved from web searches and URLs."**

Renaming the web search tool to `extract_web_results` and updating its description to clearly reference web searches and URLs directly addresses the root cause by eliminating the semantic overlap between the two tools' names and descriptions. This makes each tool's purpose unambiguous, allowing the coordinator to distinguish between document analysis and web search tasks. The transferable principle: when an agent routes incorrectly, first audit the interface it routes from — distinct, non-overlapping tool names and descriptions are the cheapest and most durable fix, because they remove the ambiguity rather than compensating for it.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — "add few-shot routing examples to the coordinator's prompt."** It is seductive because adding examples feels like a fast, low-risk prompt tweak that directly demonstrates the desired routing behavior. The tell that it's wrong: the examples sit *downstream* of two tool definitions that still collide, so they only paper over the ambiguity for the exact phrasings shown and stay fragile against novel wordings. Anyone reasoning "just show the model what good routing looks like" instead of "remove the overlapping signal it routes from" lands on D. The correct move is structural — rename and redescribe the colliding tool so each purpose is self-evident — fixing the root cause rather than patching the symptom.

## 6. Distractor analysis — look-alikes to watch for
- **A.** A pre-routing classifier adds a whole new component and latency to compensate for ambiguous definitions — it patches over the root cause instead of removing it.
- **B.** Correct — it removes the naming/description overlap so each tool's purpose is self-evident to the coordinator.
- **C.** Clarifying only the document tool while leaving the web tool's overlapping name/description intact leaves the collision half-resolved, so misrouting can persist.
- **D.** Few-shot routing examples are tempting because they feel like a quick prompt fix, but they treat the symptom, are fragile, and fail to generalize to novel phrasings.

## 7. Key takeaways
- In multi-agent routing, tool names and descriptions ARE the routing signal — fix the interface contract before reaching for orchestration logic.
- Eliminate semantic overlap: each tool should have a distinct, unambiguous name and description that no sibling tool could plausibly match.
- Prefer fixing root causes (definitions) over symptom patches (few-shot examples, extra classifiers) that add fragility, latency, and components without removing the ambiguity.

## 8. Official documentation
- [Writing effective tools for agents](https://www.anthropic.com/engineering/writing-effective-tools-for-agents)
- [Define tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
