# Tool Selection Reliability — system-prompt keyword steering vs. tool descriptions

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.1 (tool interfaces: keyword-sensitive prompt wording creates unintended tool associations)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Tool Selection Reliability
> **Trap level:** 🔴 High — every distractor names a real, legitimate technique aimed at the wrong layer
> **Trap archetype:** Diagnose the right layer
> **Source:** Claude Certified Architect practice exam, Q59 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
Tool selection in an agent is driven by the full context the model sees — not just the tool schemas, but the system prompt, examples, and any routing instructions layered above them. When a behavior correlates tightly with a *surface lexical feature* (the presence of one keyword), and you have already ruled out the tool layer, the cause almost always lives in an upstream instruction that the model is faithfully obeying. The core architect skill is **layer diagnosis**: before "fixing" tools, identify which layer (base model, tool descriptions, or system prompt) actually produces the observed pattern. Misdiagnosing the layer leads to changes that cannot work because they target the wrong component.

## 2. Question
> Production logs reveal a consistent pattern: when customers include "account" in messages (e.g., "I want to check my account for the order I placed yesterday"), the agent calls `get_customer` first 78% of the time. When customers phrase similar requests without "account" (e.g., "I want to check on the order I placed yesterday"), it calls `lookup_order` first 93% of the time. The tool descriptions are well-written and unambiguous. What is the most likely root cause of this discrepancy?

## 3. Answer options
- **A.** The model requires more training data on multi-concept messages and should be fine-tuned on examples that include both account and order language.
- **B.** The model's base training creates associations between "account" terminology and customer-related operations that override the tool descriptions.
- **C.** The system prompt contains keyword-sensitive instructions that steer behavior based on terms like "account," creating unintended tool selection patterns. — ✅ **Correct**
- **D.** The tool descriptions need additional negative examples specifying when NOT to use each tool to prevent this keyword-triggered confusion. — ⚠️ **Most common wrong answer**

## 4. Correct answer — C
**The system prompt contains keyword-sensitive instructions that steer behavior based on terms like "account," creating unintended tool selection patterns.**

The official explanation: this is the most likely root cause because the systematic, keyword-triggered pattern (78% vs 93%) strongly suggests explicit routing logic in the system prompt that reacts to the word "account" and directs the agent toward customer-related tools. Since the tool descriptions are already well-written and unambiguous, the discrepancy points to prompt-level instructions creating unintended behavioral steering. Generalize this: a *deterministic-looking* correlation between an input token and a tool choice is the signature of an explicit instruction, not of fuzzy model judgment. When the tool layer is stipulated clean, follow the steering signal upstream to the system prompt.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — "add negative examples to the tool descriptions specifying when NOT to use each tool."** It is seductive because negative examples are a genuine, well-known tooling technique, and the failure shows up *at tool-selection time*, so the instinct is to harden the tool layer that's picking wrong. The tell that it's wrong: the question explicitly stipulates the tool descriptions are already well-written and unambiguous, so editing them contradicts the stated premise and targets a layer that is not the source. Anyone reasoning "the tools are choosing badly, so fix the tools" lands on D instead of following the keyword→tool correlation upstream. The correct move is layer diagnosis — locate the keyword-sensitive routing rule in the system prompt, because a fix applied to the wrong layer cannot address the real cause.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because "more data / fine-tune" sounds rigorous, but it ignores the stated cause (a prompt instruction) and over-engineers a fix for a behavior that is being explicitly told to happen — fine-tuning won't override a live routing rule.
- **B.** Plausible because base-model lexical associations are real, but the question stipulates clean tool descriptions and shows a *systematic, near-deterministic* split (78%/93%) that points to an explicit rule, not diffuse pretraining priors.
- **C.** Correct: a keyword→tool correlation this consistent matches explicit, keyword-sensitive routing logic in the system prompt.
- **D.** Tempting because negative examples are a legitimate tooling technique, but it directly contradicts the premise that descriptions are already unambiguous and treats the wrong layer.

## 7. Key takeaways
- Diagnose the *layer* before prescribing a fix: base model, tool descriptions, and system prompt are distinct sources of tool-selection behavior.
- A tight, near-deterministic correlation between an input keyword and a tool choice signals an explicit instruction (system-prompt routing), not fuzzy model judgment.
- When tool descriptions are stipulated clean, do not "fix" the tool layer — that change cannot address an upstream cause and contradicts the premise.
- Audit system-prompt routing rules for unintended keyword triggers; remove brittle lexical steering and let well-written tool descriptions drive selection.

## 8. Official documentation
- [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Define tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools)
- [Tool use overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
