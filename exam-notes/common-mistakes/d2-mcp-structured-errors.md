# Structured error metadata enables correct agent recovery

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.2 (structured error responses for MCP tools)
> **Scenario:** Customer Support Resolution Agent · **Study area:** MCP structured error responses (`isError`, `errorCategory`, `isRetryable`)
> **Trap level:** 🔴 High — "log-and-return-empty" looks like graceful degradation but silently corrupts the agent's state
> **Trap archetype:** Structured error vs. opaque string
> **Source:** Concept note grounded in the official exam guide, Task 2.2.

## 1. Topic — what this really tests
An MCP tool signals failure to the agent with the `isError` flag, but the flag alone is not enough. A generic `"Operation failed"` payload hides *which kind* of failure occurred, so the agent cannot pick a recovery path. Structured metadata — an `errorCategory` (transient / validation / business / permission), an `isRetryable` boolean, and a human-readable description — turns the failure into a machine-actionable signal. A subtle case the exam probes: a tool returning empty on error conflates an *access failure* (which may warrant a retry decision) with a *valid empty result* (a successful query with no matches).

## 2. Question
> A Customer Support Resolution Agent calls custom MCP tools (`process_refund`, `lookup_order`, `get_customer`). Every tool returns the same response on any failure: `isError: true` with the message `"Operation failed"`. In production the agent retries refund requests that were denied for policy reasons (non-retryable business violations) and prematurely gives up on `lookup_order` calls that timed out (transient, retryable). What is the best fix to the tool contract?
>
> - **A.** Have each tool return structured error metadata — `errorCategory` (transient/validation/business/permission), an `isRetryable` boolean, and a human-readable description — so the agent can choose the correct recovery path.
> - **B.** Wrap every tool call in a blanket retry of up to 3 attempts before surfacing the error to the agent.
> - **C.** On any `isError`, immediately escalate to a human agent.
> - **D.** On any failure, log the error internally and return an empty result so the agent can continue.

## 3. Answer options
- **A.** Structured error metadata (`errorCategory` + `isRetryable` + description) — ✅ **Correct**
- **B.** Blanket retry up to 3 times
- **C.** Always escalate to a human on `isError`
- **D.** Log-and-return-empty on failure — ⚠️ **Most common wrong answer**

## 4. Correct answer — A
The fix is **typed, machine-actionable errors**, not a single recovery heuristic applied uniformly. With `errorCategory` and `isRetryable`, the agent retries only transient failures (timeouts, service-unavailable), surfaces validation errors for input correction, and presents business/permission failures with a customer-friendly explanation instead of wasting retry attempts. The principle: a tool must **never collapse distinct failure modes into one response** — the agent's recovery decision is only as good as the metadata it receives.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — "log the error internally and return an empty result so the agent can continue."** It is seductive because it reads like graceful degradation: nothing crashes, the agent keeps moving, and the failure is at least recorded somewhere. The tell that it's wrong: an empty result is indistinguishable from a *successful query with no matches*, so the agent reads "no matches found" and proceeds on false data — it never retries the timeout or escalates the access failure. The correct move is to make the failure explicit and typed (`errorCategory` + `isRetryable`) rather than swallowing it behind a valid-looking empty payload. This is the structured-error-vs-opaque-string trap in its purest form: converting an error into a silent, ambiguous signal feels safe but destroys the information the agent needs to recover.

## 6. Distractor analysis — look-alikes to watch for
- **B (blanket retry 3×):** applies a transient-error strategy to *every* category. It wastes attempts on non-retryable business/permission/validation errors and still loses the category information the agent needs downstream.
- **C (always escalate):** destroys the 80%+ first-contact-resolution goal; transient timeouts and fixable validation errors should be handled locally, not handed to a human.
- **D (log-and-return-empty):** the trap option — returning empty on error **conflates an access failure with a valid empty result**. The agent reads "no matches found" and proceeds on false data instead of retrying or escalating.

## 7. Key takeaways
- `isError` says *that* it failed; `errorCategory` + `isRetryable` + a human-readable description say *what kind* and *what to do next*.
- Four failure modes to distinguish: **transient** (retryable), **validation** (fix input), **business** (`retriable: false` + customer-friendly reason), **permission** (non-retryable, needs auth/escalation).
- Business-rule violations carry `isRetryable: false` so the agent never burns retries on a denied refund.
- Subagents should attempt **local recovery for transient failures** and propagate to the coordinator only what cannot be resolved locally — with partial results and what was attempted.
- Never collapse distinct failures into `"Operation failed"`, and never return empty-on-error (that hides access failure as a valid empty result).

## 8. Official documentation
- Handle tool calls — errors with `is_error`: https://platform.claude.com/docs/en/agents-and-tools/tool-use/handle-tool-calls
- Tool use overview: https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview
- Writing effective tools for agents (instructive, actionable error responses): https://www.anthropic.com/engineering/writing-tools-for-agents
