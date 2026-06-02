# `tool_use` + JSON schema for guaranteed structure; nullable fields to stop fabrication

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.3 (structured output via tool use & JSON schemas)
> **Scenario:** Structured Data Extraction · **Study area:** Structured output via `tool_use` + JSON schema; `tool_choice`
> **Trap level:** 🔴 High — three "make the JSON reliable" fixes all sound systematic, but only one enforces the contract
> **Trap archetype:** Schema-enforced tool_use vs. prompt-and-parse
> **Source:** Concept note grounded in the official exam guide, Task 4.3.

## 1. Topic — what this really tests

Defining an extraction tool whose `input_schema` is a JSON schema, then reading the structured data off the `tool_use` block, is the most reliable way to get schema-compliant output. It eliminates JSON *syntax* errors (unclosed braces, trailing commas) that plague "ask for JSON in the prompt and parse the string" approaches. It does **not** prevent *semantic* errors — line items that don't sum to a total, or values placed in the wrong field — so validation still matters. `tool_choice` controls whether a tool is called at all: `"auto"` lets the model reply with text instead; `"any"` forces *some* tool; forced (`{"type": "tool", "name": ...}`) forces a *specific* one. Making fields optional/nullable stops the model from inventing values just to satisfy a `required` constraint.

## 2. Question

> An extraction pipeline feeds vendor invoices to Claude and asks, in the prompt, for "a JSON object with `vendor`, `total`, and `tax_id`." Two problems recur: (1) roughly 1 in 20 responses fails to parse because the JSON is malformed, breaking the downstream regex parser; and (2) when an invoice has no tax ID, the model fabricates a plausible-looking value rather than leaving it out. Which change best fixes **both** problems?
>
> - **A.** Append "Respond ONLY with valid JSON, no prose" to the system prompt and harden the regex.
> - **B.** Define an `extract_invoice` tool whose `input_schema` declares `vendor`, `total`, and a **nullable/optional** `tax_id`; invoke it with `tool_choice` forcing that tool, and read the data from the `tool_use` block.
> - **C.** Lower `temperature` to 0 so the model produces deterministic, well-formed JSON every time.
> - **D.** Keep prompting for JSON but add a retry loop that re-prompts whenever `json.loads()` raises.

## 3. Answer options

- **A.** Stronger prompt instruction + hardened regex parsing.
- **B.** `extract_invoice` tool with JSON `input_schema`, nullable `tax_id`, forced `tool_choice`, read from `tool_use`. — ✅ **Correct**
- **C.** Set `temperature: 0`.
- **D.** Prompt-for-JSON plus a parse-and-retry loop. — ⚠️ **Most common wrong answer**

## 4. Correct answer — B

Routing extraction through a tool with a JSON `input_schema` makes the API emit a structured `tool_use` block, so there is no free-text JSON string to mis-format — the syntax-error class disappears. Forcing the tool (`{"type": "tool", "name": "extract_invoice"}`) guarantees the extraction runs (and runs *before* any enrichment step); `tool_choice: "auto"` would let the model answer in prose instead. If several candidate schemas existed for an unknown document type, `"any"` would guarantee *a* tool is called while letting the model pick. Declaring `tax_id` as optional/nullable removes the pressure to fabricate a value to satisfy a `required` field — the model can legitimately return `null`. Note the schema still won't catch **semantic** errors (e.g., a `total` that doesn't match the line items), so downstream validation remains necessary.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **D — "keep prompting for JSON but add a retry loop whenever `json.loads()` raises."** It is seductive because it looks like a systematic engineering fix rather than a mere nudge: it acknowledges the parse failures and builds an automated recovery path around them, so it feels more robust than just hardening a prompt. The tell that it's wrong: a retry loop only re-rolls the same probabilistic prompt-and-parse path — it adds latency and cost, never guarantees convergence, and does nothing about the fabricated `tax_id`, which is a separate problem the loop can't see. The correct move replaces the fragile string contract entirely: a tool with a JSON `input_schema` makes the API emit structured output so the syntax-error class disappears, and a nullable field removes the pressure to invent values. The trap is treating reliability as something you bolt on around prompt-and-parse, when the design rule is to switch to schema-enforced `tool_use` so the contract is guaranteed at the source.

## 6. Distractor analysis — look-alikes to watch for

- **A.** "Respond only in valid JSON" is a nudge, not a guarantee — the model can still emit malformed JSON, and string-then-regex parsing is exactly the fragile path `tool_use` replaces. Also does nothing about fabrication.
- **C.** `temperature: 0` reduces variance but does not enforce grammar; malformed JSON still occurs and a deterministic model with a `required` field will deterministically fabricate the missing tax ID.
- **D.** A retry loop is a band-aid: it adds latency/cost, never guarantees convergence, and leaves the fabrication problem untouched.

## 7. Key takeaways

- Use a tool with a JSON `input_schema` and read the `tool_use` block — kills JSON *syntax* errors; it does **not** catch *semantic* errors, so still validate.
- `tool_choice`: `"auto"` (may reply in text), `"any"` (must call some tool — use when the schema/doc type is unknown), forced `{"type":"tool","name":...}` (must call a specific tool — use to guarantee an extraction runs before enrichment).
- Make absent-able fields **optional/nullable** so the model returns `null` instead of fabricating values to satisfy `required`.
- For extensible categories use enums with an `"other"` value plus a free-text detail field, and add `"unclear"` for ambiguous cases; pair strict schemas with format-normalization rules in the prompt.

## 8. Official documentation

- Tool use overview: https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview
- Define tools (JSON `input_schema`, forcing tool use / `tool_choice`): https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools
