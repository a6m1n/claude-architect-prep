# 🎓 Exam Prep — Claude Certified Architect · Foundations

A ready-to-use study kit for the **Claude Certified Architect – Foundations** certification, built **from Anthropic's official exam guide**: domains, task statements, sample questions.

**Organizing principle:** 1 task statement from the official blueprint = 1 topic = 1 file. Each file = theory → traps/distractors → facts to remember → practice (3–4 MCQs of increasing difficulty + 1 **tricky question `**`**) → verified links to official documentation.

> 📌 **Source of truth** — Anthropic's official exam guide, distilled in `../exam-notes/00-EXAM-GUIDE.md`. All documentation links verified via WebFetch.

---

## 📊 The exam in numbers

| Parameter | Value |
|---|---|
| Format | Multiple choice, 1 correct + 3 distractors, **60 questions** |
| Scoring | Scale **100–1000**, passing score **720** |
| Guessing penalty | None; **unanswered = wrong** (answer everything) |
| Style | Scenario-based: judgment about architecture/configuration/tradeoffs, not rote memorization |
| Candidate | Solution architect, ~6+ months with the Agent SDK / Claude Code / Claude API / MCP |

### Domains and weights (these drive prep priority)

| Domain | Weight | Folder |
|---|---|---|
| **D1 — Agentic Architecture & Orchestration** | **27%** 🔝 | [`domain-1-agentic-architecture/`](domain-1-agentic-architecture/README.md) |
| **D3 — Claude Code Configuration & Workflows** | **20%** | [`domain-3-claude-code-config/`](domain-3-claude-code-config/README.md) |
| **D4 — Prompt Engineering & Structured Output** | **20%** | [`domain-4-prompt-engineering/`](domain-4-prompt-engineering/README.md) |
| **D2 — Tool Design & MCP Integration** | **18%** | [`domain-2-tool-design-mcp/`](domain-2-tool-design-mcp/README.md) |
| **D5 — Context Management & Reliability** | **15%** | [`domain-5-context-reliability/`](domain-5-context-reliability/README.md) |

Together **D1+D3+D4 = 67%** of the content — that is the main focus.

---

## 🗂 Full topic index (30 task statements)

### D1 · Agentic Architecture & Orchestration — 27%
| # | Topic | File |
|---|---|---|
| 1.1 | Agentic loops — control flow by `stop_reason` | [1.1-agentic-loops](domain-1-agentic-architecture/1.1-agentic-loops.md) |
| 1.2 | Coordinator–subagent (hub-and-spoke) | [1.2-coordinator-subagent](domain-1-agentic-architecture/1.2-coordinator-subagent.md) |
| 1.3 | Spawning subagents · `Task` · explicit context handoff | [1.3-subagent-invocation-context](domain-1-agentic-architecture/1.3-subagent-invocation-context.md) |
| 1.4 | Multi-step workflows · programmatic enforcement · handoff | [1.4-workflow-enforcement-handoff](domain-1-agentic-architecture/1.4-workflow-enforcement-handoff.md) |
| 1.5 | Agent SDK hooks (`PostToolUse`, interception) | [1.5-agent-sdk-hooks](domain-1-agentic-architecture/1.5-agent-sdk-hooks.md) |
| 1.6 | Task decomposition (chaining vs adaptive) | [1.6-task-decomposition](domain-1-agentic-architecture/1.6-task-decomposition.md) |
| 1.7 | Session state · `--resume` · `fork_session` | [1.7-session-state-resume-fork](domain-1-agentic-architecture/1.7-session-state-resume-fork.md) |

### D2 · Tool Design & MCP Integration — 18%
| # | Topic | File |
|---|---|---|
| 2.1 | Tool interfaces — descriptions as a selection signal | [2.1-tool-interfaces](domain-2-tool-design-mcp/2.1-tool-interfaces.md) |
| 2.2 | MCP structured errors (`isError`/`errorCategory`/`isRetryable`) | [2.2-mcp-structured-errors](domain-2-tool-design-mcp/2.2-mcp-structured-errors.md) |
| 2.3 | Tool distribution · `tool_choice` (least privilege) | [2.3-tool-distribution-tool-choice](domain-2-tool-design-mcp/2.3-tool-distribution-tool-choice.md) |
| 2.4 | MCP server integration (`.mcp.json` vs `~/.claude.json`) | [2.4-mcp-server-integration](domain-2-tool-design-mcp/2.4-mcp-server-integration.md) |
| 2.5 | Built-in tools (Grep/Glob/Read/Write/Edit/Bash) | [2.5-builtin-tools](domain-2-tool-design-mcp/2.5-builtin-tools.md) |

### D3 · Claude Code Configuration & Workflows — 20%
| # | Topic | File |
|---|---|---|
| 3.1 | CLAUDE.md hierarchy · `@import` · `/memory` | [3.1-claudemd-hierarchy](domain-3-claude-code-config/3.1-claudemd-hierarchy.md) |
| 3.2 | Slash commands & skills (`context: fork`, `allowed-tools`) | [3.2-slash-commands-skills](domain-3-claude-code-config/3.2-slash-commands-skills.md) |
| 3.3 | Path-specific rules (`.claude/rules` globs) | [3.3-path-specific-rules](domain-3-claude-code-config/3.3-path-specific-rules.md) |
| 3.4 | Plan mode vs direct execution | [3.4-plan-mode-vs-direct](domain-3-claude-code-config/3.4-plan-mode-vs-direct.md) |
| 3.5 | Iterative refinement (I/O examples, interview pattern) | [3.5-iterative-refinement](domain-3-claude-code-config/3.5-iterative-refinement.md) |
| 3.6 | CI/CD integration (`-p`, `--output-format json`) | [3.6-ci-cd-integration](domain-3-claude-code-config/3.6-ci-cd-integration.md) |

### D4 · Prompt Engineering & Structured Output — 20%
| # | Topic | File |
|---|---|---|
| 4.1 | Explicit criteria · reducing false positives | [4.1-explicit-criteria-false-positives](domain-4-prompt-engineering/4.1-explicit-criteria-false-positives.md) |
| 4.2 | Few-shot prompting | [4.2-few-shot-prompting](domain-4-prompt-engineering/4.2-few-shot-prompting.md) |
| 4.3 | Structured output via `tool_use` + JSON schema | [4.3-structured-output-tooluse](domain-4-prompt-engineering/4.3-structured-output-tooluse.md) |
| 4.4 | Validation / retry / feedback loops | [4.4-validation-retry-loops](domain-4-prompt-engineering/4.4-validation-retry-loops.md) |
| 4.5 | Batch processing (Message Batches API) | [4.5-batch-processing](domain-4-prompt-engineering/4.5-batch-processing.md) |
| 4.6 | Multi-instance / multi-pass review | [4.6-multipass-review](domain-4-prompt-engineering/4.6-multipass-review.md) |

### D5 · Context Management & Reliability — 15%
| # | Topic | File |
|---|---|---|
| 5.1 | Conversation context (durable facts, lost-in-the-middle) | [5.1-conversation-context](domain-5-context-reliability/5.1-conversation-context.md) |
| 5.2 | Escalation & ambiguity resolution | [5.2-escalation-ambiguity](domain-5-context-reliability/5.2-escalation-ambiguity.md) |
| 5.3 | Error propagation (multi-agent) | [5.3-error-propagation](domain-5-context-reliability/5.3-error-propagation.md) |
| 5.4 | Large-codebase context (scratchpads, `/compact`) | [5.4-large-codebase-context](domain-5-context-reliability/5.4-large-codebase-context.md) |
| 5.5 | Human review & confidence calibration | [5.5-human-review-calibration](domain-5-context-reliability/5.5-human-review-calibration.md) |
| 5.6 | Provenance & uncertainty in synthesis | [5.6-provenance-uncertainty](domain-5-context-reliability/5.6-provenance-uncertainty.md) |

---

## 🧭 Navigating the kit

- 🗺️ **[ROADMAP.md](ROADMAP.md)** — **start here:** a simple path from easy to hard topics (the ladder of leverage · 5 nodes with analogies · 🚩 detectors · a spacing calendar). It continues your system from `../exam-notes/learned-rules.md`.
- 📅 **[STUDY-PLAN.md](STUDY-PLAN.md)** — a phased prep plan (what to learn and in what order, a schedule, readiness checkpoints).
- 🎬 **[SCENARIOS.md](SCENARIOS.md)** — the 6 exam scenarios (the exam shows 4 of 6) and which domains/topics they test.
- 📖 **[GLOSSARY.md](GLOSSARY.md)** — an exam-day cheat sheet: every flag, file, and term in one line.
- ✅ **[AUDIT.md](AUDIT.md)** — the review report: correctness, completeness, plain language + what was fixed.
- 5 domain folders — each has its own `README.md` with an overview and a topic list.

## ✅ How to use it (a method, not cramming)

1. **Retrieve before reveal.** In each file, first answer the MCQ yourself, and only then expand the "Show answer" block. Not knowing = a wrong answer (just like on the exam).
2. **Learn the principle, not the question.** Generalize each topic to its design rule (least privilege · determinism vs probabilistic · error propagation · context engineering · root-cause over symptom).
3. **Interleave + space.** Don't cram one domain in a row; alternate and return to weak topics more often. See [STUDY-PLAN.md](STUDY-PLAN.md).
4. **Self-explanation.** After answering, say out loud "why it's right and why the others are traps." The distractors here are modeled on the real exam ones.
5. **The tricky question `**`** at the end of each file is the most deceptive; take it last, "cold."

## 🔁 Interactive practice (this workspace's skills)

- `"test me on D4"` / `quiz me` → **quiz-me** (one fresh MCQ + breakdown).
- `"study with me"` / `tutor me` → **exam-tutor** (an adaptive teach→quiz→feedback session).
- `"mock exam"` / `"am I ready?"` → **mock-exam** (a full 60-question simulation + a score on the 100–1000 scale).
- `"what to learn next"` → **progress-tracker** (a review schedule + readiness).

---
*Generated from the official exam materials. All weight ratings and task statements come from exam guide v0.1 (Feb 10 2025).*
