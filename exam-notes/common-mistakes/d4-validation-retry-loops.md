# Retry with specific error feedback — and knowing when retry can't help

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.4 (validation, retry, feedback loops)
> **Scenario:** Structured Data Extraction · **Study area:** Validation/retry/feedback loops (`detected_pattern`, semantic vs syntax)
> **Trap level:** 🔴 High — the strongest distractor retries correctly yet fails on recoverability
> **Trap archetype:** Targeted-feedback retry vs. blind retry
> **Source:** Concept note grounded in the official exam guide, Task 4.4.

## 1. Topic — what this really tests

When a structured extraction fails validation, the productive retry is not a blind re-roll: you send the model the *original document*, the *failed extraction*, and the *specific validation errors*, so it can self-correct toward the right output. This works for format mismatches, structural output errors, and semantic errors (values that don't sum, a value placed in the wrong field). It does **not** work when the required information is simply *absent* from the source — no amount of retrying conjures data that was never provided. Note also that schema *syntax* errors are largely eliminated by tool use, so the interesting failures left to handle are semantic ones.

## 2. Question

> An extraction agent parses invoices into a tool-use schema. For one invoice, the returned object is schema-valid but `stated_total` does not equal the sum of line items, and the tax rate the schema requires was never printed on the invoice. The pipeline ran semantic validation and flagged both issues. What is the best next step?
>
> - **A.** Retry the call, appending the original invoice, the failed extraction, and the specific validation errors; accept that the missing tax rate cannot be recovered and surface it for human input.
> - **B.** Retry the same prompt up to 5 times unchanged; one attempt will eventually produce a consistent total and a valid tax rate.
> - **C.** Retry with the original invoice and errors, expecting the retry to also fill in the missing tax rate from the document.
> - **D.** Tighten the JSON schema and rely on tool use to fix the total mismatch and recover the tax rate.

## 3. Answer options

- **A.** Retry with original doc + failed extraction + specific errors; treat absent tax rate as non-retryable, escalate it. ✅ **Correct**
- **B.** Blindly retry 5× with an unchanged prompt.
- **C.** Retry expecting the model to recover information absent from the source. — ⚠️ **Most common wrong answer**
- **D.** Fix it with a stricter schema / tool use.

## 4. Correct answer — A

Targeted error feedback is what makes a retry effective: re-sending the source, the failed output, and the *exact* validation errors lets the model correct format, structural, and semantic mistakes — here, the `stated_total` vs line-item discrepancy. But retries are only effective when the information exists to be corrected. The tax rate is *absent from the source*, a fundamentally different failure: it is not retryable and must be routed to human input or an external lookup, not looped on.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **C — "retry with the doc and errors, expecting the model to also fill in the missing tax rate."** It is seductive because it gets the *mechanism* exactly right: it appends the original invoice plus the specific validation errors, which is precisely the targeted-feedback retry that works for the total mismatch. The tell that it's wrong is the recoverability dimension: the tax rate was never printed on the source, so it is absent information, not a format/structural/semantic error — and a retry, however well-fed, cannot invent data the document never contained. The correct move separates the two failures: retry the recoverable semantic error, but route the absent field to human input or an external lookup. The archetype is targeted-feedback retry vs. blind retry — but with the sharper lesson that even a correctly-fed retry is the wrong tool when there is nothing in the source to correct toward.

## 6. Distractor analysis — look-alikes to watch for

- **B —** Unchanged blind retries add cost and latency without new guidance; without appended errors the model has no reason to converge. Repetition is not feedback.
- **C —** The seductive trap: it *does* retry correctly (doc + errors) but assumes a retry can recover the missing tax rate. Absent information is not a format/structural/semantic error — retrying cannot invent it.
- **D —** Tool use / a stricter schema only eliminates *syntax* errors. It does nothing for a semantic mismatch (a wrong-but-well-typed total) and cannot supply data the document never contained.

## 7. Key takeaways

- Effective retry = original document + failed extraction + **specific** validation errors appended to the prompt for self-correction.
- Retries fix format, structural, and semantic errors; they cannot recover information **absent** from the source — escalate or fetch externally instead.
- Tool use removes schema *syntax* errors; **semantic** validation (values don't sum, wrong field placement) is what the loop must still catch.
- Design self-correcting flows: extract `calculated_total` alongside `stated_total` and flag the discrepancy; add a `conflict_detected` boolean for inconsistent source data.
- Track a `detected_pattern` field on findings so you can analyze which constructs trigger false positives when developers dismiss them.

## 8. Official documentation

- Tool use overview (strict tool use eliminates schema-syntax errors): https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview
- Prompt engineering overview (iterating on prompts against success criteria): https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
