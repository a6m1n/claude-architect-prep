# Iterative Refinement: Demonstrate, Don't Describe

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.5 (iterative refinement)
> **Scenario:** Code Generation with Claude Code · **Study area:** Iterative refinement (I/O examples, test-driven, interview pattern)
> **Trap level:** 🟡 Medium — three "try harder with the same prose" decoys, only one fixes the underspecification
> **Trap archetype:** Specify intent vs. re-prompt blindly
> **Source:** Concept note grounded in the official exam guide, Task 3.5.

## 1. Topic — what this really tests
When prose descriptions of a transformation are interpreted inconsistently, the fix is to **demonstrate, not describe**: supply 2-3 concrete input/output examples that pin down the expected behavior. Related techniques are **test-driven iteration** (write the test suite first — expected behavior, edge cases, performance — then iterate by sharing failures) and the **interview pattern** (have Claude ask questions to surface considerations like cache invalidation or failure modes before coding in an unfamiliar domain). Also tested: bundle **interacting** fixes into a single detailed message; iterate **independent** fixes sequentially.

## 2. Question
> A developer asks Claude Code to convert raw analytics records into a normalized schema. The natural-language spec ("flatten nested fields, coerce types, drop empties") keeps producing subtly different code each run — sometimes nulls are dropped, sometimes kept; date formats vary. Re-prompting with the same prose does not converge. What is the most effective next step?
>
> - **A.** Provide 2-3 concrete input/output example pairs (including a record with `null` fields) and iterate by sharing failing test cases against the expected output.
> - **B.** Repeat the same prose specification more emphatically and add "be very careful and precise."
> - **C.** Switch to a different Claude model and resubmit the identical prose prompt.
> - **D.** Tell Claude to "use best practices for data normalization" and accept whatever it produces.

## 3. Answer options
- **A.** Provide 2-3 concrete input/output examples + iterate on failing tests. ✅ **Correct**
- **B.** Repeat the prose more emphatically with "be careful." — ⚠️ **Most common wrong answer**
- **C.** Switch models, same prose prompt.
- **D.** Defer to vague "best practices."

## 4. Correct answer — A
Inconsistent output from prose means the spec is **underspecified**, not under-emphasized. Concrete I/O examples communicate the exact transformation — including the `null`-handling edge case the prose left ambiguous — far more reliably than any wording. Pairing this with test-driven iteration (run tests, share the specific failures back to Claude) gives an objective convergence signal so each round provably improves. Generalize: **demonstrate the expected transformation, then iterate on failing tests**.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "repeat the same prose more emphatically and add 'be very careful and precise.'"** It is seductive because the variance feels like a discipline problem, so adding emphasis reads as "just try harder." The tell that it's wrong: emphasis carries no new information about *what* the output should be — the `null`-handling ambiguity that causes the variance is still there, so the same prose yields the same drift no matter how forcefully it is stated. The correct move is to remove the ambiguity at its source by demonstrating the transformation with concrete I/O examples and iterating on failing tests. Generalize: when output won't converge, **specify the intent**, don't re-prompt blindly.

## 6. Distractor analysis — look-alikes to watch for
- **B** — More emphasis ("be careful") adds no new information about *what* the output should be; the ambiguity that causes variance is still there. Tempting because it feels like "trying harder."
- **C** — Swapping models does not resolve an underspecified prompt; the same prose yields the same ambiguity. A model change addresses capability, not specification gaps.
- **D** — Delegating to undefined "best practices" increases ambiguity rather than reducing it, and abandons verification entirely.

## 7. Key takeaways
- Prose interpreted inconsistently → give **2-3 concrete input/output examples**; demonstrate, don't describe.
- **Test-driven iteration:** write tests (behavior, edge cases, performance) first, then share **failures** to guide progressive improvement.
- Use the **interview pattern** in unfamiliar domains — let Claude ask questions to surface cache invalidation, failure modes, and other unanticipated considerations *before* implementing.
- Provide a specific edge-case example (e.g., `null` values in a migration script) to fix edge-case handling.
- **Interacting** fixes → one detailed message; **independent** fixes → sequential iteration.

## 8. Official documentation
- Claude Code — Common workflows (refactoring, testing, iterating on failures): https://code.claude.com/docs/en/common-workflows
- Anthropic Engineering — Building effective agents (evaluator-optimizer loops, empirical/test-driven iteration): https://www.anthropic.com/engineering/building-effective-agents
