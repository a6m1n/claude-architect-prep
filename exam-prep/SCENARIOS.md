# 🎬 Exam scenarios

The exam is **scenario-based**: each scenario sets a realistic production context in which the questions are asked. There are **6** scenarios in total, and the real exam shows **4 of 6 at random**. Know all six.

> Source: exam guide → *Exam Scenarios* section. One scenario pulls in several domains — study the topics, not the scenario.

---

## 1 · Customer Support Resolution Agent
**Context:** an agent on the Claude Agent SDK handles returns, billing, and account problems. It accesses the backend through the MCP tools `get_customer`, `lookup_order`, `process_refund`, `escalate_to_human`. Goal: **80%+ first-contact resolution** plus knowing when to escalate.
**Domains:** D1, D2, D5.
**Key topics:** [1.4 enforcement/prerequisites](domain-1-agentic-architecture/1.4-workflow-enforcement-handoff.md) · [1.5 hooks](domain-1-agentic-architecture/1.5-agent-sdk-hooks.md) · [2.1 descriptions](domain-2-tool-design-mcp/2.1-tool-interfaces.md) · [2.2 errors](domain-2-tool-design-mcp/2.2-mcp-structured-errors.md) · [5.1 context](domain-5-context-reliability/5.1-conversation-context.md) · [5.2 escalation](domain-5-context-reliability/5.2-escalation-ambiguity.md).
**Guide sample questions:** Q1 (prerequisite gate), Q2 (expand the description), Q3 (explicit escalation criteria).

## 2 · Code Generation with Claude Code
**Context:** Claude Code for generation/refactoring/debugging/documentation. Custom slash commands, CLAUDE.md, choosing plan vs direct.
**Domains:** D3, D5.
**Key topics:** [3.1 hierarchy](domain-3-claude-code-config/3.1-claudemd-hierarchy.md) · [3.2 commands/skills](domain-3-claude-code-config/3.2-slash-commands-skills.md) · [3.3 rules](domain-3-claude-code-config/3.3-path-specific-rules.md) · [3.4 plan vs direct](domain-3-claude-code-config/3.4-plan-mode-vs-direct.md) · [3.5 refinement](domain-3-claude-code-config/3.5-iterative-refinement.md).
**Guide sample questions:** Q4 (`.claude/commands/`), Q5 (plan mode), Q6 (`.claude/rules` globs).

## 3 · Multi-Agent Research System
**Context:** a coordinator delegates to subagents: web-search, doc-analysis, synthesis, report. It produces citable reports.
**Domains:** D1, D2, D5.
**Key topics:** [1.2 coordinator](domain-1-agentic-architecture/1.2-coordinator-subagent.md) · [1.3 spawning/context](domain-1-agentic-architecture/1.3-subagent-invocation-context.md) · [2.3 tool distribution](domain-2-tool-design-mcp/2.3-tool-distribution-tool-choice.md) · [5.3 error propagation](domain-5-context-reliability/5.3-error-propagation.md) · [5.6 provenance](domain-5-context-reliability/5.6-provenance-uncertainty.md).
**Guide sample questions:** Q7 (narrow coordinator decomposition), Q8 (structural error-context), Q9 (scoped `verify_fact`).

## 4 · Developer Productivity with Claude ⚠️ *(less commonly emphasized — study it thoroughly here)*
**Context:** productivity tools on the Agent SDK: exploring unfamiliar codebases, legacy code, generating boilerplate, automation. Built-in tools (Read/Write/Bash/Grep/Glob) + MCP.
**Domains:** D2, D3, D1.
**Key topics:** [2.5 built-in tools](domain-2-tool-design-mcp/2.5-builtin-tools.md) · [2.4 MCP servers](domain-2-tool-design-mcp/2.4-mcp-server-integration.md) · [1.7 session resume/fork](domain-1-agentic-architecture/1.7-session-state-resume-fork.md) · [5.4 large-codebase context](domain-5-context-reliability/5.4-large-codebase-context.md) · [3.5 refinement](domain-3-claude-code-config/3.5-iterative-refinement.md).

## 5 · Claude Code for Continuous Integration
**Context:** Claude Code in CI/CD — automatic review, test generation, PR feedback. You need: actionable feedback + minimal false positives.
**Domains:** D3, D4.
**Key topics:** [3.6 CI/CD](domain-3-claude-code-config/3.6-ci-cd-integration.md) · [4.1 explicit criteria](domain-4-prompt-engineering/4.1-explicit-criteria-false-positives.md) · [4.6 multi-pass review](domain-4-prompt-engineering/4.6-multipass-review.md) · [4.5 batch](domain-4-prompt-engineering/4.5-batch-processing.md).
**Guide sample questions:** Q10 (`-p`/`--print`), Q11 (batch only overnight), Q12 (per-file + integration pass).

## 6 · Structured Data Extraction ⚠️ *(less commonly emphasized — study it thoroughly here)*
**Context:** extracting data from unstructured documents, validating against JSON schemas, high accuracy, graceful edge cases, integration with downstream.
**Domains:** D4, D5.
**Key topics:** [4.3 tool_use+schema](domain-4-prompt-engineering/4.3-structured-output-tooluse.md) · [4.4 validation/retry](domain-4-prompt-engineering/4.4-validation-retry-loops.md) · [4.2 few-shot](domain-4-prompt-engineering/4.2-few-shot-prompting.md) · [5.5 human review/calibration](domain-5-context-reliability/5.5-human-review-calibration.md) · [5.1 context](domain-5-context-reliability/5.1-conversation-context.md).

---

## 🧭 The "scenario × domain" matrix

| Scenario | D1 | D2 | D3 | D4 | D5 |
|---|:--:|:--:|:--:|:--:|:--:|
| 1 Customer Support | ● | ● | | | ● |
| 2 Code Generation | | | ● | | ● |
| 3 Multi-Agent Research | ● | ● | | | ● |
| 4 Developer Productivity | ● | ● | ● | | ● |
| 5 CI/CD | | | ● | ● | |
| 6 Structured Extraction | | | | ● | ● |

> ⚠️ Scenarios **4** and **6** have fewer worked practice references in this kit — work through them using this kit and Anthropic's official exam guide.
