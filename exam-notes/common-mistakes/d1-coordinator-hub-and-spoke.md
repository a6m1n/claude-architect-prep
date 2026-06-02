# Coordinator (hub-and-spoke) pattern — centralized visibility & control

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.2 (coordinator-subagent patterns)
> **Scenario:** Multi-Agent Research System · **Study area:** Multi-Agent Orchestration
> **Trap level:** 🔴 High — every distractor names a real coordinator perk, just not a structural one
> **Trap archetype:** Centralized control vs. peer chatter (false dichotomy)
> **Source:** Claude Certified Architect practice exam, Q16 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question probes *why* the orchestrator-workers (hub-and-spoke) topology exists: a central coordinator that mediates every subagent interaction. The architectural payoff is not a single feature but a class of capabilities — observability into all message flows, one consistent place to handle errors, and the ability to gate what each subagent sees. Direct agent-to-agent edges optimize a local hop but dissolve the single point of control, scattering error handling and context decisions across the mesh. The exam wants you to distinguish *structural* advantages of centralization from *operational* perks (retries, batching) that could be implemented at any layer regardless of topology.

## 2. Question
> A colleague suggests having the document analysis agent send its output directly to the synthesis agent instead of routing through the coordinator. What is the main advantage of keeping the coordinator as the central hub for all subagent communication?

## 3. Answer options
- **A.** Subagents operate with isolated memory, and direct communication would require complex serialization that only the coordinator can perform.
- **B.** The coordinator can observe all interactions, handle errors consistently, and decide what information each subagent should receive. — ✅ **Correct**
- **C.** The coordinator batches multiple subagent requests together, reducing the total number of API calls and overall latency.
- **D.** Routing through the coordinator enables automatic retry logic that direct agent-to-agent calls cannot support. — ⚠️ **Most common wrong answer**

## 4. Correct answer — B
**The coordinator can observe all interactions, handle errors consistently, and decide what information each subagent should receive.**

Per the official explanation: "The coordinator pattern provides centralized visibility into all interactions, consistent error handling across the system, and fine-grained control over what information each subagent receives, which are the primary advantages of hub-and-spoke communication." These three properties — visibility, consistent error handling, and information gating — are emergent from the *topology* itself: routing everything through one node is what makes them possible. Generalizing, an orchestrator becomes the system's control plane: it owns the shared context, decides which slice each worker receives (context isolation), and is the natural place to detect, log, and recover from failures. Choose centralization when you need a single source of truth and uniform policy; trade it away only when raw point-to-point latency dominates and you can give up that control.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — "routing through the coordinator enables automatic retry logic that direct agent-to-agent calls cannot support."** It is seductive because the coordinator genuinely *is* a good place to centralize retries, so the option reads like a real benefit of the hub. The tell that it's wrong: it sets up a false dichotomy — retries are an operational concern that *any* caller, including a worker making a direct call, can wrap around a request, so they are not unique to the topology. "Good place for" is not "only possible with." The correct move is to name the *structural* advantages that flow from routing all traffic through one node — visibility, consistent error handling, and information gating — rather than an operational feature that could live at any layer.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Sounds plausible because subagents do have isolated context, but it invents a false constraint: nothing about isolated memory makes serialization a coordinator-only capability — agents can exchange serialized payloads directly.
- **B.** Correct — names the genuine topological advantages: visibility, consistent error handling, and information gating.
- **C.** Describes batching as a latency win, but batching is an orthogonal optimization that can live at any layer and is not the *defining* benefit of hub-and-spoke; it also conflates fewer calls with the question's control concern.
- **D.** Most-picked wrong answer — a false dichotomy: implies direct calls "cannot" support retries, yet retry logic can be added at any level, so it is not unique to the coordinator.

## 7. Key takeaways
- The hub-and-spoke / orchestrator-workers advantage is *structural*: centralized visibility, consistent error handling, and per-subagent information gating — properties that come from routing all traffic through one node.
- Treat the coordinator as the control plane that owns shared context and decides what each worker sees; this is the core of context isolation in multi-agent systems.
- Beware "false dichotomy" distractors: operational features like retries and batching can be implemented at any layer, so "X can only happen via the coordinator" is usually wrong.
- Pick centralization when you need a single source of truth and uniform policy; consider direct edges only when point-to-point latency clearly outweighs the loss of central control.

## 8. Official documentation
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Agent SDK subagents](https://code.claude.com/docs/en/agent-sdk/subagents)
