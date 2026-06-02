# Common Mistakes — a bank of tricky exam cases & the traps people fall for

A curated catalog of **43 high-value exam cases** for the Claude Certified Architect – Foundations exam, each reframed around **the mistake most people make**, not anyone's personal score. Every case is a tricky scenario where a plausible-but-wrong answer is genuinely tempting — exactly the shape the scenario exam uses to separate a 720 from a near-miss.

> **Why this folder exists.** Each note focuses on *the trap most people fall for*, so every case is a reusable lesson in distractor-spotting. What remains in each is the question, the correct answer, and a forensic breakdown of why each look-alike is wrong.

## How to read each note

All 43 notes share the same 8-section structure:

| § | Section | What it gives you |
|---|---------|-------------------|
| 1 | Topic — what this really tests | the underlying design principle |
| 2 | Question | the scenario stem + options (**answer this before scrolling**) |
| 3 | Answer options | options tagged `✅ Correct` and `⚠️ Most common wrong answer` |
| 4 | Correct answer | the key + why it's right |
| 5 | **Common mistake — the trap most people fall for** | the seductive wrong answer, *why* it tempts, and the **tell** that exposes it |
| 6 | Distractor analysis | every look-alike and why it fails |
| 7 | Key takeaways | the transferable rule |
| 8 | Official documentation | verified `code.claude.com` / `platform.claude.com` / engineering sources |

**Header legend.** Each note's header carries a **Domain** (+ task statement), a **Trap level**, a **Trap archetype**, and a neutral **Source** line.

- **Trap level** = how subtle the distractors are (not a personal result): 🔴 **High** · 🟡 **Medium** · 🟢 **Lower**.
- **Trap archetype** = the recurring distractor family (e.g. *symptom over root cause*, *fix the prompt vs. fix the contract*, *determinism vs. probabilistic prompting*).

**Retrieval-first:** read §2, commit to an answer, *then* read §4–§6. The value is in §5/§6 — that's where the exam's traps are dissected.

**Study order:** work the 🔴 High-trap cases first, then 🟡. Interleave domains rather than drilling one straight through.

**Counts:** 43 cases — **22 🔴 High-trap · 21 🟡 Medium**. By domain: D1 ×9 · D2 ×7 · D3 ×9 · D4 ×8 · D5 ×10.

---

## D1 — Agentic Architecture & Orchestration (27%)

| Trap | Topic | Trap archetype | File |
|------|-------|----------------|------|
| 🔴 | Coordinator (hub-and-spoke): centralized visibility & control | Centralized control vs. peer chatter | [`d1-coordinator-hub-and-spoke.md`](d1-coordinator-hub-and-spoke.md) |
| 🔴 | Subagents have isolated context — pass findings explicitly | Subagents don't inherit parent context | [`d1-subagent-context-passing.md`](d1-subagent-context-passing.md) |
| 🔴 | Hooks give deterministic guarantees a prompt can't | Deterministic hook vs. prompt instruction | [`d1-agent-sdk-hooks.md`](d1-agent-sdk-hooks.md) |
| 🟡 | Loop termination driven by `stop_reason`, not text/counts | Fragile proxy vs. authoritative signal | [`d1-agentic-loop-stop-reason.md`](d1-agentic-loop-stop-reason.md) |
| 🟡 | Task decomposition & parallel investigation | Right workload, wrong mechanism | [`d1-task-decomposition-parallel-investigation.md`](d1-task-decomposition-parallel-investigation.md) |
| 🟡 | Parallel tool calls — batch independent requests | Right workload, wrong mechanism | [`d1-parallel-tool-calls-round-trips.md`](d1-parallel-tool-calls-round-trips.md) |
| 🟡 | Decomposition coverage — span all relevant domains | Symptom over root cause | [`d1-decomposition-coverage-all-domains.md`](d1-decomposition-coverage-all-domains.md) |
| 🟡 | Deterministic tool ordering — prerequisites in code | Determinism vs. probabilistic prompting | [`d1-deterministic-tool-ordering.md`](d1-deterministic-tool-ordering.md) |
| 🟡 | Session state: `--resume`, `fork_session`, stale recovery | Resume vs. fork session state | [`d1-session-resume-fork.md`](d1-session-resume-fork.md) |

## D2 — Tool Design & MCP Integration (18%)

| Trap | Topic | Trap archetype | File |
|------|-------|----------------|------|
| 🔴 | Tool Distribution — constrain capability at the interface | Constrain at the interface vs. instruct in prompt | [`d2-tool-distribution-constrain-at-interface.md`](d2-tool-distribution-constrain-at-interface.md) |
| 🔴 | Tool Distribution — eliminate semantic name/description overlap | Symptom over root cause | [`d2-tool-distribution-eliminate-name-overlap.md`](d2-tool-distribution-eliminate-name-overlap.md) |
| 🔴 | Tool Distribution — scoped fast-path tool vs. blanket access | Least privilege violation | [`d2-tool-distribution-scoped-fast-path-tool.md`](d2-tool-distribution-scoped-fast-path-tool.md) |
| 🔴 | Tool Selection — system-prompt keyword steering vs. descriptions | Diagnose the right layer | [`d2-tool-selection-keyword-steering.md`](d2-tool-selection-keyword-steering.md) |
| 🔴 | MCP structured error metadata enables recovery | Structured error vs. opaque string | [`d2-mcp-structured-errors.md`](d2-mcp-structured-errors.md) |
| 🔴 | Project vs user MCP scope + secret-free credentials | Project scope vs. user scope | [`d2-mcp-server-config.md`](d2-mcp-server-config.md) |
| 🟡 | Choosing the right built-in tool; explore incrementally | Right built-in tool for the job | [`d2-builtin-tools.md`](d2-builtin-tools.md) |

## D3 — Claude Code Configuration & Workflows (20%)

| Trap | Topic | Trap archetype | File |
|------|-------|----------------|------|
| 🔴 | CLAUDE.md vs Skills — always-on standards vs. on-demand workflows | Always-on context vs. on-demand procedure | [`d3-claudemd-vs-skills.md`](d3-claudemd-vs-skills.md) |
| 🔴 | Path-specific rules vs. directory-bound CLAUDE.md | Path-scoped rules vs. global instructions | [`d3-path-specific-rules.md`](d3-path-specific-rules.md) |
| 🟡 | CLAUDE.md hierarchy & modularity (`@import`, `.claude/rules/`) | Symptom over root cause | [`d3-claudemd-hierarchy.md`](d3-claudemd-hierarchy.md) |
| 🟡 | Project-scoped slash commands live in repo `.claude/commands/` | Real location, wrong scope | [`d3-slash-command-scope.md`](d3-slash-command-scope.md) |
| 🟡 | Plan mode for large-scale, multi-file architectural work | Plan-then-confirm vs. direct execution | [`d3-plan-mode-vs-direct.md`](d3-plan-mode-vs-direct.md) |
| 🟡 | Headless CI with `-p` / `--print` | Headless mode vs. interactive (invented-feature look-alikes) | [`d3-headless-ci-print-flag.md`](d3-headless-ci-print-flag.md) |
| 🟡 | Stateful iterative review — feed prior findings into context | Right workload, wrong mechanism | [`d3-stateful-iterative-review.md`](d3-stateful-iterative-review.md) |
| 🟡 | Surface reasoning inline without filtering | Respect the stated constraint | [`d3-surface-reasoning-inline-no-filtering.md`](d3-surface-reasoning-inline-no-filtering.md) |
| 🟡 | Iterative refinement — demonstrate, don't describe | Specify intent vs. re-prompt blindly | [`d3-iterative-refinement.md`](d3-iterative-refinement.md) |

## D4 — Prompt Engineering & Structured Output (20%)

| Trap | Topic | Trap archetype | File |
|------|-------|----------------|------|
| 🔴 | Prompt specificity — define the criterion, don't just show examples | Define the criterion vs. show examples | [`d4-prompt-specificity-define-criterion.md`](d4-prompt-specificity-define-criterion.md) |
| 🔴 | Classification consistency — anchor severity with explicit criteria | Symptom over root cause | [`d4-classification-consistency-criteria.md`](d4-classification-consistency-criteria.md) |
| 🔴 | Batch processing — match async/poll workloads to Message Batches API | Match the workload to the API | [`d4-batch-processing-mode-selection.md`](d4-batch-processing-mode-selection.md) |
| 🔴 | Structured output via `tool_use` + JSON schema | Schema-enforced tool_use vs. prompt-and-parse | [`d4-structured-output-tooluse.md`](d4-structured-output-tooluse.md) |
| 🔴 | Retry with specific error feedback — and when retry can't help | Targeted-feedback retry vs. blind retry | [`d4-validation-retry-loops.md`](d4-validation-retry-loops.md) |
| 🔴 | Multi-pass review: per-file passes + cross-file integration pass | Per-file + integration pass vs. bigger context | [`d4-multipass-review.md`](d4-multipass-review.md) |
| 🟡 | Batch API vs. iterative tool loops — fire-and-forget constraint | Match the workload to the API | [`d4-batch-api-vs-iterative-loops.md`](d4-batch-api-vs-iterative-loops.md) |
| 🟡 | False-positive management — disable low-precision categories | Precision vs. recall trade-off | [`d4-false-positive-management.md`](d4-false-positive-management.md) |

## D5 — Context Management & Reliability (15%)

| Trap | Topic | Trap archetype | File |
|------|-------|----------------|------|
| 🔴 | Error propagation — handle at lowest level, escalate with context | Handle locally vs. escalate with context | [`d5-error-propagation-handle-low-escalate.md`](d5-error-propagation-handle-low-escalate.md) |
| 🔴 | Error propagation — access failure ≠ valid empty result | Preserve semantic distinctions | [`d5-error-propagation-access-fail-vs-empty.md`](d5-error-propagation-access-fail-vs-empty.md) |
| 🔴 | Error propagation — graceful degradation with coverage annotations | Transparent degradation vs. silent masking | [`d5-error-propagation-graceful-degradation.md`](d5-error-propagation-graceful-degradation.md) |
| 🔴 | Escalation — escalate policy ambiguity, not factual conflict | Escalate ambiguity, not facts | [`d5-escalation-policy-ambiguity.md`](d5-escalation-policy-ambiguity.md) |
| 🔴 | Long-context position bias — front-load summaries + headers | Position bias / lost-in-the-middle | [`d5-long-context-position-bias.md`](d5-long-context-position-bias.md) |
| 🟡 | Context — durable facts vs. lossy summarization | Tune-the-knob vs. change-the-design | [`d5-durable-facts-vs-summarization.md`](d5-durable-facts-vs-summarization.md) |
| 🟡 | Escalation calibration — decision boundaries in the system prompt | Explicit criteria vs. self-confidence/sentiment | [`d5-escalation-calibration-system-prompt.md`](d5-escalation-calibration-system-prompt.md) |
| 🟡 | Large-codebase context — scratchpads, delegation, `/compact` | Externalize state vs. cram the window | [`d5-large-codebase-context.md`](d5-large-codebase-context.md) |
| 🟡 | Human review & calibration — stratified sampling | Stratified sampling vs. blanket review | [`d5-human-review-calibration.md`](d5-human-review-calibration.md) |
| 🟡 | Provenance & uncertainty — annotate conflicts, don't pick one | Preserve provenance vs. flatten claims | [`d5-provenance-uncertainty.md`](d5-provenance-uncertainty.md) |

---

## Recurring trap families (master these and you spot most distractors)

- **Symptom over root cause** — fix where the state/contract lives, not the surface knob. (durable-facts, decomposition-coverage, classification, claudemd-hierarchy, eliminate-name-overlap)
- **Fix the prompt vs. fix the contract / interface** — change the tool definition or a code guard, not the instructions. (tool-distribution ×3, tool-selection, deterministic-ordering, agent-sdk-hooks)
- **Determinism vs. probabilistic prompting** — enforce safety-critical ordering/consistency in code/hooks, not few-shot. (deterministic-ordering, agent-sdk-hooks, prompt-specificity, classification)
- **Handle locally vs. escalate with context; failure ≠ empty** — preserve semantic distinctions and transparent degradation. (error-propagation ×3, mcp-structured-errors, provenance)
- **Right workload, wrong mechanism** — match batch/sync, parallel/sequential, plan/direct to the job. (batch ×2, parallel-tool-calls, task-decomposition, plan-mode, multipass-review)
- **Least privilege / scope follows audience** — scope each tool/command/config to exactly its owner. (scoped-fast-path-tool, constrain-at-interface, mcp-server-config, slash-command-scope, path-specific-rules)

See [`../00-EXAM-GUIDE.md`](../00-EXAM-GUIDE.md) for the authoritative domain/task outline and [`../exam-topics-index.md`](../exam-topics-index.md) for the scope navigator.
