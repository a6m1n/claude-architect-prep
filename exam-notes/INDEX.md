# Study Index — Claude Certified Architect (exam-notes)

The per-question study material lives in **[`common-mistakes/`](common-mistakes/)** — **43 tricky exam cases**,
each de-personalized into a *common-mistake* case study (focus on the trap most people fall for, not anyone's
personal score). Every note has the same 8-section structure (Topic → Question → Options → Correct answer →
**Common mistake** → Distractor analysis → Key takeaways → Official docs) and a header with **Domain · Trap level ·
Trap archetype · Source**. Browse them via **[`common-mistakes/README.md`](common-mistakes/README.md)**.

> **Read [`00-EXAM-GUIDE.md`](00-EXAM-GUIDE.md) first** — the authoritative reference distilled from the
> official exam guide: 5 domains + weightings, **6 scenarios** (the exam shows **4 of 6 at random**),
> the full task-statement outline, 12 official sample questions, and the coverage map.
> **[`exam-topics-index.md`](exam-topics-index.md)** is the scope navigator (what each task 1.1–5.6 tests).

> **External practice resources:** see [`useful-links.md`](useful-links.md) — the official Skilljar practice exam + vetted third-party question banks, mock exams and anti-pattern cheatsheets (deduped to one entry per domain, each flagged official 🟢 / third-party 🔵 with a "when useful" phase). Verify any unofficial claim against the official guide before trusting it.

**Domain weightings (official):** D1 Agentic Architecture & Orchestration **27%** · D2 Tool Design & MCP **18%** ·
D3 Claude Code Config & Workflows **20%** · D4 Prompt Engineering & Structured Output **20%** · D5 Context Mgmt & Reliability **15%**.

**Priority key — `Trap level` (intrinsic difficulty of the distractors, *not* a personal result):**
🔴 = **High-trap** (study first) · 🟡 = **Medium** · 🔵 = **gap-fill** topic from the guide.
*Personal correct/incorrect history is tracked separately in `progress.json` by [[progress-tracker]], not here.*
Counts: **43 notes** — **22 🔴 · 21 🟡** · spanning all 6 scenarios. By domain: D1 ×9 · D2 ×7 · D3 ×9 · D4 ×8 · D5 ×10.

---

## D1 — Agentic Architecture & Orchestration (27%)
| Trap | Topic | Scenario | Note (`common-mistakes/`) |
|----|-------|----------|------|
| 🔴 | Coordinator (hub-and-spoke): centralized visibility & control | Multi-Agent Research | `d1-coordinator-hub-and-spoke.md` |
| 🔴 | Subagents have isolated context — pass findings explicitly | Multi-Agent Research | `d1-subagent-context-passing.md` |
| 🔴 | Hooks give deterministic guarantees a prompt can't | Customer Support | `d1-agent-sdk-hooks.md` |
| 🟡 | Loop termination driven by `stop_reason`, not text/counts | Customer Support | `d1-agentic-loop-stop-reason.md` |
| 🟡 | Task decomposition & parallel investigation | Customer Support | `d1-task-decomposition-parallel-investigation.md` |
| 🟡 | Parallel tool calls — batch independent requests | Customer Support | `d1-parallel-tool-calls-round-trips.md` |
| 🟡 | Decomposition coverage — span all relevant domains | Multi-Agent Research | `d1-decomposition-coverage-all-domains.md` |
| 🟡 | Deterministic tool ordering — prerequisites in code | Customer Support | `d1-deterministic-tool-ordering.md` |
| 🟡 | Session state: `--resume`, `fork_session`, stale recovery | Developer Productivity | `d1-session-resume-fork.md` |

## D2 — Tool Design & MCP Integration (18%)
| Trap | Topic | Scenario | Note (`common-mistakes/`) |
|----|-------|----------|------|
| 🔴 | Tool Distribution — constrain capability at the interface | Multi-Agent Research | `d2-tool-distribution-constrain-at-interface.md` |
| 🔴 | Tool Distribution — eliminate semantic name/description overlap | Multi-Agent Research | `d2-tool-distribution-eliminate-name-overlap.md` |
| 🔴 | Tool Distribution — scoped fast-path tool vs. blanket access | Multi-Agent Research | `d2-tool-distribution-scoped-fast-path-tool.md` |
| 🔴 | Tool Selection — system-prompt keyword steering vs. descriptions | Customer Support | `d2-tool-selection-keyword-steering.md` |
| 🔴 | MCP structured error metadata enables recovery | Customer Support | `d2-mcp-structured-errors.md` |
| 🔴 | Project vs user MCP scope + secret-free credentials | Code Generation | `d2-mcp-server-config.md` |
| 🟡 | Choosing the right built-in tool; explore incrementally | Developer Productivity | `d2-builtin-tools.md` |

## D3 — Claude Code Configuration & Workflows (20%)
| Trap | Topic | Scenario | Note (`common-mistakes/`) |
|----|-------|----------|------|
| 🔴 | CLAUDE.md vs Skills — always-on vs. on-demand | Code Generation | `d3-claudemd-vs-skills.md` |
| 🔴 | Path-specific rules vs. directory-bound CLAUDE.md | Code Generation | `d3-path-specific-rules.md` |
| 🟡 | CLAUDE.md hierarchy & modularity (`@import`, `.claude/rules/`) | Code Generation | `d3-claudemd-hierarchy.md` |
| 🟡 | Project-scoped slash commands in repo `.claude/commands/` | Code Generation | `d3-slash-command-scope.md` |
| 🟡 | Plan mode for large-scale, multi-file work | Code Generation | `d3-plan-mode-vs-direct.md` |
| 🟡 | Headless CI with `-p` / `--print` | CI | `d3-headless-ci-print-flag.md` |
| 🟡 | Stateful iterative review — feed prior findings into context | CI | `d3-stateful-iterative-review.md` |
| 🟡 | Surface reasoning inline without filtering | CI | `d3-surface-reasoning-inline-no-filtering.md` |
| 🟡 | Iterative refinement — demonstrate, don't describe | Code Generation | `d3-iterative-refinement.md` |

## D4 — Prompt Engineering & Structured Output (20%)
| Trap | Topic | Scenario | Note (`common-mistakes/`) |
|----|-------|----------|------|
| 🔴 | Prompt specificity — define the criterion, not just examples | CI | `d4-prompt-specificity-define-criterion.md` |
| 🔴 | Classification consistency — anchor severity with criteria | CI | `d4-classification-consistency-criteria.md` |
| 🔴 | Batch processing — match async/poll to Message Batches API | CI | `d4-batch-processing-mode-selection.md` |
| 🔴 | Multi-pass review: per-file + cross-file integration pass | CI | `d4-multipass-review.md` |
| 🔴 | Structured output via `tool_use` + JSON schema | Structured Data Extraction | `d4-structured-output-tooluse.md` |
| 🔴 | Retry with specific error feedback — and when retry can't help | Structured Data Extraction | `d4-validation-retry-loops.md` |
| 🟡 | Batch API vs. iterative tool loops — fire-and-forget constraint | CI | `d4-batch-api-vs-iterative-loops.md` |
| 🟡 | False-positive management — disable low-precision categories | CI | `d4-false-positive-management.md` |

## D5 — Context Management & Reliability (15%)
| Trap | Topic | Scenario | Note (`common-mistakes/`) |
|----|-------|----------|------|
| 🔴 | Error propagation — handle at lowest level, escalate with context | Multi-Agent Research | `d5-error-propagation-handle-low-escalate.md` |
| 🔴 | Error propagation — access failure ≠ valid empty result | Multi-Agent Research | `d5-error-propagation-access-fail-vs-empty.md` |
| 🔴 | Error propagation — graceful degradation with coverage annotations | Multi-Agent Research | `d5-error-propagation-graceful-degradation.md` |
| 🔴 | Escalation — escalate policy ambiguity, not factual conflict | Customer Support | `d5-escalation-policy-ambiguity.md` |
| 🔴 | Long-context position bias — front-load summaries + headers | Multi-Agent Research | `d5-long-context-position-bias.md` |
| 🟡 | Context — durable facts vs. lossy summarization | Customer Support | `d5-durable-facts-vs-summarization.md` |
| 🟡 | Escalation calibration — decision boundaries in the system prompt | Customer Support | `d5-escalation-calibration-system-prompt.md` |
| 🟡 | Large-codebase context — scratchpads, delegation, `/compact` | Developer Productivity | `d5-large-codebase-context.md` |
| 🟡 | Human review & calibration — stratified sampling | Structured Data Extraction | `d5-human-review-calibration.md` |
| 🟡 | Provenance & uncertainty — annotate conflicts, don't pick one | Multi-Agent Research | `d5-provenance-uncertainty.md` |

---

## Cross-cutting themes to master (recurring on this exam)
- **Tool Distribution / least privilege** — scope each tool to the owning agent's job; fix the
  tool contract (rename/clarify/narrow), not the prompt. (constrain-at-interface, eliminate-name-overlap,
  scoped-fast-path-tool, tool-selection-keyword-steering, deterministic-tool-ordering)
- **Error propagation in multi-agent systems** — handle at the lowest capable level, escalate the rest
  *with context*; preserve semantic distinctions (failure ≠ empty result); prefer transparent graceful
  degradation over silent masking. (error-propagation ×3, mcp-structured-errors)
- **Determinism vs. probabilistic prompting** — for safety-critical ordering/consistency, enforce in
  code/hooks (programmatic prerequisites, explicit criteria), not via instructions/few-shot.
  (deterministic-tool-ordering, agent-sdk-hooks, classification-consistency, prompt-specificity)
- **Context engineering** — separate durable facts from lossy summaries; counter long-context position
  bias with front-loaded summaries + section headers. (durable-facts, long-context-position-bias, large-codebase-context)
- **Right tool for the workload** — batch (async/poll, latency-tolerant) vs synchronous iterative tool
  loops; parallel tool calls to cut round-trips; plan vs. direct. (batch ×2, parallel-tool-calls, plan-mode, multipass-review)
- **Root cause over symptom** — diagnose the correct layer (tool vs system prompt vs decomposition) and
  pick the most proportionate intervention. (tool-selection, decomposition-coverage, escalation-calibration)

## How to use these notes
1. Work the 🔴 High-trap notes first, then the 🟡 ones; **interleave domains** rather than drilling one straight through.
2. For each: read §2 (question), commit to an answer before §4, then study §5 (the trap most people fall for) and
   §6 (why every look-alike is wrong) — that's how the exam traps you.
3. Ask your tutor to quiz you on any topic; fresh scenario questions are generated with convincing distractors
   modeled on §5/§6, and your reasoning is checked against §4/§7. Personal mastery is tracked in `progress.json`.
