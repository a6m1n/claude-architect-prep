# Prompt Specificity — define the criterion, don't just show examples

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.1 (explicit criteria over vague instructions)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Prompt Specificity
> **Trap level:** 🔴 High — few-shot examples are a real technique, so "add examples" feels like the principled fix
> **Trap archetype:** Define the criterion vs. show examples
> **Source:** Claude Certified Architect practice exam, Q25 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question tests whether you can locate the *root cause* of inconsistent model output: an underspecified instruction. When a prompt says "check that comments are accurate and up-to-date," the decision boundary is never defined, so the model improvises — flagging benign patterns (false positives) and missing genuinely stale comments (false negatives). The architectural fix is to replace the vague directive with an explicit, testable criterion that the model can apply uniformly. A precise criterion generalizes to cases the author never anticipated, whereas examples, metadata, or pre-filtering only paper over the missing definition. The transferable principle: specify *what counts as a problem*, not just *what a problem looks like*.

## 2. Question
> Your automated review analyzes comments and docstrings. The current prompt instructs Claude to 'check that comments are accurate and up-to-date.' Findings frequently flag acceptable patterns (TODO markers, straightforward descriptions) while missing comments that describe behavior the code no longer implements. What change addresses the root cause of this inconsistent analysis?

## 3. Answer options
- **A.** Specify explicit criteria: flag comments only when their claimed behavior contradicts actual code behavior — ✅ **Correct**
- **B.** Add few-shot examples of misleading comments to help the model recognize similar patterns in the codebase — ⚠️ **Most common wrong answer**
- **C.** Include git blame data so Claude can identify comments that predate recent code modifications
- **D.** Filter out TODO, FIXME, and descriptive comment patterns before analysis to reduce noise

## 4. Correct answer — A
**Specify explicit criteria: flag comments only when their claimed behavior contradicts actual code behavior**

Specifying explicit criteria — flag comments only when their claimed behavior contradicts actual code behavior — directly addresses the root cause by replacing the vague instruction with a precise definition of what constitutes a problem. This eliminates both false positives on acceptable patterns and false negatives on genuinely misleading comments. The generalizable design principle: when output is inconsistent, define the decision boundary explicitly rather than nudging the model toward a vibe. A clear, testable criterion is reusable across novel inputs because the model evaluates the rule, not a remembered example.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "add few-shot examples of misleading comments."** It is seductive because few-shot prompting is a real, powerful technique, so reaching for examples feels like the principled, well-known fix. The tell that it's wrong: examples pattern-match the specific shapes shown and never state the underlying rule, so the model still has no principled way to judge novel contradiction types — the false positives and false negatives recur on inputs unlike the examples. Anyone reasoning "show the model what good looks like" instead of "define what counts as a problem" lands on B. The correct move defines the decision boundary explicitly (flag iff claimed behavior contradicts actual behavior), which generalizes to unseen cases — examples illustrate the problem, the criterion specifies it.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — names the actual decision rule (claimed behavior contradicts real behavior), which fixes both error types at once.
- **B.** Tempting because few-shot prompting is a real, powerful technique — but examples pattern-match and fail to generalize to unseen contradiction types; they don't define the criterion.
- **C.** Tempting because git blame seems to detect "out-of-date" comments — but recency ≠ inaccuracy; an old comment can be correct and a new one wrong, so it dodges the undefined criterion.
- **D.** Tempting because filtering reduces obvious false positives — but it suppresses noise without defining correctness, can hide real issues, and still leaves the core judgment underspecified.

## 7. Key takeaways
- Inconsistent model output usually signals an underspecified instruction; fix it by defining the decision boundary, not by adding scaffolding around a vague one.
- A precise, testable criterion ("flag iff claimed behavior contradicts actual behavior") generalizes to novel cases; few-shot examples only pattern-match known shapes.
- Metadata (git blame) and pre-filtering treat symptoms — they sidestep the missing criterion rather than supplying it.
- Prefer explicit criteria first; reserve few-shot examples for clarifying *format* or edge interpretation once the rule itself is well defined.

## 8. Official documentation
- [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Prompt engineering overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
