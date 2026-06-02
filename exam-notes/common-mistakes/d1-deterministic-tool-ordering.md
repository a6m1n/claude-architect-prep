# Deterministic tool ordering — enforce prerequisites in code, not prompts

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.4 (programmatic prerequisites blocking downstream tool calls)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Deterministic tool ordering — programmatic prerequisites/guardrails
> **Trap level:** 🟡 Medium — "make the system prompt require verification" sounds like a direct fix
> **Trap archetype:** Determinism vs. probabilistic prompting
> **Source:** Claude Certified Architect practice exam, Q51 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
When a tool sequence is safety-critical — verify the customer *before* you touch orders or issue refunds — correctness cannot rely on the model choosing the right order every time. An LLM is probabilistic: even a strong instruction is followed *most* of the time, and "most" is not "always." The reliable architecture moves the ordering constraint out of the prompt and into deterministic code that intercepts each tool call and rejects it when its prerequisites are unmet. This is the difference between *steering* the model (prompts, examples) and *constraining* the system (guardrails the model cannot bypass). For irreversible or high-blast-radius actions, design the constraint so that no model output can violate it.

## 2. Question
> Production data shows that in 12% of cases, your agent skips `get_customer` entirely and calls `lookup_order` using only the customer's stated name, occasionally leading to misidentified accounts and incorrect refunds. What change would most effectively address this reliability issue?

## 3. Answer options
- **A.** Implement a routing classifier that analyzes each request and enables only the subset of tools appropriate for that request type.
- **B.** Enhance the system prompt to state that customer verification via `get_customer` is mandatory before any order operations. — ⚠️ **Most common wrong answer**
- **C.** Add a programmatic prerequisite that blocks `lookup_order` and `process_refund` calls until `get_customer` has returned a verified customer ID. — ✅ **Correct**
- **D.** Add few-shot examples showing the agent always calling `get_customer` first, even when customers volunteer order details.

## 4. Correct answer — C
**Add a programmatic prerequisite that blocks `lookup_order` and `process_refund` calls until `get_customer` has returned a verified customer ID.**

Adding a programmatic prerequisite that blocks downstream tools until `get_customer` returns a verified customer ID provides a deterministic guarantee that the required sequence is followed. This is the most effective approach because it removes the possibility of the agent skipping verification, regardless of LLM behavior. Generalizing: when an ordering invariant must hold 100% of the time, implement it as a guard in the tool-execution layer (validate inputs, check that the dependency has been satisfied, and return an error result that forces the model to call the prerequisite first). Code enforces; prompts merely encourage.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "make the system prompt require verification before any order operations."** It is seductive because it directly names the exact rule that's being violated, so it reads like a precise, on-target fix: just tell the agent that `get_customer` is mandatory. The tell that it's wrong: the question already reports a *measured 12% skip rate*, which is itself evidence that the model does not always obey instructions — a stronger instruction still leaves a residual nonzero failure rate. Anyone reasoning "the rule isn't being followed, so state the rule more forcefully" lands on B. The correct move is structural — a programmatic guard in the execution layer that rejects the call until the prerequisite is satisfied — because for invariants that must hold 100% of the time, determinism beats probabilistic prompting.

## 6. Distractor analysis — look-alikes to watch for
- **A.** A routing classifier scopes *which* tools are available for a request type, but it does not enforce the *order* among the enabled tools — `lookup_order` could still run before `get_customer`.
- **B.** Tempting because it directly names the rule, but a system-prompt instruction is probabilistic; the 12% skip rate is exactly the failure mode that prompt-only enforcement produces.
- **C.** Correct — the only option that makes the prerequisite a hard, deterministic guarantee independent of model behavior.
- **D.** Few-shot examples raise the likelihood of the right sequence but still leave a residual failure rate; they cannot guarantee the invariant for unseen inputs.

## 7. Key takeaways
- For safety-critical or irreversible actions, enforce tool ordering with a programmatic guard that rejects calls until prerequisites are met — a deterministic guarantee, not a nudge.
- Prompt instructions and few-shot examples are probabilistic; a measured nonzero failure rate (here 12%) is evidence that prompt-only enforcement is insufficient.
- A routing classifier controls *availability* of tools, not their *sequence* — different lever, different problem.
- Push hard invariants down to the execution layer; reserve prompts for guidance where occasional deviation is acceptable.

## 8. Official documentation
- [Strict tool use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/strict-tool-use)
- [How tool use works](https://platform.claude.com/docs/en/agents-and-tools/tool-use/how-tool-use-works)
- [Define tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools)
