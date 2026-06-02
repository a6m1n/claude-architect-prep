# Tool Distribution — constraining capability at the interface level

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.3 (distribute tools / configure tool choice)
> **Scenario:** Multi-Agent Research System · **Study area:** Tool Distribution
> **Trap level:** 🔴 High — every distractor sounds like a reasonable fix for the observed misuse
> **Trap archetype:** Constrain at the interface vs. instruct in the prompt
> **Source:** Claude Certified Architect practice exam, Q22 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
In a multi-agent system, each agent's behavior is bounded first by the *tools it can call*, not by the instructions it is given. When you hand an agent a general-purpose tool, you implicitly grant it every capability that tool affords — including uses you never intended. This question tests whether you fix unwanted behavior by reshaping the tool surface (capability) or by layering softer controls (prompts, filters, routing) on top of an over-broad tool. The durable principle is least privilege: design each tool so the affordance matches exactly the job the agent owns, making out-of-scope actions impossible by construction rather than merely discouraged.

## 2. Question
> When designing the system, you gave the document analysis agent access to a general-purpose `fetch_url` tool so it could load documents from URLs. Production logs reveal this agent now frequently fetches search engine result pages to conduct ad-hoc web searches—behavior that should route through the web search agent. This causes inconsistent search results. What's the most effective fix?

## 3. Answer options
- **A.** Replace `fetch_url` with a `load_document` tool that validates URLs point to document formats. — ✅ **Correct**
- **B.** Implement filtering that blocks `fetch_url` calls to known search engine domains while allowing other URLs.
- **C.** Add instructions to the document analysis agent's prompt clarifying it should only use `fetch_url` for loading document URLs, not searching.
- **D.** Remove `fetch_url` from the document analysis agent and route all URL loading through the coordinator to the web search agent. — ⚠️ **Most common wrong answer**

## 4. Correct answer — A
**Replace `fetch_url` with a `load_document` tool that validates URLs point to document formats.**

Per the official explanation: "Replacing the general-purpose tool with a document-specific tool that validates URLs point to document formats addresses the root cause by constraining capability at the interface level. This follows the principle of least privilege, making the undesired search behavior impossible rather than merely discouraged." The root cause is an over-broad affordance: `fetch_url` can reach any URL, so search behavior is reachable by design. Narrowing the tool to `load_document` with format validation removes the capability to fetch search result pages while preserving the legitimate document-loading job. Generalize this: scope each tool to the precise task its owner agent is responsible for, and enforce intent in the tool's contract — not in hope that the model behaves.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — remove `fetch_url` entirely and route all URL loading through the coordinator to the web search agent.** It is seductive because it reads as a clean separation of concerns: the document agent was doing something that belongs to the web search agent, so the instinct is to take the capability away and centralize routing. The tell that it's wrong: the document agent *legitimately* needs to load documents from URLs, so stripping `fetch_url` "eliminates useful capability and adds unnecessary latency for legitimate document loading" — an over-correction that throws away a needed job and inserts an extra hop. The correct move is to reshape the affordance, not remove it: swap the general `fetch_url` for a `load_document` tool whose contract validates document formats, constraining the capability at the interface so out-of-scope fetches become impossible while the legitimate job survives. Generalize this to the trap archetype: fix unwanted behavior by narrowing the tool's interface, not by deleting the capability or instructing around it in the prompt.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — re-scopes the tool itself so out-of-scope fetches become impossible (least privilege at the interface).
- **B.** Tempting because it stops the observed bad URLs, but domain blocklists are brittle, must be maintained, and miss new/unknown search domains — it treats symptoms, not the over-broad capability.
- **C.** Tempting because prompt guidance is cheap, but instructions only *discourage* misuse; the capability remains and the model can still drift back to it.
- **D.** Tempting as a clean separation of concerns, but it removes a legitimately needed capability and adds coordinator-routing latency — an over-correction.

## 7. Key takeaways
- Apply least privilege to tools: an agent's capabilities are defined by the tools it can call, so scope each tool to exactly the task its owner agent should perform.
- Fix unwanted behavior at the tool-definition layer (make it impossible) rather than via prompt nudges or network filters (which merely discourage and decay over time).
- Validation and narrow affordances belong in the tool contract — a `load_document` that checks for document formats beats a general `fetch_url` plus a list of "don'ts".
- Avoid over-correcting: don't strip a capability the agent legitimately needs or add routing hops that introduce latency — reshape the tool, don't remove the job.

## 8. Official documentation
- [Writing effective tools for agents](https://www.anthropic.com/engineering/writing-effective-tools-for-agents)
- [Define tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
