# Restructuring a flaky PR review: per-file passes + a cross-file integration pass

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.6 (multi-instance / multi-pass review)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Multi-pass review (per-file + cross-file integration)
> **Trap level:** 🔴 High — every distractor mimics a real reliability tactic but dodges the root cause
> **Trap archetype:** Per-file + integration pass (scope each pass vs. bigger context / consensus)
> **Source:** Official Claude Certified Architect exam guide — Sample Question 12.

## 1. Topic — what this really tests
When one review pass must reason over many files at once, **attention dilutes**: depth becomes uneven, obvious bugs slip through, and the same pattern gets flagged in one file yet approved in another. The fix is architectural, not a knob: split the work into a **per-file local-analysis pass** (consistent depth on each file) plus a **separate integration pass** for cross-file data flow. A larger context window does **not** solve this — fitting all 14 files into context does nothing for the *quality* of attention spread across them. Independent review instances also outperform self-review, since a model that just generated (or just analyzed) carries that context forward and is less likely to question its own conclusions.

## 2. Question
> A pull request modifies 14 files across the stock tracking module. Your single-pass review analyzing all files together produces inconsistent results: detailed feedback for some files but superficial comments for others, obvious bugs missed, and contradictory feedback—flagging a pattern as problematic in one file while approving identical code elsewhere in the same PR. How should you restructure the review?
>
> **A)** Split into focused passes: analyze each file individually for local issues, then run a separate integration-focused pass examining cross-file data flow
> **B)** Require developers to split large PRs into smaller submissions of 3-4 files before the automated review runs
> **C)** Switch to a higher-tier model with a larger context window to give all 14 files adequate attention in one pass
> **D)** Run three independent review passes on the full PR and only flag issues that appear in at least two of the three runs

## 3. Answer options
- **A.** Per-file local passes + a separate cross-file integration pass — ✅ **Correct**
- **B.** Force developers to break the PR into 3–4 file submissions
- **C.** Move to a larger-context-window model, keep single pass — ⚠️ **Most common wrong answer**
- **D.** Three full-PR passes, flag only consensus (≥2 of 3)

## 4. Correct answer — A
A attacks the **root cause**: attention dilution from processing too many files in one pass. Analyzing each file on its own guarantees **consistent depth** and kills the contradictory-findings problem (the model isn't juggling 14 files' worth of context when it judges any one). A dedicated **integration pass** then does what per-file passes can't — trace cross-file data flow and interface contracts. The generalizable principle: **scope each pass to what it can analyze well, then add a separate pass for the relationships between scopes.** Pair this with the independent-instance idea — a fresh reviewer instance with no prior generation/analysis context questions decisions a self-reviewer would rubber-stamp.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **C — "switch to a model with a larger context window and keep one pass."** It is seductive because the symptom reads like a capacity problem: 14 files feel like "too much to fit," so a bigger window sounds like the obvious cure. The tell that it's wrong is **context size ≠ attention quality** — all 14 files already *fit*; the uneven depth and contradictory findings come from how attention is *allocated* across them, which more room does nothing to repair. The correct move attacks the real cause architecturally: scope each pass to one file for consistent depth, then add a separate integration pass for cross-file flow. Generalized, this is the symptom-over-root-cause trap — reaching for a bigger mechanism instead of scoping each pass to what it can actually analyze well.

## 6. Distractor analysis — look-alikes to watch for
- **B** — shifts the burden to developers and changes their workflow without fixing the review system; the architecture is still incapable of handling a large PR correctly. Process band-aid, not a design fix.
- **C** — the classic trap: **context size ≠ attention quality.** A bigger window lets all 14 files *fit*, but the uneven-depth/contradiction failure is about how attention is allocated across them, which more context does not repair.
- **D** — sounds rigorous but **suppresses real bugs.** Bugs caught intermittently (exactly the ones a diluted single pass misses) often surface in only one of three runs; requiring ≥2-of-3 consensus filters those out. It also triples cost and never adds the cross-file pass that the contradictions actually call for.

## 7. Key takeaways
- Inconsistent depth + contradictory findings across a multi-file review = **attention dilution**; the answer is to **split passes by scope**.
- **Per-file local pass** for depth + **separate integration pass** for cross-file data flow — neither alone is enough.
- **Larger context window ≠ better attention.** Fitting everything in does not fix attention quality.
- **Consensus voting (≥2-of-3) suppresses intermittently-caught real bugs** and inflates cost — avoid it as a "reliability" mechanism for bug detection.
- **Independent review instance > self-review:** a reviewer without prior reasoning context is more willing to challenge a decision.

## 8. Official documentation
- Claude Code — Code Review (multi-agent parallel analysis + verification step to cut false positives): https://code.claude.com/docs/en/code-review
- Anthropic Engineering — Building Effective Agents (parallelization / evaluator-optimizer; multiple independent prompts reviewing code): https://www.anthropic.com/engineering/building-effective-agents
