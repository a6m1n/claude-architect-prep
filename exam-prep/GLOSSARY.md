# 📖 Glossary cheat-sheet (exam day)

All key flags, files, and terms — one line each. Grouped by domain. Reread it an hour before the exam.

---

## D1 · Agentic Architecture
- **`stop_reason`** — the loop driver. `"tool_use"` → run the tool, add `tool_result` to history, repeat. `"end_turn"` → stop, final answer. Do NOT parse text, do NOT rely on an iteration cap as the main stop.
- **agentic loop** — request → inspect `stop_reason` → execute tool → append result → repeat. The model makes the decisions (model-driven), not a decision tree.
- **hub-and-spoke** — the coordinator owns all communication, routing, error handling, decomposition, and aggregation. Subagents have **isolated context**.
- **narrow decomposition** — the most common cause of "missed coverage": subagents did their job right, but the coordinator split the topic poorly.
- **`Task`** — the tool that spawns subagents; the coordinator's `allowedTools` MUST include `"Task"`. Parallelism = several `Task` calls in ONE response.
- **explicit context passing** — subagents do NOT inherit context automatically; pass the full findings in the prompt. Keep content separate from metadata (URL, document name, page).
- **`AgentDefinition`** — the subagent config: description, system prompt, tool limits.
- **programmatic enforcement** — hooks / prerequisite gates give a **deterministic guarantee**; a prompt gives only a probabilistic one. For safety-critical ordering (verify before refund) — use a gate.
- **handoff summary** — on escalation: customer ID, root cause, amount, recommended action (the human does not see the transcript).
- **`PostToolUse` hook** — intercepts the RESULT of a tool (normalizing formats: Unix ts, ISO 8601, status codes). Intercepting the OUTGOING call — a block by business rule (refund > $500 → escalation).
- **chaining vs adaptive** — fixed prompt chaining for predictable multi-aspect tasks; dynamic adaptive decomposition for open-ended research.
- **`--resume <name>`** — continue a named session. **`fork_session`** — an independent branch from a shared baseline. Stale tool results → a fresh session + structured summary is better than resume.

## D2 · Tool Design & MCP
- **tool description** — the PRIMARY signal for tool selection. A thin description → unreliable selection. Expanding the description (inputs, examples, edge cases, when-vs-similar) is a cheap first step.
- **system-prompt keywords** can OVERRIDE a good description — check the prompt for keyword steering.
- **`isError`** — the MCP flag for a failed tool.
- **`errorCategory`** — `transient` (timeout/unavailable) · `validation` (bad input) · `business` (policy) · `permission`. **`isRetryable`/`retriable:false`** — whether it's worth retrying.
- **access failure ≠ valid empty result** — an access failure (needs a retry decision) versus a successful empty response (0 matches, not an error).
- **local recovery** — the subagent handles transient issues itself; it passes up only what it can't resolve + partial results + what it tried.
- **least privilege** — 18 tools instead of 4–5 degrade selection. Tools outside the specialization → misuse. Give only what's needed + a narrow cross-role one (`verify_fact`).
- **constrained tool** — replace `fetch_url` → `load_document` (validates the URL).
- **`tool_choice`** — `"auto"` (may return text) · `"any"` (must call some tool) · forced `{"type":"tool","name":"..."}` (a specific tool).
- **`.mcp.json`** (project, in VCS, shared) vs **`~/.claude.json`** (user, personal/experimental). **`${GITHUB_TOKEN}`** — env-expansion, don't commit secrets.
- **MCP discovery** — the tools of ALL servers are available at once on connect.
- **MCP resources** — content catalogs (issue summaries, doc hierarchies, DB schemas) — they cut exploratory calls.
- **Grep** = search by CONTENT · **Glob** = search by PATHS/names (`**/*.test.tsx`) · **Edit** = a targeted change by UNIQUE match (no unique match → **Read+Write** fallback).

## D3 · Claude Code Config
- **CLAUDE.md hierarchy** — user `~/.claude/CLAUDE.md` (personal, NOT shared) · project `.claude/CLAUDE.md` or root `CLAUDE.md` (team, in VCS) · directory-level.
- **`@import`** — modularity for CLAUDE.md (pulling in standards files). **`.claude/rules/`** — topical rules instead of a monolith. **`/memory`** — check which memory is loaded.
- **`.claude/commands/`** (project, in VCS) vs **`~/.claude/commands/`** (user). 
- **skills** — `.claude/skills/` + `SKILL.md` frontmatter: **`context: fork`** (isolation, doesn't clutter the main dialog) · **`allowed-tools`** (limit the tools) · **`argument-hint`** (request parameters).
- **skills (on-demand)** vs **CLAUDE.md (always-loaded)** — the key difference.
- **`.claude/rules` + `paths:` globs** — conventions load ONLY when editing matching files; they beat directory-bound CLAUDE.md for file types scattered across the repo.
- **plan mode** — large/architectural/multi-file/several valid approaches (monolith→microservices, a 45+ file migration). **direct** — small, clearly scoped (single-file fix). The **Explore subagent** isolates verbose discovery.
- **iterative refinement** — concrete I/O examples > prose; test-driven (share failures); the interview pattern (Claude asks questions); one message for INTERRELATED fixes, sequentially — for INDEPENDENT ones.
- **`-p` / `--print`** — non-interactive mode for CI (otherwise it hangs). **`--output-format json` + `--json-schema`** — machine-readable output.
- **independent review > self-review** — the session that generated the code reviews it worse.

## D4 · Prompt Engineering & Structured Output
- **explicit criteria > vague** — "flag when claimed behavior contradicts code" > "check comments". "be conservative"/"high-confidence" do NOT improve precision.
- **false positives** destroy trust in ALL categories → temporarily disable noisy categories.
- **few-shot** — the best technique for a stable FORMAT, ambiguous cases, generalization, and reducing hallucinations in extraction. 2–4 targeted examples WITH reasoning.
- **`tool_use` + JSON schema** — reliable structured output; it removes SYNTAX errors, but NOT semantic ones (the total doesn't add up, a value is in the wrong field).
- **nullable/optional fields** — when data may be absent → the model doesn't fabricate. **enum + `"other"` + detail** — extensible categories. **`"unclear"`** — for the ambiguous.
- **retry with error-feedback** — add the SPECIFIC validation error to the prompt. Retry is USELESS if the data is NOT in the source (≠ format/structural errors).
- **`detected_pattern`** — a field for analyzing patterns in rejected findings. **`calculated_total` vs `stated_total`**, **`conflict_detected`** — self-correction.
- **Message Batches API** — **~50% cheaper**, a window **up to 24h**, **no latency SLA**, **no multi-turn tool calling**. **`custom_id`** — correlation. Only latency-tolerant (overnight), NOT blocking pre-merge.
- **multi-pass review** — per-file local passes + a separate cross-file integration pass (against attention dilution). Don't require consensus of N runs (it suppresses rare real bugs).

## D5 · Context & Reliability
- **progressive summarization** loses numbers/dates/percentages → move a **"case facts" block** (amounts, dates, order #, statuses) into every prompt, outside the summary.
- **lost in the middle** — the model is reliable at the start/end of a long input, may skip the middle → front-load the summary + section headers.
- **trim tool outputs** — keep only the relevant fields (40+ fields, you need 5).
- **escalation triggers** — an explicit request for a human · a policy gap (not "it's hard") · no progress. Sentiment and self-confidence are poor proxies. Several matches → ask for an extra identifier.
- **structured error context** — failure type + attempted query + partial results + alternatives → the coordinator makes the decision. Anti-patterns: silent suppression (empty as success) and killing the whole workflow on one error.
- **coverage annotations** — in the synthesis, mark what is well supported and where there's a gap due to unavailable sources.
- **context degradation** — in a long session the model refers to "typical patterns" instead of specifics → **scratchpad files**, subagent delegation, a **manifest** for crash-recovery, **`/compact`**.
- **confidence calibration** — aggregate accuracy (97%) masks failure on segments → **stratified sampling**, field-level confidence on labeled sets, validation by doc-type/field BEFORE automation.
- **provenance** — keep the claim-source mapping through the synthesis; a conflict in statistics → annotate with attribution, don't pick arbitrarily; require DATES (otherwise a temporal diff reads as a contradiction); render content types differently (financial→tables, news→prose).

---

## ⚔️ Paired traps (tell them apart instantly)

| A | B |
|---|---|
| **Grep** (content) | **Glob** (paths/names) |
| `tool_choice: auto` (may return text) | `any` (must call a tool) / forced (a specific one) |
| `.claude/commands` (project/VCS) | `~/.claude/commands` (user) |
| project/root CLAUDE.md (team) | `~/.claude/CLAUDE.md` (personal, not shared) |
| skills (on-demand) | CLAUDE.md (always-loaded) |
| access failure (needs retry) | valid empty result (not an error) |
| syntax error (removed by `tool_use`) | semantic error (NOT removed) |
| batch (latency-tolerant, async) | sync (blocking pre-merge) |
| plan mode (large/architectural) | direct (small, well-scoped) |
| programmatic gate/hook (guarantee) | prompt instruction (probabilistic) |
| `.claude/rules` globs (cross-cutting) | directory CLAUDE.md (bound to a folder) |
| retry helps (format/structural) | retry useless (data not in the source) |

## 🚫 Out of scope (won't appear)
Fine-tuning/training · API auth/billing/keys · language/framework specifics · deploying/hosting MCP servers · Claude internals/weights · Constitutional AI/RLHF · embeddings/vector DB · computer use · vision/image · streaming/SSE · rate limits/quotas/pricing · cloud configs · benchmarking · prompt-caching internals · tokenization.
