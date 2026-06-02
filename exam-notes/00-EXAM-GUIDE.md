# 00 — Official Exam Guide (authoritative reference)

Distilled from Anthropic's official Claude Certified Architect – Foundations exam guide (Anthropic,
v0.1, Feb 10 2025) and the **Anthropic Academy Course Catalog**. This is the ground-truth map for the
43 de-personalized case notes in [`common-mistakes/`](common-mistakes/) (the *common-mistakes* bank). Every note carries a
**`Domain:`** line tying it to a Domain + Task Statement below; this file is the index those lines point into.

> Reviewed against every case note: the guide **confirms every correct answer** in the set (it also resolves the
> one case whose original UI label was ambiguous — Multi-Agent scoped `verify_fact` — via official Sample Question 9).

---

## Exam logistics
- **Format:** multiple choice, 1 correct + 3 distractors each; pick the single best answer. 60 questions.
- **Scoring:** scaled 100–1,000; **pass = 720**. Unanswered = incorrect; **no penalty for guessing**.
- **Target candidate:** a solution architect with ~6+ months building on Claude (Agent SDK, Claude Code, Claude API, MCP).
- **Style:** scenario-based — judgment about architecture, configuration, and production tradeoffs, not recall.

## Scored domains & weightings
| # | Domain | Weight |
|---|--------|--------|
| 1 | **Agentic Architecture & Orchestration** | **27%** |
| 2 | **Tool Design & MCP Integration** | **18%** |
| 3 | **Claude Code Configuration & Workflows** | **20%** |
| 4 | **Prompt Engineering & Structured Output** | **20%** |
| 5 | **Context Management & Reliability** | **15%** |

## The six scenarios (the exam shows **4 of 6 at random**)
| # | Scenario | Primary domains | Covered by our notes? |
|---|----------|-----------------|------------------------|
| 1 | **Customer Support Resolution Agent** (Agent SDK; MCP tools `get_customer`/`lookup_order`/`process_refund`/`escalate_to_human`; 80%+ first-contact resolution) | 1, 2, 5 | ✅ 7 notes |
| 2 | **Code Generation with Claude Code** (slash commands, CLAUDE.md, plan vs direct) | 3, 5 | ✅ 1 note |
| 3 | **Multi-Agent Research System** (coordinator → web-search / doc-analysis / synthesis / report subagents) | 1, 2, 5 | ✅ 9 notes |
| 4 | **Developer Productivity with Claude** (explore codebases, legacy systems, boilerplate; built-in tools + MCP) | 2, 3, 1 | ❌ **gap** |
| 5 | **Claude Code for Continuous Integration** (automated review, test gen, PR feedback; minimize false positives) | 3, 4 | ✅ 7 notes |
| 6 | **Structured Data Extraction** (extract from unstructured docs; validate against JSON schemas; high accuracy) | 4, 5 | ❌ **gap** |

> An early read suggested **four** scenarios. The official guide confirms there are **six**; the 24 sampled practice questions happen to
> sample only scenarios 1, 2, 3, 5. Scenarios 4 and 6 — and their domains (structured output, validation/retry,
> built-in tools, MCP server config) — are **untested by the sampled practice questions** and are the main Phase-2 gaps (below).

---

## Task-statement outline (one line each)
**Domain 1 — Agentic Architecture & Orchestration (27%)**
- 1.1 Agentic loops: drive control flow off `stop_reason` (`tool_use` vs `end_turn`); append tool results to history. *Anti-patterns: parsing NL to decide termination, arbitrary iteration caps, checking for text as a done-signal.*
- 1.2 Coordinator–subagent (hub-and-spoke): coordinator owns routing, error handling, decomposition; subagents have **isolated** context.
- 1.3 Subagent invocation/spawning: `Task` tool + `allowedTools` must include `"Task"`; context must be passed **explicitly** (no auto-inheritance); parallel = multiple `Task` calls in one response; `AgentDefinition` config.
- 1.4 Multi-step workflows: **programmatic enforcement (hooks, prerequisite gates) vs prompt guidance**; structured handoff summaries on escalation.
- 1.5 Agent SDK hooks: `PostToolUse` to normalize data / intercept results; intercept outgoing calls to enforce business rules — deterministic guarantee vs probabilistic prompt.
- 1.6 Task decomposition: fixed prompt-chaining vs dynamic adaptive decomposition; narrow decomposition → incomplete coverage.
- 1.7 Session state: `--resume <name>`, `fork_session` for divergent branches; prefer fresh session + structured summary over resuming with stale tool results.

**Domain 2 — Tool Design & MCP Integration (18%)**
- 2.1 Tool interfaces: descriptions are the **primary** selection signal; eliminate overlap (rename/clarify); system-prompt keywords can override descriptions.
- 2.2 Structured error responses: MCP `isError`; `errorCategory` (transient/validation/business/permission), `isRetryable`; distinguish access-failure vs valid-empty-result; local recovery before propagation.
- 2.3 Tool distribution & `tool_choice`: least privilege; replace generic with constrained tools (`fetch_url`→`load_document`); scoped cross-role tools (`verify_fact`); `tool_choice` `auto`/`any`/forced.
- 2.4 MCP server integration: project `.mcp.json` vs user `~/.claude.json`; env-var expansion `${GITHUB_TOKEN}`; all servers' tools discovered at connect; MCP **resources** as content catalogs.
- 2.5 Built-in tools: Grep (content) / Glob (paths) / Read+Write / Edit (unique-match; Read+Write fallback).

**Domain 3 — Claude Code Configuration & Workflows (20%)**
- 3.1 CLAUDE.md hierarchy: user `~/.claude/CLAUDE.md` / project / directory; `@import`; `.claude/rules/`; `/memory`.
- 3.2 Slash commands & skills: project `.claude/commands/` vs user `~/.claude/commands/`; SKILL.md frontmatter `context: fork`, `allowed-tools`, `argument-hint`; **skills (on-demand) vs CLAUDE.md (always-loaded)**.
- 3.3 Path-specific rules: `.claude/rules/` YAML `paths:` globs load conventions only when editing matching files; beat directory-bound CLAUDE.md for cross-cutting types.
- 3.4 Plan mode vs direct: plan = large/architectural/multi-file/multiple-valid-approaches; direct = small well-scoped; Explore subagent for verbose discovery.
- 3.5 Iterative refinement: concrete I/O examples > prose; test-driven iteration; "interview pattern"; single message for interacting fixes vs sequential for independent.
- 3.6 CI/CD: `-p`/`--print` non-interactive; `--output-format json` + `--json-schema`; CLAUDE.md supplies review/test criteria; independent review instance beats self-review; feed prior findings to avoid dup comments.

**Domain 4 — Prompt Engineering & Structured Output (20%)**
- 4.1 Explicit criteria > vague ("flag when claimed behavior contradicts code" beats "check comments"); FP rates erode trust; temporarily disable high-FP categories.
- 4.2 Few-shot: most effective for consistent format / ambiguous-case handling / generalization / reducing extraction hallucination (2–4 targeted examples).
- 4.3 Structured output: `tool_use` + JSON schema = no syntax errors (but not semantic); `tool_choice` `auto`/`any`/forced; nullable fields prevent fabrication; `"other"`+detail enums.
- 4.4 Validation/retry/feedback: append specific validation errors on retry; retry useless when info is **absent** from source; `detected_pattern` to analyze dismissals; semantic vs syntax errors.
- 4.5 Batch processing: Message Batches API = ~50% cheaper, ≤24h window, **no latency SLA**, **no multi-turn tool calling**; `custom_id` correlation; for latency-tolerant jobs, not blocking pre-merge.
- 4.6 Multi-instance / multi-pass review: independent instance > self-review; per-file local passes + separate cross-file integration pass to avoid attention dilution.

**Domain 5 — Context Management & Reliability (15%)**
- 5.1 Conversation context: progressive-summarization loses numbers/dates → extract a durable **"case facts"** block; "lost in the middle"; trim verbose tool outputs; front-load summaries + section headers.
- 5.2 Escalation/ambiguity: escalate on explicit human request, **policy gaps** (not just complexity), or no-progress; sentiment & self-reported confidence are poor proxies; multiple matches → ask for identifiers.
- 5.3 Error propagation (multi-agent): structured error context (type, attempted query, partial results, alternatives); access-failure vs valid-empty; coverage annotations; don't silently suppress or kill whole workflow.
- 5.4 Large-codebase context: scratchpad files for key findings; subagent delegation for verbose exploration; structured state exports/manifests for crash recovery; `/compact`.
- 5.5 Human review & calibration: field-level confidence calibrated on labeled sets; stratified sampling; accuracy by doc-type/field before automating; aggregate metrics can mask segment failures.
- 5.6 Provenance & uncertainty: structured claim-source mappings preserved through synthesis; annotate conflicting stats with attribution; require publication/collection dates; render content types appropriately.

---

## Official sample questions (12) — principle + which of our notes it maps to
> Letters are the guide's own; on the real exam the same concept can sit under a different letter because option
> order differs. **Study the principle, not the letter.**

**Customer Support**
1. Agent skips `get_customer`, calls `lookup_order` by name → **A**: programmatic prerequisite blocking downstream calls (deterministic > prompt for financial logic). → `common-mistakes/d1-deterministic-tool-ordering.md`.
2. `get_customer` vs `lookup_order` have minimal/overlapping descriptions → **B**: expand each description (inputs, examples, edge cases, when-vs-similar) as the low-effort first step. → `common-mistakes/d2-tool-distribution-eliminate-name-overlap.md`, `common-mistakes/d2-tool-selection-keyword-steering.md`.
3. 55% FCR; over-escalates easy / over-handles hard → **A**: explicit escalation criteria + few-shot (not self-confidence/sentiment). → `common-mistakes/d5-escalation-calibration-system-prompt.md`.

**Code Generation**
4. Team-wide `/review` command on clone/pull → **A**: `.claude/commands/` in the repo (version-controlled). → **gap** (no practice-question note).
5. Monolith→microservices across dozens of files → **A**: plan mode (architectural, multi-file). → **gap**.
6. Per-type conventions, test files spread across repo → **A**: `.claude/rules/` with glob `paths:` (auto, path-based; beats directory CLAUDE.md). → **gap**.

**Multi-Agent Research**
7. Reports miss music/writing/film; coordinator split topic too narrowly → **B**: coordinator decomposition too narrow (subagents executed correctly). → `common-mistakes/d1-decomposition-coverage-all-domains.md`.
8. Web-search subagent times out → **A**: return structured error context (type, attempted query, partial results, alternatives). → `common-mistakes/d5-error-propagation-handle-low-escalate.md` (rel. access-fail-vs-empty, graceful-degradation).
9. Synthesis needs frequent fact-checks (85% simple) → **A**: scoped `verify_fact` tool for the common case, route complex via coordinator. → `common-mistakes/d2-tool-distribution-scoped-fast-path-tool.md`.

**CI**
10. `claude "..."` hangs waiting for input → **A**: `-p`/`--print` non-interactive flag. → **gap**.
11. Manager wants both pre-merge + overnight on Message Batches API → **A**: batch the overnight report only; keep real-time for blocking pre-merge. → `common-mistakes/d4-batch-processing-mode-selection.md` (rel. batch-api-vs-iterative-loops).
12. 14-file PR, single-pass review inconsistent → **A**: per-file passes + a separate cross-file integration pass. → `common-mistakes/d4-multipass-review.md` (rel. d3-stateful-iterative-review); core of Task 4.6.

---

## Coverage gaps vs the official guide — now closed by 🔵 gap-fill notes
> **Status:** these gaps are addressed by **19 gap-fill notes** (all case notes in `exam-notes/common-mistakes/` are named `dN-<slug>.md`, e.g. `d3-claudemd-hierarchy.md`) catalogued in
> [`INDEX.md`](INDEX.md) → *Gap-fill notes*. The list below is the original gap map (what each note covers).

The 24 sampled practice questions are strong on Domains 1, 2 and the CS/CI scenarios, but originally **left these in-scope areas untested**:
- **Whole scenarios:** Developer Productivity with Claude (S4); Structured Data Extraction (S6).
- **Domain 1:** agentic-loop `stop_reason` control flow (1.1); session resume/`fork_session` (1.7); `PostToolUse`/interception hooks (1.5).
- **Domain 2:** MCP server config — `.mcp.json` vs `~/.claude.json`, env-var expansion, resources (2.4); built-in tool selection Grep/Glob/Edit (2.5); MCP `isError`/`errorCategory`/`isRetryable` structured errors (2.2).
- **Domain 3:** slash-command location (SQ4); `.claude/rules` globs (SQ6); plan vs direct (SQ5); `-p`/`--output-format json`/`--json-schema` (SQ10); CLAUDE.md hierarchy + `@import` (3.1).
- **Domain 4:** structured output via `tool_use`+JSON schema & `tool_choice` (4.3); validation/retry/feedback loops (4.4); multi-pass review (4.6 / SQ12).
- **Domain 5:** large-codebase context / scratchpads / `/compact` (5.4); human-review confidence calibration & stratified sampling (5.5); provenance / claim-source / temporal-conflict (5.6).

## Study resources (Anthropic Academy — `anthropic.skilljar.com`)
- **Foundational:** AI Fluency: Framework & Foundations · Claude 101 · Building with the Claude API (first 4 sections).
- **Intermediate:** Introduction to Model Context Protocol · **Claude Code in Action** (context mgmt, hooks, custom commands, Agent SDK) · Building with the Claude API (remaining sections — tool use, agents, production patterns).
- **Advanced:** Model Context Protocol: Advanced Topics (sampling, notifications, transports).

## Out of scope (will NOT appear)
Fine-tuning/training; API auth/billing/keys; language/framework specifics; MCP server deployment/hosting; Claude internals/weights; Constitutional AI/RLHF; embeddings/vector DBs; computer use; vision/image analysis; streaming/SSE; rate limits/quotas/pricing; cloud-provider configs; benchmarking; prompt-caching internals; tokenization specifics.
