# 🗺️ ROADMAP — a simple path to hard topics

This is a roadmap to **all 30 exam topics** — from the easy ones to the trickiest. It continues the system from [`../exam-notes/learned-rules.md`](../exam-notes/learned-rules.md): the same anchors (🔑 🗼 🪜 🎤📋), the same "ladder of levers", the same reading strategy. Hard things in plain language, one node at a time.

> How to learn for real: open a topic in [`deep-teach`](../.claude/skills/deep-teach/SKILL.md) ("teach me X"), solve the retrieval question **yourself**, and only then check. If it's hard, it's working.

---

## 🧰 One tool solves half the exam: the "ladder of levers"

When an agent behaves wrong, ask: **what is the weakest lever that fixes this?** Take it. But if you need a **guarantee** — climb higher.

| # | Lever | When this is the right answer | Reliability |
|---|---|---|---|
| 1 | Prompt instruction | gently steer, rare deviation is ok | low |
| 2 | Few-shot examples | show the format / anchor a boundary (only **with** a criterion) | low |
| 3 | Explicit criterion / rubric | the model *judges* inconsistently (classification, escalation) | medium |
| 4 | Tool design (narrow/rename/validate) | the agent does extra work / confuses routing / has too-broad access | high |
| 5 | Code / hook (determinism) | you need a 100% invariant: call order, irreversible action, safety | absolute |

🚩 Treating with a prompt (1) something that needs lever 4–5 → **symptom, not root cause**. Jumping to 5 where 3–4 is enough → **over-engineered**.
🧷 **Mantra: the right layer + the minimum sufficient dose.**

## 🎯 How to read a question (a reflex that saves points)

1. **Read from the end** — the last sentence = what is really being asked.
2. Find the **1 symptom sentence** (skips 12%, misrouting 35%, loses the middle, "97% on average"). The rest is decoration.
3. **Name the principle BEFORE the options** (which node below).
4. **Predict the fix** before reading the options, then look for a similar one.
5. Filter out symptom-patches and extremes → choose the **root with the minimum dose**.

---

## 🧩 The 6 nodes that solve the exam

Most questions are 6 recurring ideas. Master them — and you'll untangle the rest. Tags: ✅ = already covered (reinforce) · 🆕 = new hard topic (learn from scratch).

### Node 1 · "Code vs persuasion" 🪜 — determinism (D1 + loop)
> A prompt **asks**, code **doesn't let through**. Where you need a 100% guarantee — put up a barrier (lever 5), not a "please" sign.

**[1.1 Agentic loop](domain-1-agentic-architecture/1.1-agentic-loops.md)** 🆕
🔄 *Traffic light: you drive while it's green (`tool_use`), you stop on red (`end_turn`); you don't guess the color from the announcer's words.*
🚩 "check the response text / put a cap of N iterations as the main signal" → *anti-pattern* → `stop_reason == 'end_turn'` — the only contractual signal; text next to `tool_use` is not completion; the cap is a safety net.
🧷 `tool_use` → execute + append tool_result + resend; `end_turn` → done; `pause_turn` (server-tool) → resend as-is; cap = backstop, not a signal.
<details><summary>Retrieval question</summary> The agent sometimes stops processing an order mid-way — it sees the phrase "Done" in the response text and halts. Root cause and fix? · **Answer:** Completing on text instead of `stop_reason`; Claude can write text AND make a `tool_use` in one response — you must check specifically `stop_reason == 'end_turn'`. </details>

**[1.4 Prerequisite gate](domain-1-agentic-architecture/1.4-workflow-enforcement-handoff.md)** ✅
🪜 *A barrier that physically won't rise without a pass, vs a "please check your pass" sign.*
🚩 "strengthen the prompt / few-shot / lower temperature" for a safe order → *symptom-not-root-cause* → a `PreToolUse` gate blocks downstream until the prerequisite.
🧷 You need 100% ordering — put up a barrier; routing controls *availability*, not *order*; on escalation — a structural handoff (ID + root cause + amount + recommendation).
<details><summary>Retrieval question</summary> The agent calls `charge_card` before `validate_payment_method` 8% of the time, and charges go out on an invalid card (irreversible). (a) a rule in the system prompt, (b) a `PreToolUse` gate, (c) a routing classifier, (d) few-shot — which one and why? · **Answer:** (b) — a deterministic guarantee at the execution layer; (a)/(d) are probabilistic (8% = their failure mode), (c) is about availability, not order. </details>

**[1.5 Hooks: Pre vs Post](domain-1-agentic-architecture/1.5-agent-sdk-hooks.md)** 🆕
🛂 *A customs officer: on the way in brings things to a standard (`PostToolUse` cleans the result), on the way out blocks the forbidden (`PreToolUse` blocks the call).*
🚩 for "must never" they suggest a system prompt / few-shot → *symptom-not-root-cause* → a `PreToolUse` hook with `permissionDecision: "deny"`.
🧷 Pre — doesn't let a bad call through, Post — tidies the result; "never" lives in code, not in the prompt.
<details><summary>Retrieval question</summary> Three MCP tools return time in different ways (Unix / ISO 8601 / numeric code), and the model gets confused. What is the most reliable way to bring them to one format BEFORE the model sees the result? · **Answer:** A `PostToolUse` hook via `updatedToolOutput` normalizes the result in code — not a probabilistic parse of formats by the model. </details>

**[1.7 Session state · `--resume` · fork](domain-1-agentic-architecture/1.7-session-state-resume-fork.md)** 🆕
📂 *A personal case file (conversation history) ≠ the desk (files); `fork` copies the case file, but both lawyers still work with the same folders.*
🚩 "resume is always more reliable" → *trap* → stale tool results reproduce an outdated snapshot; "fork synchronizes both branches" → no, it's one-way; resume doesn't diff the disk.
🧷 context mostly valid → `--resume <name>`; stale results → new session + structural summary; divergence → `fork`; after file changes — name them explicitly.
<details><summary>Retrieval question</summary> You ran an analysis two days ago, and today a teammate renamed 3 key files. Continue with resume or start over? · **Answer:** Resume — but explicitly name the changed files for targeted re-analysis; resume does not detect disk changes automatically. If context is stale → fresh session + inject a structural summary. </details>

### Node 2 · "The orchestra: who does what" 🗼 — multi-agent
> The coordinator = the control tower: it sees everything, fixes errors in one place, decides who knows what, **and slices the task**. A subagent only knows what is literally in its prompt.

**[1.2 Coordinator / hub-and-spoke](domain-1-agentic-architecture/1.2-coordinator-subagent.md)** ✅
🗼 *Everyone talks through the tower; the crews did their part, but the house is incomplete — blame whoever sliced the assignments.*
🚩 "only the coordinator can retry/batch/cache" → *false dichotomy* → take the structural plus (visibility / unified error handling / gating). All subagents are fine, but coverage is incomplete → *symptom-not-root-cause* → the root is in the **narrow decomposition**.
🧷 Retry/batch — anywhere; visibility/gating/decomposition — only the hub. "Read the failure backwards": incomplete coverage = a fault of the slicing, not the executor.
<details><summary>Retrieval question</summary> A report on "AI in medicine" came out covering only diagnostics; all subagents worked correctly, but the coordinator split the topic into "radiology / pathology / radiation diagnostics". Root cause, and why not fix synthesis? · **Answer:** Narrow decomposition — it didn't assign treatment/prevention as subtasks; coverage is solved at the slicing, fixing synthesis is symptom-not-root-cause. </details>

**[1.3 Passing context to a subagent](domain-1-agentic-architecture/1.3-subagent-invocation-context.md)** 🆕
🧳 *A new employee gets a brief in hand, not telepathy; if you want three to work at once — three assignments in one message, not one after another.*
🚩 "inherits context / shared memory / raise `max_tokens`" → *common-misconception* → embed the full findings inline in the `Task` prompt (content + metadata separately). "One after another across different turns = parallel" → *under-engineered* → several `Task` calls in **one** response.
🧷 What's not in the `Task` prompt — the subagent doesn't know it; `Task`/`Agent` must be in the coordinator's `allowedTools`.
<details><summary>Retrieval question</summary> A synthesis subagent with the prompt "Write the final report" produces generic text and ignores the web-search and document-analysis findings. The most effective fix? · **Answer:** Embed the full findings of the prior agents directly into the synthesis `Task` prompt, keeping the source metadata with each; the parent history is not inherited. </details>

**[1.6 Task decomposition](domain-1-agentic-architecture/1.6-task-decomposition.md)** 🆕
🧩 *Assembly by a blueprint (prompt chaining — the steps are known) vs a treasure hunt (adaptive orchestrator — the next step depends on the find).*
🚩 "one big pass over 14 files" → *attention dilution* → per-file passes + a separate cross-file pass; "a bigger context window" → *common-misconception* → window size ≠ attention quality; "aggressively narrow the slicing" → *over-narrow* → whole areas are left without an agent.
🧷 steps known → chaining; steps born from finds → orchestrator-workers; a big review = per-file + cross-file integration pass (an architectural decision).
<details><summary>Retrieval question</summary> A 14-file PR, a single pass — uneven depth and contradictory assessments of the same pattern. Fix? · **Answer:** Per-file local passes + a separate cross-file integration pass; attention dilution is an architectural problem; a bigger context window doesn't help. </details>

> Adjacent here is **[5.3 Error propagation](domain-5-context-reliability/5.3-error-propagation.md)** (✅ learned-rules Topic 1): a subagent is an *outcome reporter* — fix small things yourself, shout about big ones with context, hide nothing.

### Node 3 · "Less is more reliable, fix the tool" 🔑 — tools & MCP
> An agent's capabilities are set by its **tool set**, not the prompt. Fix the tool's contract (description / name / scope / error structure), not the system prompt.

**[2.1 Tool description](domain-2-tool-design-mcp/2.1-tool-interfaces.md)** ✅
🔑 *Two doors with similar signs — the visitor goes to the wrong one; rewrite the signs, don't post a traffic cop.*
🚩 a jump to few-shot / a routing classifier / merging → *symptom-not-root-cause* → first separate + expand the `description` (inputs · examples · edge cases · when-vs-similar).
🧷 The sign matters more than the cop — first the `description`, then the system prompt.
<details><summary>Retrieval question</summary> `lookup_kb` and `lookup_docs` with thin, similar descriptions, misrouting ~35%. First step? · **Answer:** Separate and expand both descriptions — the root is in the overlapping selection interface (lever 4); few-shot/a classifier would treat the symptom. </details>

**[2.3 Tool distribution & `tool_choice`](domain-2-tool-design-mcp/2.3-tool-distribution-tool-choice.md)** ✅
🔑 *A key sized to the lock: not a master key with a note, not an empty keyring — one precise key per role.*
🚩 "give all the tools" / "remove it entirely, route everything through the coordinator" → *extreme* → reshape the tool itself to fit the role (a narrow scoped key). `tool_choice: auto` when you need a guaranteed call → *wrong config* → you need `any` or forced.
🧷 `tool_choice`: `auto` (may use text) · `any` (must use some tool) · forced `{"type":"tool","name":"X"}` (specifically X). Least privilege — capabilities come from the tool set, not the prompt.
<details><summary>Retrieval question</summary> Synthesis makes 2–3 round-trips through the coordinator for verification (+40% latency); 85% are simple facts, 15% are deep. What to do? · **Answer:** A narrow `verify_fact` for simple ones, complex ones go through the 🗼 coordinator; the fast-path removes 85% of round-trips without bloating the role. "Give all the web-tools" is over-provisioning. </details>

**[2.2 Structured MCP errors](domain-2-tool-design-mcp/2.2-mcp-structured-errors.md)** 🆕
🚦 *A station board: "train delayed, reason X, please wait" vs a blinking "something went wrong".*
🚩 all failures = `"Operation failed"` → *symptom-not-root-cause* → a typed error (`errorCategory` `transient`/`validation`/`business`/`permission` + `isRetryable` + a description). `0 results` flagged as an error → *extreme* → an empty result is a **success**, not a failure.
🧷 Say WHICH failure and WHETHER it can be retried; empty ≠ failure; fix the transient yourself, send up only the unresolved with partial results.
<details><summary>Retrieval question</summary> Three sources: articles → 15 works, reports → `0 results`, patents → `Connection timeout`. How to report to the coordinator? · **Answer:** Distinguish an access failure (timeout, the coordinator decides on retry) from a valid empty (`0 results` — a success, not an error); collapsing into "failure" destroys the signal. </details>

**[2.4 MCP server integration](domain-2-tool-design-mcp/2.4-mcp-server-integration.md)** 🆕
🔌 *Corporate Wi-Fi (`.mcp.json` in the repo — everyone gets it on clone) vs home Wi-Fi (`~/.claude.json` — only you).*
🚩 "the token right in `.mcp.json`" → *secret in Git* → `${GITHUB_TOKEN}`; "user-scope is safer" → *wrong scope* → teammates won't get it; "I pick the server manually" → *misconception* → all servers connect simultaneously; "a tool for a data catalog" → *wrong mechanism* → a resource.
🧷 team-wide → `project .mcp.json` + `${VAR}`; personal → `~/.claude.json`; data catalog → resource; action → tool.
<details><summary>Retrieval question</summary> The GitHub MCP is needed by all developers on clone. How to configure it? · **Answer:** `project .mcp.json` with `${GITHUB_TOKEN}` — the project scope is versioned, the token is in an env var, not in the file; the user scope won't reach teammates. </details>

**[2.5 Built-in tools](domain-2-tool-design-mcp/2.5-builtin-tools.md)** 🆕
🔧 *Grep — search for WHAT is inside (content), Glob — search for WHERE (name/path), Edit — a surgeon (a unique anchor), Read+Write — a full replacement.*
🚩 Glob for content search → *wrong tool* → Glob is by file name, not content; retrying Edit on a non-unique anchor → *root-cause-over-symptom* → Read+Write fallback; reading the whole repo → *context bloat*.
🧷 content/pattern → Grep; path/name → Glob; Edit failed (not unique) → Read+Write; explore incrementally: Grep the entry point → Read along the imports.
<details><summary>Retrieval question</summary> You need to find all calls to the `processRefund` function across the whole repository. Which tool? · **Answer:** Grep — content search over file bodies; Glob would find files by name, not by content. </details>

### Node 4 · "Form ≠ meaning" 📋 — structured output & review
> A schema guarantees the **form**, not the **truth**. Build a ladder from criterion to determinism. Match the mechanism to the latency profile (batch vs sync).

**[4.1 Explicit criteria · false positives](domain-4-prompt-engineering/4.1-explicit-criteria-false-positives.md)** 🆕
📐 *A clear dress code ("business = a jacket") vs "look professional" — the latter isn't an operational boundary, the model invents it itself.*
🚩 "add 'be conservative'" → *a vague hedge without an operational definition*; "global strictness reduction" → *wrong lever* → it drags down accurate categories; "leave the high-FP category while we improve it" → *trust erosion* → quarantine it immediately.
🧷 replace "check X" with "flag only when X contradicts Y"; a high-FP category — quarantine (not global tightening); define the boundary with a criterion, then add few-shot.
<details><summary>Retrieval question</summary> The style category has 52% FP, the security category 8% FP. Developers stop looking at all results. What to do first? · **Answer:** Quarantine the style category — it preserves trust in security/bugs; a global strictness reduction would drag down accurate categories. </details>

**[4.2 Few-shot prompting](domain-4-prompt-engineering/4.2-few-shot-prompting.md)** 🆕
🎯 *Show 2–3 examples with reasoning (why A and not the plausible B) — the model learns to judge, not to memorize.*
🚩 "15–20 examples" → *noise, not quality* → 2–4 targeted; "examples without reasoning" → *pattern-match, not generalization*; "few-shot = a guarantee" → *lever confusion* → ~97%, not 100%; the guarantee = tool_choice + schema + validator.
🧷 2–4 targeted examples with reasoning; lever hierarchy: criterion (4.1) → few-shot → code/schema (the guarantee); diversity matters more than quantity.
<details><summary>Retrieval question</summary> The detailed instructions exist, but severity is inconsistent (HIGH/High/critical mixed together). Next step? · **Answer:** 2–4 few-shot examples with reasoning for the ambiguous cases; repeated/expanded prose adds no signal about the expected output. </details>

**[4.3 `tool_use` + JSON schema](domain-4-prompt-engineering/4.3-structured-output-tooluse.md)** 🆕
📋 *A standard form with fields — it guarantees that everything is filled in to format, but not that what's in the fields is true.*
🚩 "strict schema → the data is correct" / "all fields `required` for completeness" → *common-misconception / extreme* → the schema holds only syntax; make absent-able fields nullable, check meaning with downstream validation.
🧷 The form holds form, not truth — make fields nullable, check meaning yourself. `any` = must call at least something; forced = specifically this tool.
<details><summary>Retrieval question</summary> After a strict schema the parse errors disappeared, but `line_items` don't sum to `total`, and `vendor_name` is sometimes = the customer's name. Root cause and fix? · **Answer:** A schema = only syntax/types; semantics are caught by downstream validation (recompute `total`, cross-check fields). More `required` would only intensify fabrication. </details>

**[4.4 Validation & retry](domain-4-prompt-engineering/4.4-validation-retry-loops.md)** 🆕
🔁 *Asking again helps if you misheard; if the number isn't in the document — no matter how many times you ask, it won't appear.*
🚩 "retry to get an absent field" / "a `strict` schema will fix the sums" → *symptom-not-root-cause* → retry with a **specific error** for format/semantic issues; absent data → escalation/external lookup.
🧷 Misheard — ask again with the error; no data — you won't invent it, escalate.
<details><summary>Retrieval question</summary> Schema-valid JSON, but (1) `stated_total` ≠ the sum of the lines and (2) `tax_rate` isn't printed at all. What to do with each? · **Answer:** (1) semantic → retry with the document + the attempt + the specific error; (2) a non-retryable gap in the source → escalation/external lookup. </details>

**[4.5 Batch processing](domain-4-prompt-engineering/4.5-batch-processing.md)** 🆕
🌙 *A night freight truck — cheap and high-volume, but "needed right now" doesn't ship that way.*
🚩 batching a blocking task (a pre-merge gate that people wait on) → *symptom-not-root-cause* (the latency profile is mixed up) → batch only off-critical-path work.
🧷 Waiting now → synchronous; can wait until morning → batch (~50%, ≤24h, no SLA); something failed → resubmit only the failed `custom_id`. *(Batch accepts `tools` definitions and server tools; what's impossible is specifically an interactive client-side tool-loop.)*
<details><summary>Retrieval question</summary> Two CI modes: (1) a `pre-merge` hook blocks the merge, (2) a nightly deep analysis posts advice by morning. What goes into batch? · **Answer:** Only the nightly deep analysis — it's off the critical path; the pre-merge blocks the merge in real time, 24h would stall every merge. </details>

**[4.6 Multi-pass review](domain-4-prompt-engineering/4.6-multipass-review.md)** 🆕
👀 *The author's eye is dulled and reads past typos — a fresh reviewer sees it for the first time; 14 chapters at once you'll edit superficially.*
🚩 "the same session re-checks itself / extended thinking / a bigger window / a finding only if it appears in ≥2 of N runs" → *common-misconception* (window size ≠ attention quality) → an independent instance + per-file + a separate cross-file pass; rare bugs are caught by per-finding confidence, **not voting**.
🧷 A fresh eye instead of self-checking; per chapter + a pass for connections; consensus mutes a rare bug — don't require it.
<details><summary>Retrieval question</summary> Catch subtle intermittent bugs in a 12-file PR. They propose: 3 runs, post only if ≥2 of 3. Take it? · **Answer:** No — a ≥2/3 threshold mutes intermittent bugs (often visible in 1 run) and triples the cost; instead of consensus — per-file + cross-file + per-finding confidence routing. </details>

### Node 5 · "Honesty about errors and the unknown" 🌡️📰 — context & reliability
> Don't discard or average what the layer above needs. Durable facts instead of lossy summaries; dates and sources — carried through synthesis; an average masks a weak segment.

**[5.1 Conversation context](domain-5-context-reliability/5.1-conversation-context.md)** ✅
📋 *Meeting minutes: the key numbers — verbatim in a separate table, not in the retelling; in a long lecture people remember the start and the end, they lose the middle.*
🚩 "compress harder / raise the threshold / tweak the summarizer" for a context problem → *symptom-not-root-cause* → a durable `case-facts` block outside compression + the summary at the start + headings; verbose output → trim.
🧷 Numbers — into a table verbatim; the important stuff — at the start and under a heading; compression for a context problem is a trap: rearrange, don't discard.
<details><summary>Retrieval question</summary> A support agent on progressive summarization quotes the wrong refund amount (the customer said it 30 turns ago, it got collapsed into "discussed a refund"). Fix? · **Answer:** Transactional facts (amounts/dates/order#/statuses) into a durable `case-facts` block in every prompt, outside compression — summarization is lossy. </details>

**[5.4 Large codebase context](domain-5-context-reliability/5.4-large-codebase-context.md)** 🆕
🕵️ *A detective writes notes on a board (scratchpad), sends colleagues out to search (subagents) — doesn't keep the whole archive in their head.*
🚩 "raise `max_tokens` to remember more" → *common-misconception* → `max_tokens` limits OUTPUT, not input memory; "`/compact` = reliable storage" → *misconception* → it's lossy in-session, not disk; "read the whole repo into the main context" → *context rot*.
🧷 context rot → a scratchpad file with key findings; verbose exploration → a subagent (a summary comes back); crash recovery → a manifest on disk; a bloated session → `/compact` (lossy, but it saves).
<details><summary>Retrieval question</summary> After 50 turns the agent starts answering with "typical patterns" instead of the specific classes it found earlier. Fix? · **Answer:** A scratchpad file with key findings — we reference it on later questions; /compact helps with volume, but won't restore the exact data from the lost middle. </details>

**[5.5 Confidence calibration](domain-5-context-reliability/5.5-human-review-calibration.md)** 🆕
🌡️ *Average temperature across the hospital: "36.6 on average" hides the ward where everyone has a fever — measure by ward.*
🚩 "overall accuracy is high, automate everything" → *true-but-irrelevant* → break accuracy down `by document type` and `by field` on a labeled set, reduce review only where it holds.
🧷 Don't trust the average — measure by ward (type × field); disputed and uncertain → to a human.
<details><summary>Retrieval question</summary> Extraction from invoices/contracts/receipts, 95% overall; they want to remove part of the manual review. First step? · **Answer:** Break accuracy down by type and field on a labeled set, reduce review only on the proven-accurate segments — the average hides the failing one (e.g. contracts). </details>

**[5.6 Provenance & uncertainty](domain-5-context-reliability/5.6-provenance-uncertainty.md)** 🆕
📰 *A journalist puts a source on every number; two sources disagree — they cite both with a link, they don't silently pick their favorite.*
🚩 "average it / take the newer one / drop the citations for cleanliness" → *symptom-not-root-cause / fabrication* → annotate both values with `source` and `date`, hand reconciliation to the coordinator.
🧷 A source on every number · a date is mandatory · a conflict — annotate both · each type — in its own format.
<details><summary>Retrieval question</summary> Payload: every claim has `source_url`, `document_name`, `excerpt`; the coordinator is ready to annotate the conflict on churn rate. What gap remains? · **Answer:** No `date` (publication/collection) — without a date the time difference reads as a contradiction; Task 5.6 requires carrying dates through structured output. </details>

> Adjacent here: **[5.2 Escalation](domain-5-context-reliability/5.2-escalation-ambiguity.md)** (✅ learned-rules Topic 5) — "I escalate when I CAN'T (no rule/data), not when I DON'T WANT TO (it's inconvenient)".

### Node 6 · "Configure Claude for the team" ⚙️ — Claude Code Config (D3 · 20%)
> `CLAUDE.md` — context, not enforcement. Scope = the sharing boundary. The right layer + the minimum configuration saves tokens and removes problems at the root.

**[3.1 CLAUDE.md hierarchy](domain-3-claude-code-config/3.1-claudemd-hierarchy.md)** 🆕
📁 *A corporate charter in a shared folder (project CLAUDE.md in Git, everyone gets it) vs a personal diary (`~/.claude/CLAUDE.md` — only you, not shared).*
🚩 team standards at user-level → *wrong scope* → teammates won't get them (it breaks with every new hire); "`@import` saves context" → *misconception* → imported files are loaded at startup anyway; "CLAUDE.md = enforcement" → no, it's context; hard guarantee = a hook.
🧷 scope = who sees it; team-wide → project, in Git; personal → user; diagnostics → `/memory`; a hard guarantee → a hook, not CLAUDE.md.
<details><summary>Retrieval question</summary> A new developer doesn't get the coding standards. The most likely root cause? · **Answer:** The standards are in someone's `~/.claude/CLAUDE.md` (user-level, not in VCS); the fix — move them to `.claude/CLAUDE.md` and commit. </details>

**[3.2 Commands & skills](domain-3-claude-code-config/3.2-slash-commands-skills.md)** 🆕
⚡ *`allowed-tools` — a pass without inspection (auto-approve, not a ban); `disallowed-tools` — a real lock; `context: fork` — an isolated booth for chatty work.*
🚩 a team skill in `~/.claude/commands/` → *wrong scope* → teammates won't get it; "`allowed-tools` forbids the unneeded" → *inversion* → it allows without asking; "skills are always-loaded like CLAUDE.md" → *misconception* → skills are on-demand (only the description in context).
🧷 scope-follows-audience; `allowed-tools` = auto-approve; `disallowed-tools` = a real ban; `context: fork` for verbose outputs; CLAUDE.md for the always-needed.
<details><summary>Retrieval question</summary> A skill for an autonomous deploy must not call `rm`. How to forbid it? · **Answer:** `disallowed-tools` in the SKILL.md frontmatter; `allowed-tools` only auto-approves tools — it doesn't forbid Bash or others. </details>

**[3.3 Path-specific rules](domain-3-claude-code-config/3.3-path-specific-rules.md)** 🆕
🗂️ *An instruction marked "only for `*.test.tsx`" loads itself when you edit a test — no need to remember to enable it, takes no space when not needed.*
🚩 all conventions in the root CLAUDE.md → *token waste* → they load always; a subdirectory CLAUDE.md → *directory-bound* → it doesn't cover cross-cutting types; a rule **without** `paths:` → *loads unconditionally* (not conditionally!).
🧷 a TYPE convention across the whole repo → `.claude/rules/` with a `paths:` glob; a LOCATION convention → a directory CLAUDE.md; no `paths:` = loads always = like a project CLAUDE.md.
<details><summary>Retrieval question</summary> A convention for `**/*.test.tsx` is scattered across the whole repository. The best place? · **Answer:** `.claude/rules/test-conventions.md` with `paths: ["**/*.test.tsx"]` — it loads only when editing test files, doesn't clutter the context permanently. </details>

**[3.4 Plan mode vs direct](domain-3-claude-code-config/3.4-plan-mode-vs-direct.md)** 🆕
🏗️ *An architectural plan before construction (plan mode — reads, doesn't write) vs "attach a socket" (direct). Plan mode changes nothing on disk before approval.*
🚩 "direct, I'll switch to plan if it gets hard" → *mistake* → the complexity is ALREADY in the conditions (dozens of files, service boundaries); "plan mode plan + implement at once" → *misconception* → without exiting plan mode nothing gets written.
🧷 dozens of files / architectural / multiple valid approaches → plan; a one-sentence diff / clear scope → direct; plan reads → plan → exit → implement.
<details><summary>Retrieval question</summary> Monolith → microservices, dozens of files, several valid approaches to the boundaries. Which mode? · **Answer:** Plan mode — architectural + multi-file + multiple valid approaches; starting direct is risky: costly rework on late-discovered dependencies. </details>

**[3.5 Iterative refinement](domain-3-claude-code-config/3.5-iterative-refinement.md)** 🆕
🔁 *Show 2–3 samples of the desired result (a demo) vs describe it in words again (hope) — a demo is more informative than a repeated explanation.*
🚩 "rephrase the prose even more persuasively" → *adds no information about the expected output*; "fix the interacting bugs one at a time" → *fix #2 will break fix #1*; the grouping criterion = interaction, **not one file**.
🧷 prose isn't working → I/O examples (2–3 with an edge case); an unfamiliar domain → the interview pattern (AskUserQuestion) before code; interacting → in one message; independent → one at a time.
<details><summary>Retrieval question</summary> Claude generates code with a drifting style despite detailed instructions. The next effective step? · **Answer:** 2–3 concrete examples of input → expected output (including an edge case); repeated/expanded prose adds no new signal. </details>

**[3.6 CI/CD integration](domain-3-claude-code-config/3.6-ci-cd-integration.md)** 🆕
⚙️ *`-p` = "quiet mode": doesn't wait for input, prints and leaves — exactly what you need in CI.*
🚩 `CLAUDE_HEADLESS=true` / `--batch` → *non-existent phantom flags*; self-review by the same session → *a dulled eye*; a repeat review without prior findings → *duplicated comments*.
🧷 CI → `-p` is mandatory; JSON gate → `--output-format json --json-schema`; review → an independent instance; dedup → prior findings into context (semantic reasoning, not a string filter).
<details><summary>Retrieval question</summary> `claude "analyze this PR"` in a CI script hangs. Root cause and fix? · **Answer:** The `-p` flag is missing; without it Claude waits for interactive input; the fix: `claude -p "analyze this PR"`. </details>

---

## 🚩 Summary detector table (a reflex on the exam)

| If in an answer you see… | This is the trap… | The right move |
|---|---|---|
| "most effective / root cause" + a patch on top (retry/filter/hint) | symptom-not-root-cause | fix the root at the right layer |
| a prompt where a tool/code is needed | the wrong lever | climb the ladder (4–5) |
| "only X can / they can't" + an operational perk (retry/batch/cache) | false dichotomy | the structural plus of the hub |
| "compress / summarize / raise the threshold" for a context problem | symptom-not-root-cause | restructure + durable facts |
| "give all" / "remove entirely" | extreme (over/under) | one precise tool per role |
| "escalate because it's inconvenient/relationships" | emotional avoidance | escalate on a gap in rules/data |
| "strict schema → the data is correct" | common-misconception | a schema = form, not meaning; validate |
| "retry will get the absent field" | symptom-not-root-cause | no data → escalation, not a retry |
| "a bigger window / extended thinking fixes attention" | common-misconception | an independent instance + a per-file pass |
| "overall accuracy is high → automate everything" | true-but-irrelevant | stratify by segment |
| "always / never / only / entirely" | suspicious by form | look for a counterexample |
| a failure percentage in the question (8%, 12%) | a hint | you need code/structure, not a prompt |
| the text "Done" in a response = loop completion | anti-pattern (loop) | `stop_reason == 'end_turn'` — the contract |
| "raise max_tokens to remember" | common-misconception | max_tokens = OUTPUT, not input memory |
| "the team will get user-scope settings" | wrong-scope | user-level isn't in VCS; you need project-level |
| "allowed-tools restricts tools" | inversion | allowed-tools auto-approves; the ban = disallowed-tools |
| `CLAUDE_HEADLESS` / `--batch` as Claude Code flags | fabricated-flag | use `-p` / `--print` |
| "a rules file without `paths:` = conditional loading" | misconception | without paths: it loads unconditionally |

## ⚔️ Paired traps (tell them apart instantly)

`Grep` content ↔ `Glob` paths · `tool_choice` auto (may text) ↔ any/forced · `.claude/commands` project ↔ `~/.claude/commands` user · project CLAUDE.md team ↔ `~/.claude/CLAUDE.md` personal · skills on-demand ↔ CLAUDE.md always-loaded · `.claude/rules` globs ↔ directory CLAUDE.md · a rule with `paths:` conditional ↔ a rule without `paths:` unconditional · `allowed-tools` auto-approve ↔ `disallowed-tools` ban · access failure (retry) ↔ valid empty (success) · syntax (the schema fixes) ↔ semantic (it doesn't fix) · batch latency-tolerant ↔ sync blocking · plan for big ↔ direct for small · gate/hook guarantee ↔ prompt probabilistic · retry for format ↔ useless if the data isn't there · `stop_reason` a contractual signal ↔ text in the response an unreliable proxy · `max_tokens` an output limit ↔ context window an input budget · `/compact` lossy in-session ↔ manifest durable on disk · `fork` branches the conversation ↔ doesn't branch the filesystem.

---

## 📅 Schedule (spacing + interleaving) — 7 runs

Alternate the nodes (not one domain in a row), learn the 🆕 topics through [`deep-teach`](../.claude/skills/deep-teach/SKILL.md), and by the end — "cold" with no hints.

| Day | Learn (🆕) | Reinforce (✅) | Check |
|---|---|---|---|
| 1 | Node 1: 1.1 · Node 4: 4.1 | ladder of levers + 1.4 | retrieval-Q 1.1 and 4.1 yourself |
| 2 | Node 1: 1.5, 1.7 · Node 4: 4.2 | 1.2 (Topic 6) | `quiz-me D1` |
| 3 | Node 2: 1.3, 1.6 · Node 4: 4.3, 4.4 | 5.3 (Topic 1) | `quiz-me D1 D4` |
| 4 | Node 3: 2.2, 2.4, 2.5 · Node 4: 4.5, 4.6 | 2.1, 2.3 (Topic 2) | `quiz-me D2 D4` |
| 5 | Node 6: 3.1, 3.2, 3.3 | 5.1 (Topic 4) | `quiz-me D3` |
| 6 | Node 6: 3.4, 3.5, 3.6 · Node 5: 5.4, 5.5, 5.6 | 5.2 (Topic 5) | `quiz-me D3 D5` |
| 7 | — | all 🚩 detectors + paired traps | **`mock-exam`** |

🔴 missed/guessed → bring the topic back tomorrow · 🟡 right-but-unsure → in 2–3 days · 🟢 confident → in a week. Bring confident-but-wrong back first.

## ✅ Ready when

- [ ] All 28 retrieval questions above are solved **cold**.
- [ ] All 🚩 detectors fire automatically; you tell the paired traps apart without thinking.
- [ ] For any 🆕 topic you can explain it "in simple terms" with an analogy (the Feynman test).
- [ ] **`mock-exam` ≥ 750** under honest conditions.

## 🔁 Interactive

- **"teach me 3.2"** → [`deep-teach`](../.claude/skills/deep-teach/SKILL.md) (theory simply → your mistakes → 🚩 cheat-sheet → question).
- **`quiz-me D3 6`** → a quick drill with a breakdown. · **"study with me"** → `exam-tutor`. · **"am I ready?"** → `mock-exam`.
- **"what to learn next"** → `progress-tracker` (what to review + re-read the block in `learned-rules.md`).
