# quiz-me reference

Long-form material for the [quiz-me](SKILL.md) skill: the distractor-archetype catalog and a bank of sample generated questions. Pull only the section you need when authoring a question.

## Table of contents

- [Distractor archetype catalog](#distractor-archetype-catalog)
- [Authoring checklist per question](#authoring-checklist-per-question)
- [Recall-quality grading scale](#recall-quality-grading-scale)
- [Sample generated questions by domain](#sample-generated-questions-by-domain)
  - [D1 — Agentic Architecture & Orchestration](#d1--agentic-architecture--orchestration)
  - [D2 — Tool Design & MCP Integration](#d2--tool-design--mcp-integration)
  - [D3 — Claude Code Configuration & Workflows](#d3--claude-code-configuration--workflows)
  - [D4 — Prompt Engineering & Structured Output](#d4--prompt-engineering--structured-output)
  - [D5 — Context Management & Reliability](#d5--context-management--reliability)

---

## Distractor archetype catalog

Use **3 distinct archetypes** per question. Each distractor must be plausible to a non-master but defensibly wrong; keep all 4 options the same length/grammatical form and avoid absolutes ("always"/"never").

| Archetype | What it is | How to build it | How to detect it (use in grading) |
|---|---|---|---|
| **common-misconception** | A widely believed but false claim about the concept. | Take the most frequent learner error from the source note's *Distractor analysis* / *Common mistake* (§5–§6) and phrase it confidently. | "Sounds like the rule of thumb everyone repeats, but the docs say the opposite / add a condition." |
| **right-idea-wrong-scope** | The correct mechanism applied at the wrong level/boundary. | Swap project ⇄ user ⇄ local scope, single-agent ⇄ multi-agent, repo ⇄ machine, tool ⇄ subagent. | "Right tool, wrong altitude — it solves a different boundary than the scenario asks for." |
| **true-but-irrelevant** | A factually correct statement that doesn't answer THIS question. | State a real fact about an adjacent feature that the scenario never requires. | "Everything in it is true, but none of it addresses the constraint in the stem." |
| **over-engineered** | A heavier solution than the problem needs. | Add multi-agent orchestration, extra tools, caching, batching, or pipelines where a simple primitive suffices. | "Correct in spirit but adds cost/latency/complexity the scenario doesn't justify." |
| **under-engineered** | Too simple; ignores a stated requirement. | Drop a constraint from the stem (no error handling, no scope sharing, no schema, no review). | "Misses a hard requirement explicitly stated in the scenario." |
| **symptom-not-root-cause** | Treats the surface symptom instead of the actual cause. | Offer a patch for the observed failure (retry, bigger context) while the root cause (bad tool description, missing schema) is untouched. | "Suppresses the symptom but leaves the real cause in place, so it recurs." |

Pairing tips:
- For **config-scope** questions (D2/D3): pair *right-idea-wrong-scope* + *under-engineered* + *true-but-irrelevant*.
- For **reliability/cost** questions (D5): pair *over-engineered* + *symptom-not-root-cause* + *common-misconception*.
- For **prompt/structured-output** questions (D4): pair *common-misconception* + *under-engineered* + *true-but-irrelevant*.
- For **architecture** questions (D1): pair *over-engineered* + *under-engineered* + *right-idea-wrong-scope*.

---

## Authoring checklist per question

1. One concept, drawn from a specific source note + `exam-notes/00-EXAM-GUIDE.md`.
2. Fresh scenario (new company/data/constraints) — not a verbatim parsed question.
3. Exactly 4 options: 1 key + 3 distinct-archetype distractors.
4. Options uniform in length/form; no "always/never"; only one defensibly-correct option.
5. Hold the answer/rationale until the user responds.
6. Grade names the chosen distractor's archetype + why it fails *here* + why the key is right + ≥1 official URL.
7. Record via [[progress-tracker]] (concept, result, recall-quality 0–5).

---

## Recall-quality grading scale

Pass to [[progress-tracker]] alongside correct/incorrect so spacing can be scheduled. (Rationale — why `q < 3` flags failure and resets the SM-2 interval, and how the scale supports metacognitive calibration — is in [[teaching-method]] §6.)

- **5** — correct, fast, confident, could explain why.
- **4** — correct with minor hesitation.
- **3** — correct but unsure / guessed between two.
- **2** — incorrect but close (chose a near-miss distractor like right-idea-wrong-scope).
- **1** — incorrect, chose a common-misconception trap.
- **0** — incorrect, no idea / chose a true-but-irrelevant or wildly off option.

Re-queue anything graded ≤ 2 in the batch summary.

---

## Sample generated questions by domain

These are MODELS for the form and difficulty, not a fixed bank — generate fresh scenarios each run. Each shows the key, the three archetypes used, and a grading citation.

### D1 — Agentic Architecture & Orchestration

**Sample Q.** A research team builds an agent that must read 40 long PDFs, extract findings, and write one synthesis. A junior proposes spawning one subagent per PDF that all write to a shared running draft simultaneously. What is the better architecture?
- A. Use an orchestrator that fans out read-only extraction subagents, each returning a structured summary, then a single writer synthesizes from those summaries. **(KEY)**
- B. Have every subagent edit the shared draft concurrently so the synthesis stays continuously up to date. *(under-engineered — no coordination; concurrent writers corrupt the draft)*
- C. Run one monolithic agent that loads all 40 PDFs into a single context and writes in one pass. *(common-misconception — "one big context is simpler"; blows context limits / loses fidelity)*
- D. Add a separate evaluator agent and a planner agent above the orchestrator before any extraction begins. *(over-engineered — extra agents the task does not need)*
- Cite: https://www.anthropic.com/engineering/building-effective-agents · https://code.claude.com/docs/en/sub-agents

### D2 — Tool Design & MCP Integration

**Sample Q.** An agent keeps calling a `search_orders` tool with the wrong date format and failing. Logs show the tool's description is one line: "Searches orders." What is the most effective fix?
- A. Rewrite the tool description and input schema to specify the expected date format, units, and an example call. **(KEY)**
- B. Wrap the tool in a retry loop that re-invokes it up to five times on failure. *(symptom-not-root-cause — hides failures, never fixes the unclear contract)*
- C. Note that MCP tools can return both text and image content blocks to the model. *(true-but-irrelevant — correct fact, unrelated to the format bug)*
- D. Replace the tool with a dedicated subagent that owns all order operations. *(over-engineered — a clearer description, not a new agent, is what's needed)*
- Cite: https://www.anthropic.com/engineering/writing-tools-for-agents · https://platform.claude.com/docs/en/build-with-claude/tool-use/implement-tool-use

### D3 — Claude Code Configuration & Workflows

**Sample Q.** A team wants the same build/test commands and coding conventions to apply to everyone who clones the `api` repo, reviewed in PRs. Where should this go?
- A. A checked-in `CLAUDE.md` at the repo root committed to version control. **(KEY)**
- B. Each developer's user-level memory file so it follows them across all projects. *(right-idea-wrong-scope — applies per machine/all projects, not shared via this repo)*
- C. A `.claude/settings.local.json` entry, since local settings load automatically. *(under-engineered — local/untracked, invisible to teammates and PRs)*
- D. A custom slash command that prints the conventions when invoked. *(true-but-irrelevant — possible but doesn't make conventions apply by default)*
- Cite: https://code.claude.com/docs/en/memory · https://code.claude.com/docs/en/settings

### D4 — Prompt Engineering & Structured Output

**Sample Q.** A pipeline must extract `{name, email, amount}` from invoices and the downstream system rejects anything that isn't valid JSON. The current prompt just says "return the data as JSON." What's the most reliable upgrade?
- A. Use the tool-use / structured-outputs mechanism with a defined JSON schema so the model's output conforms to the contract. **(KEY)**
- B. Append "Respond ONLY in valid JSON, never add prose" in capital letters to the prompt. *(common-misconception — emphatic instructions don't guarantee schema-valid output)*
- C. Add three full example invoices and outputs to make the prompt multishot. *(under-engineered for the guarantee — helps quality but still no enforced schema)*
- D. Note that longer context windows let you process bigger invoices in one call. *(true-but-irrelevant — about context size, not output validity)*
- Cite: https://platform.claude.com/docs/en/build-with-claude/structured-outputs · https://platform.claude.com/docs/en/build-with-claude/tool-use/implement-tool-use

### D5 — Context Management & Reliability

**Sample Q.** A long-running Claude Code session is slowing down and nearing the context limit after a big refactor, but the user wants to keep working in the same thread. What is the right move?
- A. Use `/compact` to summarize and compress the conversation so work continues with reclaimed context. **(KEY)**
- B. Start increasing `max_tokens` on each request to push more through. *(common-misconception — output budget, unrelated to input context pressure)*
- C. Enable prompt caching so the system prompt is cached across calls. *(true-but-irrelevant — saves cost on repeated prefixes, doesn't free a full context window)*
- D. Move the whole task to the Message Batches API to run it asynchronously. *(over-engineered / wrong-scope — batch is for bulk async jobs, not an interactive session)*
- Cite: https://code.claude.com/docs/en/costs · https://platform.claude.com/docs/en/build-with-claude/context-windows
