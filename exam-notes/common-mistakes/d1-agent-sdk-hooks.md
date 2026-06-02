# Hooks give deterministic guarantees a prompt can't

> **Domain:** D1 · Agentic Architecture & Orchestration (27%) — Task 1.5 (hooks for interception & normalization)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Agent SDK hooks (`PostToolUse`, tool-call interception)
> **Trap level:** 🔴 High — every distractor is a real compliance-shaping lever, so only the deterministic one truly guarantees
> **Trap archetype:** Deterministic hook vs. prompt instruction
> **Source:** Concept note grounded in the official exam guide, Task 1.5.

## 1. Topic — what this really tests

Whether you reach for the right enforcement mechanism when a business rule must *never* be broken. A prompt instruction (system prompt, few-shot example, lower temperature) only shifts the model toward compliance — it is **probabilistic** and can be ignored under adversarial or edge-case input. A `PreToolUse` tool-call interception hook runs **deterministic code** outside the model: it inspects the outgoing tool arguments and can hard-`deny` the call or redirect to an alternative workflow. The companion pattern, `PostToolUse`, intercepts tool *results* to normalize heterogeneous formats (Unix timestamps, ISO 8601, numeric status codes) before the model ever processes them. Rule of thumb: guaranteed compliance → code/hook; soft guidance → prompt.

## 2. Question

> A Customer Support Resolution Agent uses a custom MCP tool `process_refund`. Company policy states that a refund over **$500** must **never** be issued by the agent — it must instead be routed to human escalation. The agent must be architected so this cap *cannot* be violated, even on unusual inputs. Which approach guarantees compliance?
>
> - **A.** Add a strongly worded rule to the system prompt: "Never issue a refund above $500; escalate to a human instead."
> - **B.** Register a `PreToolUse` hook on `process_refund` that inspects the refund amount, returns `permissionDecision: "deny"` when it exceeds $500, and redirects to the escalation workflow.
> - **C.** Provide a few-shot example in the prompt showing the agent declining a $600 refund and escalating.
> - **D.** Lower the model's temperature so it follows the refund policy more reliably.

## 3. Answer options

- **A.** Strengthen the system prompt with an explicit rule. — ⚠️ **Most common wrong answer**
- **B.** `PreToolUse` interception hook that blocks > $500 and redirects to escalation. ✅ **Correct**
- **C.** Add a few-shot example of declining and escalating.
- **D.** Lower temperature to improve policy adherence.

## 4. Correct answer — B

A hard business rule ("never") demands a **deterministic** guarantee, and only code outside the model loop can provide one. A `PreToolUse` hook intercepts the *outgoing* tool call, evaluates the `tool_input` (the refund amount) in plain code, and returns `permissionDecision: "deny"` to block any call over $500 — `deny` always wins over other hooks/permissions. `permissionDecisionReason` tells the model why so it doesn't retry, and the path can be redirected to the human-escalation workflow. This is the deterministic-prerequisite theme: when violation is unacceptable, enforce in code, not in the prompt.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **A — "add a strongly worded 'never issue a refund above $500' rule to the system prompt."** It is seductive because the instruction states the policy directly, in plain language, exactly where the model reads its operating rules — so it *feels* like the rule is now enforced. The tell that exposes it: a system prompt only shapes the model's *probability* of complying, and probabilistic guidance can be overridden by jailbreaks, ambiguous phrasing, or long contexts, so a $600 refund can still slip through. A "must never" requirement is a guarantee, not a preference, and only deterministic code outside the model loop — a `PreToolUse` hook that hard-`deny`s the call — can deliver it. This is the deterministic-hook-vs-prompt-instruction trap: when violation is unacceptable, enforce in code, not in the prompt.

## 6. Distractor analysis — look-alikes to watch for

- **A — Strong system prompt.** Tempting because it directly states the policy, but instructions are probabilistic guidance: the model *usually* complies, yet can be overridden by jailbreaks, ambiguous phrasing, or long contexts. No guarantee.
- **C — Few-shot example.** Same failure mode as A — it nudges the distribution toward escalation but enforces nothing. One example does not cover every >$500 case.
- **D — Lower temperature.** A common trap: lower temperature reduces randomness but does not encode the $500 rule at all. A confidently-wrong refund is still issued. Tuning sampling is not a compliance control.
- **B — `PreToolUse` hook.** Correct: deterministic code gate on the tool call itself, independent of model behavior.

## 7. Key takeaways

- **Never-violate rules → hooks (code), not prompts.** Prompts are probabilistic; hooks are deterministic.
- **`PreToolUse`** intercepts *outgoing* tool calls: inspect `tool_input`, return `permissionDecision: "deny"` to block, set `permissionDecisionReason`, and redirect to an alternative workflow (e.g., human escalation). `deny` takes priority over all other decisions.
- **`PostToolUse`** intercepts *tool results* to normalize heterogeneous formats (Unix timestamps, ISO 8601, numeric status codes) from different MCP tools before the model sees them — use `updatedToolOutput` to replace the output.
- Prompt levers (system-prompt rules, few-shot examples, temperature) shape likelihood, not guarantees — never the right answer for "must never."
- MCP tool names match hook matchers as `mcp__<server>__<action>`, so you can scope interception to specific tools like `process_refund`.

## 8. Official documentation

- Agent SDK — Intercept and control agent behavior with hooks: https://code.claude.com/docs/en/agent-sdk/hooks
- Agent SDK overview (Hooks capability tab): https://code.claude.com/docs/en/agent-sdk/overview
- Claude Code hooks reference (events, JSON I/O, matcher patterns): https://code.claude.com/docs/en/hooks
