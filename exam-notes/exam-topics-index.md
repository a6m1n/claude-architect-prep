# Exam Topics Index — Claude Certified Architect: Foundations

> **Purpose:** Compact navigator. Each domain lists its task statements with the key topics they test — not the full theory, just enough to know *what's in scope* and where to dig deeper.
>
> **Source:** Anthropic's official Claude Certified Architect – Foundations exam guide (distilled in `00-EXAM-GUIDE.md`)

---

## Exam at a Glance

| Property | Value |
|---|---|
| Format | Multiple choice (1 correct + 3 distractors) |
| Pass score | **720 / 1000** |
| Unanswered | Scored as wrong (no penalty for guessing) |
| Target experience | 6+ months building with Claude APIs / Agent SDK / Claude Code / MCP |

**Domain weights:**

| Domain | Weight |
|---|---|
| D1: Agentic Architecture & Orchestration | **27%** |
| D2: Tool Design & MCP Integration | 18% |
| D3: Claude Code Configuration & Workflows | **20%** |
| D4: Prompt Engineering & Structured Output | **20%** |
| D5: Context Management & Reliability | 15% |

> D1 is the heaviest domain; D1 + D3 + D4 = **67%** of the exam.

---

## Scenarios (exam shows 4 of 6 at random)

| # | Scenario | Primary Domains | Core Test Focus |
|---|---|---|---|
| 1 | Customer Support Resolution Agent | D1, D2, D5 | Tool design for backend calls, escalation logic, multi-step reasoning under ambiguity |
| 2 | Code Generation with Claude Code | D3, D5 | Plan mode vs. direct execution, CLAUDE.md config, custom slash commands |
| 3 | Multi-Agent Research System | D1, D2, D5 | Orchestration patterns, task decomposition, inter-agent context passing |
| 4 | Developer Productivity | D2, D3, D1 | Tool selection (Read/Grep/Bash), MCP server integration, least-privilege design |
| 5 | Claude Code for CI/CD | D3, D4 | Structured output for pipelines, determinism vs. probabilistic, non-interactive mode |
| 6 | Structured Data Extraction | D4, D5 | JSON schema enforcement, edge-case handling, output validation strategies |

### Scenario details

#### Scenario 1: Customer Support Resolution Agent
- MCP tools: `get_customer`, `lookup_order`, `process_refund`, `escalate_to_human`
- Tests: when to escalate vs. resolve autonomously; tool design for high-ambiguity situations
- KPI focus: first-contact resolution rate

#### Scenario 2: Code Generation with Claude Code
- Tests: CLAUDE.md as always-on instruction carrier vs. skills/commands for on-demand procedures
- Key decision: plan mode (human confirms) vs. direct execution (autonomous)
- Custom slash commands for team-wide workflow standardization

#### Scenario 3: Multi-Agent Research System
- Coordinator spawns specialized subagents: search, document analysis, synthesis, report generation
- Tests: how to pass context between agents (subagents don't inherit parent memory automatically)
- Parallel vs. sequential subagent invocation

#### Scenario 4: Developer Productivity
- Navigating legacy codebases; generating boilerplate; automating repetitive tasks
- Tests: choosing the right built-in tool (Read vs. Grep vs. Bash vs. Glob)
- MCP server integration for project-specific tooling

#### Scenario 5: Claude Code for CI/CD
- Claude Code in non-interactive/automated mode (no human in the loop)
- Tests: prompt engineering for low-false-positive feedback; structured output that downstream tools can parse
- Determinism trade-offs: when to use code/scripts vs. prompting

#### Scenario 6: Structured Data Extraction
- Extracting structured data from unstructured documents; validating against JSON schemas
- Tests: schema enforcement via tool use or response_format; graceful degradation on missing/ambiguous fields
- Reliability at scale: what happens when edge cases appear in production

---

## Domain 1: Agentic Architecture & Orchestration (27%)

### 1.1 — Agentic loops for autonomous task execution
**Topics:** Agentic loop lifecycle (request → inspect `stop_reason` → execute tool → append result → next iteration); `"tool_use"` = continue, `"end_turn"` = stop; model-driven decision-making vs. pre-configured decision trees.
**Skills:** Control flow driven purely by `stop_reason`; append tool results to history between iterations.
**Traps:** Parsing assistant text to decide when to stop · iteration caps as primary stopping mechanism · checking for "done" text content

---

### 1.2 — Multi-agent systems: coordinator–subagent patterns
**Topics:** Hub-and-spoke coordination; subagents have **isolated context** (no memory inheritance); coordinator owns routing, error handling, aggregation.
**Skills:** Dynamic subagent selection by query complexity; iterative refinement loops (evaluate gaps → re-delegate → re-synthesize); route all inter-agent comms through coordinator.
**Traps:** Assuming subagents share memory · always running the full pipeline regardless of complexity · overly narrow decomposition missing broad topics

---

### 1.3 — Subagent invocation, context passing, spawning
**Topics:** `Task` tool = spawning mechanism; `allowedTools` must include `"Task"`; `AgentDefinition` (descriptions, system prompts, tool restrictions); fork-based sessions for divergent exploration.
**Skills:** Pass complete prior findings in the subagent prompt; use structured formats to preserve attribution (source URLs, page numbers); emit multiple Task calls **in one turn** for parallel execution; write coordinator prompts around goals, not procedures.
**Traps:** Forgetting `"Task"` in `allowedTools` · assuming subagents can "look up" prior context · emitting Task calls across separate turns for parallelism

---

### 1.4 — Multi-step workflows: enforcement and handoff patterns
**Topics:** Programmatic enforcement (hooks, gates) vs. prompt-based guidance — fundamentally different reliability; structured handoff protocols (customer details, root cause, recommended actions).
**Skills:** Implement gates that physically block downstream tools until prerequisites met; decompose multi-concern requests into parallel investigations; compile structured handoff summaries for human escalation.
**Traps:** Relying on system prompt to enforce compliance-critical ordering · omitting root cause from handoffs · sequential investigation of independent concerns

---

### 1.5 — Agent SDK hooks: tool call interception and data normalization
**Topics:** `PostToolUse` hooks transform results before model sees them; pre-call hooks block/redirect outgoing calls; hooks = **deterministic** guarantee, prompts = **probabilistic**.
**Skills:** `PostToolUse` to normalize heterogeneous formats (timestamps, codes) into consistent schema; interception hooks to block policy violations (e.g., refund > $500) and redirect to escalation.
**Traps:** Using prompt instructions for rules that need guarantees · normalizing data inside the model prompt · confusing `PostToolUse` (result transform) with pre-call (outgoing intercept)

---

### 1.6 — Task decomposition strategies
**Topics:** Fixed sequential pipelines (prompt chaining) for predictable tasks vs. dynamic adaptive decomposition for open-ended investigation; attention dilution with large file sets.
**Skills:** Match pattern to task type; per-file local passes then cross-file integration; adaptive plan that evolves as findings emerge.
**Traps:** Applying fixed pipelines to open-ended tasks · reviewing all files in one large context · over-planning before structure is understood

---

### 1.7 — Session state, resumption, and forking
**Topics:** `--resume <session-name>` continues a named session; `fork_session` branches from a shared baseline; stale tool results after code changes.
**Skills:** Use `--resume` for cross-session continuity; `fork_session` to compare divergent approaches; choose resumption vs. fresh session + injected summary based on whether prior state is still valid.
**Traps:** Resuming after significant code changes without notifying the agent · using `fork_session` when you need completely isolated contexts · always defaulting to resumption when a fresh-start summary would be more reliable

---

## Domain 2: Tool Design & MCP Integration (18%)

### 2.1 — Effective tool interfaces: descriptions and boundaries
**Topics:** Tool descriptions are the **primary signal** for tool selection; vague/overlapping descriptions = root cause of misrouting; "when NOT to use" clauses; system prompt keywords can create unintended tool associations.
**Skills:** Write descriptions differentiating purpose, inputs/outputs, and contrast with similar tools; rename tools to signal scope; split generic tools into purpose-specific ones; audit system prompts for accidental keyword-to-tool bindings.
**Traps:** Near-identical descriptions on two tools · assuming tool name alone is sufficient · one tool doing 3 things → unpredictable selection

---

### 2.2 — Structured error responses for MCP tools
**Topics:** `isError` flag = protocol-level failure signal; four error categories: **transient** (timeout), **validation** (bad input), **business** (policy violation), **permission** (access denied); retryable vs. non-retryable distinction; access failure ≠ valid empty result.
**Skills:** Return structured payloads with `errorCategory`, `isRetryable` boolean, human-readable description; subagents handle transient failures locally, propagate only irresolvable errors + partial results to coordinator.
**Traps:** Generic `"Operation failed"` (agent can't distinguish transient from permanent) · propagating every error to coordinator · treating empty result set as an error

---

### 2.3 — Tool distribution across agents and `tool_choice`
**Topics:** Too many tools (~18) degrades selection reliability — each agent should have 4–5 tightly scoped tools; out-of-role tools get misused; `tool_choice` options: `"auto"` (model decides), `"any"` (force some tool call), `{"type":"tool","name":"..."}` (force specific tool).
**Skills:** Restrict each subagent's tool set to its role; replace broad tools with constrained versions; use forced `tool_choice` to guarantee execution order; `"any"` prevents text-only responses when action is mandatory.
**Traps:** Giving all agents all tools "for flexibility" · using `"auto"` when a tool call is mandatory · forcing a specific tool on every turn unnecessarily

---

### 2.4 — MCP server integration into Claude Code and agent workflows
**Topics:** `.mcp.json` = project-scoped (committed, shared team tooling); `~/.claude.json` = user-scoped (personal/experimental); env var expansion (`${GITHUB_TOKEN}`) keeps credentials out of source control; **MCP resources** expose content catalogs without exploratory tool calls.
**Skills:** Choose scope (project vs. user) by sharing intent; use env var expansion for auth tokens; enhance MCP tool descriptions so agent prefers them over weaker built-ins; prefer existing community MCP servers for standard integrations; structure data as MCP resources to reduce discovery calls.
**Traps:** Committing secrets directly into `.mcp.json` · building custom server when community server already exists · poor descriptions causing fallback to weaker built-in tools

---

### 2.5 — Built-in tools: Read, Write, Edit, Bash, Grep, Glob
**Topics:** **Grep** = search file *contents* for patterns; **Glob** = match file *paths* by pattern; **Edit** = targeted in-place modification with unique anchor text (fails on non-unique matches); Read + Write = fallback when Edit's uniqueness requirement not met.
**Skills:** Choose Grep vs. Glob based on content vs. filename target; use Read → Write as fallback for Edit; incremental exploration (Grep entry points → Read to trace imports) vs. bulk reading; trace cross-module usage by listing exported names then searching.
**Traps:** Using Grep for filenames or Glob for content · Edit on files with repeated identical strings · bulk-reading all files at session start · using Bash for reads/edits when Read/Edit is more precise

---

## Domain 3: Claude Code Configuration & Workflows (20%)

### 3.1 — CLAUDE.md hierarchy, scoping, and modular organization
**Topics:** Three-tier hierarchy: user-level (`~/.claude/CLAUDE.md`, personal/not shared) → project-level (root `CLAUDE.md` or `.claude/CLAUDE.md`, committed) → directory-level (subdirectory `CLAUDE.md`); `@import` syntax for modular loading; `.claude/rules/` as alternative to monolithic file.
**Skills:** Diagnose why a teammate isn't getting instructions (user vs. project scope confusion); use `@import` to load standards per package; split into focused files in `.claude/rules/`; use `/memory` to verify which files are actually loaded.
**Traps:** Placing team rules in `~/.claude/CLAUDE.md` (personal, teammates never see it) · forgetting that `.claude/rules/` with path scoping exists

---

### 3.2 — Custom slash commands and skills
**Topics:** Project-scoped commands in `.claude/commands/` (version-controlled, team-wide) vs. user-scoped in `~/.claude/commands/` (personal); skills in `.claude/skills/` with `SKILL.md` frontmatter: `context: fork`, `allowed-tools`, `argument-hint`; `context: fork` = isolated sub-agent context (verbose output stays out of main conversation).
**Skills:** Create project-scoped commands for team availability; isolate verbose skills with `context: fork`; restrict tools per skill via `allowed-tools`; prompt for required parameters with `argument-hint`.
**Traps:** Using CLAUDE.md for procedural task-specific workflows (→ skills) · without `context: fork`, skill output pollutes main conversation · personal skill variants overriding team-shared ones

---

### 3.3 — Path-specific rules for conditional convention loading
**Topics:** `.claude/rules/` files use **YAML frontmatter `paths` fields** with glob patterns; rules load only when editing files matching the glob; glob rules can target by file type across any directory (`**/*.test.tsx`), which subdirectory CLAUDE.md cannot.
**Skills:** Write YAML frontmatter path scoping (e.g., `paths: ["terraform/**/*"]`); choose glob rules over subdirectory CLAUDE.md when conventions span multiple directories; structure rules by file type rather than location.
**Traps:** Defaulting to subdirectory CLAUDE.md when test/config files are spread across the codebase · loading all rules always (wastes context window)

---

### 3.4 — Plan mode vs. direct execution
**Topics:** **Plan mode** = large-scale changes, multiple valid approaches, architectural decisions, multi-file modifications; **Direct execution** = simple, well-scoped, single-file changes; **Explore subagent** isolates verbose discovery output, preventing context exhaustion.
**Skills:** Recognize architectural signals (library migrations, 45+ files, infrastructure tradeoffs) → plan mode; recognize simple-scope signals (single-file bug fix) → direct; combine modes (plan to investigate, direct to implement); use Explore subagent for discovery phases.
**Traps:** Direct execution for tasks with multiple valid architectural approaches · plan mode for trivially scoped changes · running verbose discovery inline instead of via Explore subagent

---

### 3.5 — Iterative refinement techniques
**Topics:** Concrete input/output examples (2–3 pairs) most reliable for specifying transformations; test-driven iteration (write tests → share failures → drive improvement); **interview pattern** (Claude asks clarifying questions before implementing in unfamiliar domains); interacting vs. independent issues.
**Skills:** Replace vague prose with concrete before/after examples; iterate via test failures rather than re-describing requirements; use interview pattern for complex/unfamiliar domains; batch interacting issues in one message, sequence independent ones.
**Traps:** Multiple independent fixes in one message (Claude may conflate them) · prose descriptions when examples would be unambiguous · jumping to implementation in unfamiliar domains without surfacing design considerations

---

### 3.6 — Claude Code in CI/CD pipelines
**Topics:** `-p` / `--print` flag = **non-interactive mode** (required to prevent pipeline hangs); `--output-format json` + `--json-schema` for machine-parseable output; CLAUDE.md provides CI-invoked instances with project context; **session isolation**: fresh instance reviews more objectively than the generating instance.
**Skills:** Run Claude Code in CI scripts with `-p` flag; produce structured JSON for automated inline PR comments; scope follow-up review runs to report only new/unresolved issues; use CLAUDE.md to document test conventions for auto-generated tests.
**Traps:** Omitting `-p` in CI (hangs indefinitely) · same session that authored code also reviews it (blind spots) · not including prior findings when re-running after new commits (duplicate comments)

---

## Domain 4: Prompt Engineering & Structured Output (20%)

### 4.1 — Explicit criteria to improve precision and reduce false positives
**Topics:** Explicit categorical criteria ("flag only when X contradicts Y") vs. vague confidence-based filters ("be conservative"); high false-positive rate destroys developer trust; general hedging phrases don't work.
**Skills:** Rewrite vague instructions as specific categorical inclusion/exclusion rules; temporarily disable high-FP categories to restore trust while fixing prompts; write severity rubrics with concrete code examples per level.
**Traps:** "Instruct the model to be more conservative" = canonical wrong answer · confusing precision improvement with confidence filtering

---

### 4.2 — Few-shot prompting for output consistency
**Topics:** Few-shot examples = primary fix when detailed instructions alone produce inconsistent output; examples should show reasoning, not just desired answer; enables generalization to novel patterns; reduces hallucination in extraction with varied source formats.
**Skills:** Construct 2–4 targeted examples showing why one action was chosen over plausible alternatives; demonstrate exact desired output format in examples; use examples to distinguish acceptable patterns from genuine issues (FP reduction).
**Traps:** "Add more detailed instructions" as the fix for inconsistency (few-shot outperforms instruction expansion) · thinking few-shot only helps recall tasks

---

### 4.3 — Structured output via tool use and JSON schemas
**Topics:** `tool_use` + JSON schema = only reliable method for guaranteed schema-compliant output; `tool_choice`: `"auto"` (may skip tool), `"any"` (must call a tool), forced named tool; strict schemas eliminate **syntax errors** but NOT **semantic errors** (values wrong, fields swapped).
**Skills:** Force a specific tool via `tool_choice: {"type":"tool","name":"..."}` for extraction order; use `"any"` when doc type unknown but output must be structured; design nullable optional fields to prevent hallucination; add `"unclear"` enums and `"other"` + detail fields for extensibility.
**Traps:** Assuming `tool_use` prevents semantic validation errors (it doesn't) · `tool_choice: "auto"` when guaranteed structured output is required · making all schema fields required when source docs may lack data

---

### 4.4 — Validation, retry, and feedback loops
**Topics:** Retry-with-error-feedback: append specific validation errors to prompt on retry (not just re-run); if required info is absent from source, retries can't help; semantic vs. syntax validation errors; `detected_pattern` fields for systematic FP analysis.
**Skills:** Implement self-correction: original doc + failed extraction + specific errors → model corrects; diagnose when retry is appropriate (format mismatch) vs. futile (missing source data); design cross-checks (`calculated_total` vs. `stated_total`, `conflict_detected` boolean).
**Traps:** Retrying when information isn't in the document (accept null, don't retry) · thinking schema enforcement solves semantic errors · sending only the error on retry without the original doc and failed extraction

---

### 4.5 — Batch processing strategies
**Topics:** Message Batches API: 50% cost reduction, up to 24-hour window, no latency SLA; workload fit: batch = latency-tolerant (overnight reports, nightly generation); synchronous = blocking workflows (pre-merge checks); batch API does NOT support multi-turn tool calling within a single request; `custom_id` for correlation and resubmission.
**Skills:** Match API choice to latency requirements; calculate submission windows based on SLA constraints; handle partial failures by resubmitting only failed `custom_id` items with modifications; refine prompts on sample set before large-volume submission.
**Traps:** Batch API for pre-merge/blocking checks (24-hour window incompatible) · assuming batch supports multi-turn tool use · resubmitting entire batch on partial failure

---

### 4.6 — Multi-instance and multi-pass review architectures
**Topics:** Self-review limitation: generating instance retains reasoning context → blind to own errors; independent review instance (no prior context) catches subtle issues; multi-pass: per-file local passes + separate cross-file integration passes (prevents attention dilution and contradictory findings).
**Skills:** Route generated code to a second independent instance without generator's context; split large reviews into per-file local + cross-file integration passes; run confidence-reporting verification passes for calibrated routing.
**Traps:** "Instruct the model to self-review more carefully" (independent instance is the correct answer) · all files in one instance for large codebases · confusing "extended thinking" with independent review (same reasoning context)

---

## Domain 5: Context Management & Reliability (15%)

### 5.1 — Preserve critical information across long interactions
**Topics:** "Lost in the middle" effect — model reliably attends to beginning and end, drops middle; progressive summarization degrades numerical precision (amounts, dates, percentages); tool result accumulation bloats context.
**Skills:** Extract transactional facts into a persistent **"case facts" block** separate from summarized history; trim tool outputs to relevant fields only; place key findings at the **beginning** of aggregated inputs; require subagents to include metadata (dates, source, method) in structured outputs.
**Traps:** Rolling summaries alone losing exact figures (→ dedicated structured block, not better summarization) · keeping all tool response fields by default

---

### 5.2 — Escalation and ambiguity resolution patterns
**Topics:** Explicit vs. inferred escalation triggers: customer explicitly demanding a human = non-negotiable; complexity is not a reliable trigger; policy gaps (policy silent on request type) = escalation trigger, not judgment call; multiple matching customer records require clarification.
**Skills:** Add escalation criteria with few-shot examples to system prompt showing decide-vs-escalate boundaries; honor explicit human-agent requests **immediately** without attempting investigation first; escalate when policy is silent or ambiguous.
**Traps:** Sentiment scores or self-reported confidence as escalation triggers · attempting to resolve when customer already requested a human · selecting among multiple matches by heuristic

---

### 5.3 — Error propagation across multi-agent systems
**Topics:** Structured error context = failure type + what was attempted + partial results + possible alternatives; **access failure** (timeout → retry candidate) ≠ **valid empty result** (query succeeded, no data); generic error statuses hide recovery-relevant information.
**Skills:** Return structured error objects (not empty results or generic strings); local recovery for transient errors at subagent level; annotate synthesis output with **coverage gaps** marking undercovered areas due to source unavailability.
**Traps:** Silently returning empty results on error (coordinator can't distinguish from "no data exists") · terminating entire workflow on single subagent failure · conflating access failure with empty result

---

### 5.4 — Context management in large codebase exploration
**Topics:** Context degradation in long sessions (model shifts from specific discovered classes to generic "typical patterns"); scratchpad files as external persistent state; structured state manifests for crash recovery.
**Skills:** Spawn subagents for isolated verbose exploration while main agent holds coordination; agents write **scratchpad files** and read back for subsequent questions; use `/compact` to reduce context during extended exploration; design **crash-resume** patterns with manifest files that reinject prior state.
**Traps:** Running all exploration in a single agent's context (verbose tool output crowds out earlier findings) · relying on in-context memory across multiple phases instead of externalizing to files

---

### 5.5 — Human review workflows and confidence calibration
**Topics:** Aggregate accuracy metrics (e.g., 97% overall) can mask poor performance on specific document types; stratified random sampling detects error patterns within high-confidence extractions; field-level confidence scores must be calibrated against labeled validation sets, not raw model self-report.
**Skills:** Implement stratified random sampling across high-confidence extractions for ongoing QA; segment accuracy analysis by document type and field before reducing review coverage; calibrate review routing thresholds using labeled validation sets; route ambiguous/contradictory sources to human review regardless of model confidence.
**Traps:** Using aggregate accuracy to justify reducing review · trusting raw model confidence scores without calibration · treating high-confidence extractions as exempt from sampling

---

### 5.6 — Information provenance and uncertainty in multi-source synthesis
**Topics:** Summarization destroys source attribution unless **claim-source mappings** are explicitly preserved; conflicting statistics from credible sources must be annotated, not arbitrarily resolved; temporal data requires publication/collection dates to prevent gaps appearing as factual contradictions.
**Skills:** Require subagents to output structured claim-source mappings (URL, doc name, excerpt); structure synthesis reports with **well-established** vs. **contested findings** sections; pass conflicting values annotated with sources to coordinator for reconciliation — not resolving at subagent level; render content type-appropriately (financial data as tables, news as prose, technical as structured lists).
**Traps:** Compressing subagent findings into prose (source attribution lost) · arbitrarily selecting one value when sources conflict · uniform formatting across all content types

---

## Sample Questions — Exam Intelligence

12 official sample questions covering 4 of 6 scenarios: Customer Support · Code Generation · Multi-Agent Research · Claude Code for CI. (Developer Productivity and Structured Data Extraction not in sample.)

### Question-to-topic map

| Q | Domain | Core concept tested |
|---|---|---|
| 1 | D4/D5 | Deterministic enforcement vs. prompt-based compliance for critical sequences |
| 2 | D2 | Tool description quality as the primary driver of tool selection accuracy |
| 3 | D4 | Root-cause diagnosis of agent miscalibration; proportionate first fix |
| 4 | D3 | Project-scoped vs. personal slash command placement |
| 5 | D3 | Plan mode vs. direct execution for large-scale architectural changes |
| 6 | D3 | `.claude/rules/` glob patterns for path-based convention enforcement |
| 7 | D1 | Coordinator task decomposition as root cause of coverage gaps |
| 8 | D1/D5 | Structured error propagation for coordinator-level intelligent recovery |
| 9 | D1/D2 | Least-privilege tool scoping for subagents; avoiding over-provisioning |
| 10 | D3 | `-p` flag for non-interactive/CI execution |
| 11 | D5 | Batches API fit: latency-sensitive vs. async workflows |
| 12 | D5 | Focused-pass review architecture to counter attention dilution |

### Recurring traps in sample questions

| Trap | Description |
|---|---|
| **Prompt over code** | Distractors offer "add to system prompt" when stakes require deterministic enforcement (money, identity, sequencing) |
| **Over-engineering** | Distractors offer classifiers, routing layers, speculative caches — correct answer is always minimum effective lever |
| **Blaming the wrong agent** | Root cause is in the coordinator's decomposition, not downstream subagents |
| **Over-provisioning tools** | Synthesis agent doesn't need web search — scope to one `verify_fact` tool (least privilege) |
| **Larger context = better attention** | Wrong; architectural decomposition into focused passes beats a bigger window |
| **Non-existent features** | Know the actual API (`-p` flag) vs. invented-sounding alternatives (`CLAUDE_HEADLESS`, `--batch`) |
| **Batch API misapplication** | 50% savings is irrelevant if the workflow has a blocking latency SLA |

### What the exam truly tests

- **Apply/Analyze level only** — every question gives a production scenario with logs/metrics and asks "what's the most effective change?" You are never asked to define a term.
- **Root-cause reasoning** — read a symptom, trace to the actual cause, fix the cause (not a downstream effect).
- **Minimum effective intervention** — the correct answer is consistently the smallest change that addresses the root cause.
- **Determinism vs. prompting** — knowing *when* to trust the model vs. *when* to constrain it is load-bearing.
- **Claude Code specifics are testable details** — `.claude/commands/` vs `~/.claude/commands/`, plan mode, YAML frontmatter, `-p` flag — these require actual knowledge of Claude Code architecture.

---

## Preparation Exercises

### Exercise 1: Multi-Tool Agent with Escalation Logic (D1, D2, D5)
Builds: tool description differentiation · `stop_reason` control flow · structured error responses (`errorCategory` + `isRetryable`) · programmatic hooks for business-rule enforcement · multi-concern decomposition and synthesis

### Exercise 2: Claude Code Team Workflow Configuration (D3, D2)
Builds: CLAUDE.md project-level hierarchy · `.claude/rules/` YAML frontmatter glob patterns · project-scoped skills with `context: fork` and `allowed-tools` · `.mcp.json` with env var expansion + `~/.claude.json` (both active simultaneously) · plan mode vs. direct execution decision criteria

### Exercise 3: Structured Data Extraction Pipeline (D4, D5)
Builds: JSON schema design (required/optional, `enum` + `"other"`, nullable) · validation-retry loop with original doc + failed extraction + specific error · few-shot for varied document formats · Batches API with `custom_id` failure handling · field-level confidence scores → human review routing

### Exercise 4: Multi-Agent Research Pipeline (D1, D2, D5)
Builds: coordinator with `allowedTools: ["Task"]` · parallel subagent execution (multiple Task calls in one response) · structured subagent output with claim + evidence + source URL + publication date · error propagation with failure type + partial results · conflicting source handling (annotate, preserve both, coordinator reconciles)

---

## Quick Reference: Key Facts & Thresholds

| Fact | Value |
|---|---|
| Pass score | **720 / 1000** |
| Question format | 60 MCQs, 1 correct + 3 distractors, unanswered = wrong |
| Batches API cost reduction | **50%** |
| Batches API processing window | up to **24 hours** |
| Batches API multi-turn tool calling | **NOT supported** |
| `stop_reason` to continue loop | `"tool_use"` |
| `stop_reason` to terminate loop | `"end_turn"` |
| `tool_choice` options | `"auto"` · `"any"` · forced `{"type":"tool","name":"..."}` |
| Error categories | transient · validation · business · permission + `isRetryable` boolean |
| Parallel subagents | coordinator emits multiple Task calls in **ONE response turn** |
| Subagent context inheritance | **None** — must be passed explicitly in the prompt |
| `.claude/rules/` activation | YAML frontmatter `paths:` glob patterns |
| Skills isolation keyword | `context: fork` |
| Nullable schema fields | prevent hallucination of absent information |
| CI non-interactive flag | `-p` / `--print` |

### Out-of-scope (don't study)
Fine-tuning · authentication/billing · infrastructure/deployment · Claude internals · constitutional AI/RLHF · vector DBs · computer use · vision · streaming API · rate limiting · OAuth · cloud provider config · benchmarking · **prompt caching implementation** (only "it exists" is in scope)
