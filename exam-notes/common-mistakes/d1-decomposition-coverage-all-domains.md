# Task decomposition coverage — the coordinator must span all relevant domains

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.6 (overly narrow task decomposition → incomplete coverage)
> **Scenario:** Multi-Agent Research System · **Study area:** Multi-Agent Orchestration — task decomposition & domain coverage
> **Trap level:** 🟡 Medium — every distractor names a real, plausible-sounding component bug
> **Trap archetype:** Symptom over root cause (blame the worker, not the decomposition)
> **Source:** Claude Certified Architect practice exam, Q41 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
In an orchestrator–worker multi-agent system, the coordinator's first job is to map the full problem space and decompose it into subtasks that collectively cover every relevant domain. Coverage is determined at decomposition time, not execution time: any domain the coordinator never assigns simply has no agent responsible for it, so no downstream worker can recover it. This is why "every subagent succeeded but the output is incomplete" is a decomposition-quality symptom, not a worker-quality one. The transferable skill is reading the failure mode backward — when individual components are all correct yet the aggregate misses scope, the defect lives in how the problem was carved up, not in how each piece was solved.

## 2. Question
> After running the system on the topic 'Impact of AI on creative industries,' you observe that each subagent completes successfully: the web search agent finds relevant articles, the document analysis agent summarizes papers correctly, and the synthesis agent produces coherent output. However, the final reports cover only visual arts, completely missing music, writing, and film production. When you examine the coordinator's logs, you see it decomposed the topic into three subtasks: 'AI in digital art creation,' 'AI in graphic design,' and 'AI in photography.' What is the most likely root cause?

## 3. Answer options
- **A.** The web search agent's queries are not comprehensive enough and need to cover more creative industry sectors. — ⚠️ **Most common wrong answer**
- **B.** The document analysis agent is filtering out sources related to non-visual creative industries due to overly restrictive relevance criteria.
- **C.** The synthesis agent lacks instructions for identifying coverage gaps in the findings it receives from other agents.
- **D.** The coordinator agent's task decomposition was too narrow, resulting in subagent assignments that don't cover all relevant domains of the topic. — ✅ **Correct**

## 4. Correct answer — D
**The coordinator agent's task decomposition was too narrow, resulting in subagent assignments that don't cover all relevant domains of the topic.**

The coordinator's logs directly reveal it decomposed the broad topic into only three visual arts subtasks (digital art, graphic design, photography), completely omitting music, writing, and film. Since the subagents all executed their assigned tasks correctly, the narrow decomposition by the coordinator is clearly the root cause of the missing coverage. Generalizing: in orchestrator–worker designs, the orchestrator owns problem-space coverage, and a worker can only be as complete as the slice it was handed. When the assigned subtasks already exclude a domain, perfect retrieval, summarization, and synthesis cannot reintroduce it — the gap is structural and upstream.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **A — "the web search agent's queries aren't comprehensive enough."** It is seductive because the visible failure is missing search results, so the instinct is to blame the component that does the searching and make its queries broader. The tell that it's wrong: the search agent only ever queries within the subtasks it was assigned, and the logs show music, writing, and film were never delegated at all — broadening queries inside three visual-arts subtasks still cannot reach a domain that has no subtask. Anyone reasoning "the symptom is at search, so fix search" lands on A. The correct move is to trace the failure backward to the coordinator's decomposition, where the omission was structurally baked in before any worker ran.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because broader queries would surface more sectors — but the search agent only queries within the subtasks it was given; it was never assigned music, writing, or film, so the limit is the assignment, not the query breadth.
- **B.** Plausible as a relevance-filter bug, yet the logs show no non-visual sources were ever sought; the document agent can't filter out what was never collected under the missing subtasks.
- **C.** A real best practice (gap-checking at synthesis), but the synthesis agent produced coherent output from what it received and isn't the originating cause; the omission was already baked in before synthesis ran.
- **D.** Correct — the decomposition itself excluded entire domains, so the coordinator is the root cause.

## 7. Key takeaways
- The coordinator must map the full problem space up front; coverage gaps are decided at decomposition, not execution.
- "All subagents succeeded but coverage is incomplete" points to decomposition, not worker logic — read the failure backward to the upstream split.
- A worker can only be as complete as the slice it was assigned; flawless downstream execution cannot recover a domain that was never delegated.

## 8. Official documentation
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Agent SDK subagents](https://code.claude.com/docs/en/agent-sdk/subagents)
