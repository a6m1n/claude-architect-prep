# Tool Distribution — scoped fast-path tool vs. blanket tool access

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.3 (scoped cross-role tools for high-frequency needs)
> **Scenario:** Multi-Agent Research System · **Study area:** Tool Distribution
> **Trap level:** 🔴 High — "just give it all the tools" cleanly removes the round-trips, hiding the least-privilege cost
> **Trap archetype:** Least privilege violation
> **Source:** Claude Certified Architect practice exam, Q25 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question is about how to distribute tools across agents in a multi-agent system when a recurring sub-task creates expensive orchestration overhead. The architectural lever is *scoping*: give an agent a narrow, purpose-built tool for the high-frequency common case, while keeping the heavier capability behind delegation for the rare hard case. The goal is to optimize the dominant path (here, 85% simple fact-checks) without dissolving role boundaries or over-provisioning the agent. This is a direct application of the principle of least privilege to agent tooling — the surface area an agent can touch should match what its role actually requires. Getting this right reduces latency while preserving the separation of concerns that keeps each agent reliable at its primary job.

## 2. Question
> During testing, you observe that the synthesis agent frequently needs to verify specific claims while combining findings. Currently, when verification is needed, the synthesis agent returns control to the coordinator, which invokes the web search agent, then re-invokes synthesis with results. This adds 2-3 round-trips per task and increases latency by 40%. Your evaluation shows that 85% of these verifications are simple fact-checks (dates, names, statistics) while 15% require deeper investigation. What's the most effective approach to reduce overhead while maintaining synthesis reliability?

## 3. Answer options
- **A.** Have the web search agent proactively cache extra context around each source during initial research, anticipating what the synthesis agent might need to verify.
- **B.** Have the synthesis agent accumulate all verification needs and return them as a batch to the web search agent at the end of its pass, which then sends them all to the web search agent at once.
- **C.** Give the synthesis agent access to all web search tools so it can handle any verification need directly without round-trips through the coordinator. — ⚠️ **Most common wrong answer**
- **D.** Give the synthesis agent a scoped `verify_fact` tool for simple lookups, while complex verifications continue delegating to the web search agent through the coordinator. — ✅ **Correct**

## 4. Correct answer — D
**Give the synthesis agent a scoped `verify_fact` tool for simple lookups, while complex verifications continue delegating to the web search agent through the coordinator.**

Providing a scoped fact-verification tool handles the 85% of simple lookups directly, eliminating most round-trips while preserving the coordinator-based delegation path for the 15% of complex verifications. This applies the principle of least privilege: the verification path stays narrow while latency still drops significantly. The transferable principle is to optimize the *common case* with a minimal, single-purpose tool and *escalate* the rare hard case through the existing delegation channel — you get the latency win without expanding the agent's capability surface beyond what its role needs.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **C — "give the synthesis agent access to all web search tools so it can handle any verification directly."** It is seductive because it cleanly eliminates every round-trip in one move: if the agent owns all the tools, it never has to hand control back to the coordinator at all. The tell that it's wrong: it grants a blanket capability to solve a problem that only the 85% common case requires, over-provisioning the agent far beyond its role and collapsing the separation of concerns that keeps each agent reliable at its primary job. The correct move is to scope the grant — a narrow `verify_fact` tool for the dominant path, with the rare hard case still escalating through delegation. Anyone reasoning "remove the round-trip" instead of "match the tool surface to the role" lands on C, which trades least privilege for latency.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because pre-caching sounds proactive, but speculative caching can't anticipate which dynamic claims synthesis will need, wasting work and context while still missing verifications.
- **B.** Tempting because batching reduces call count, but verification is needed *during* synthesis to proceed; deferring all checks to the end breaks the dynamic flow and still routes through the same heavy path.
- **C.** Tempting because it does eliminate round-trips, but blanket access over-provisions the agent, collapses role separation, and risks misuse — it solves latency by discarding least privilege.
- **D.** Correct — a scoped `verify_fact` tool fixes the 85% common case directly while keeping complex verifications on the coordinator delegation path.

## 7. Key takeaways
- Optimize the dominant path with a narrow, single-purpose tool; keep an escalation path for the rare, hard case rather than widening access for everyone.
- Apply least privilege to tool distribution: an agent's tool surface should match its role, not the union of every capability it might occasionally touch.
- Blanket tool grants buy latency at the cost of separation of concerns, added complexity, and degraded performance on the agent's primary task.
- Speculative caching and end-of-pass batching don't fit verification needs that are dynamic and required mid-synthesis.

## 8. Official documentation
- [Writing effective tools for agents](https://www.anthropic.com/engineering/writing-effective-tools-for-agents)
- [Define tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
