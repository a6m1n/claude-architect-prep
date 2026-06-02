# Classification Consistency — anchor severity with explicit criteria + examples

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.1 (+ 4.2 few-shot: severity criteria with code examples)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Classification Consistency
> **Trap level:** 🔴 High — every distractor sounds like a reasonable consistency fix
> **Trap archetype:** Symptom over root cause
> **Source:** Claude Certified Architect practice exam, Q26 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
When a model performs classification (severity, priority, category) inside an automated pipeline, consistency comes from constraining the model's *input space at inference time*, not from human cleanup afterward. The root cause of inconsistent labels is ambiguity: if "critical" vs. "medium" is left to the model's judgment, the same null-pointer risk lands in different buckets across PRs. The fix is a fixed rubric — explicit criteria for each level plus concrete code examples — that gives the model stable reference points to match against. This is a prompt-engineering pattern: replace open-ended judgment with a definition the model can anchor to. The architectural goal is determinism that scales without a human in the loop.

## 2. Question
> Your automated code review system shows inconsistent severity ratings—similar issues like null pointer risks receive "critical" severity in some PRs but only "medium" in others. Developer trust is declining because teams can't predict which findings require immediate attention. What's the most effective way to improve severity consistency?

## 3. Answer options
- **A.** Request that Claude include its reasoning for each severity assignment, then use that reasoning to manually calibrate and adjust ratings during review — ⚠️ **Most common wrong answer**
- **B.** Modify the prompt to ask Claude to rate severity relative to other issues in the same PR, so the most severe issue is always marked critical and others rated proportionally
- **C.** Add a `CLAUDE.md` file that lists issue types and their default severities, instructing Claude to reference this mapping when assigning ratings
- **D.** Include explicit severity criteria in your prompt with concrete code examples for each severity level — ✅ **Correct**

## 4. Correct answer — D
**Include explicit severity criteria in your prompt with concrete code examples for each severity level**

Including explicit severity criteria with concrete code examples directly addresses the root cause of inconsistency by removing ambiguity about what each severity level means. This is a proven prompt engineering technique that gives the model clear reference points for classification, leading to more reliable and predictable severity assignments. Generalizing: classification stability is an *input-design* problem — you constrain what the model has to decide by handing it a rubric and worked examples, so equivalent inputs map to the same label every time. Concrete examples per level act as few-shot anchors that pin down the boundaries between categories, which abstract definitions alone cannot do.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **A — emit Claude's reasoning, then have humans manually calibrate and adjust ratings during review.** It is seductive because reasoning transparency feels rigorous and auditable, so it looks like a principled way to catch and correct bad labels. The tell that it's wrong: it shifts the burden to human reviewers, which defeats the purpose of an *automated* code review system and does not scale — and the underlying ambiguity in the prompt remains, so the model keeps producing inconsistent labels that humans must repeatedly fix. The correct move attacks the root cause instead of the symptom: hand the model explicit per-level criteria with concrete code examples so equivalent inputs map to the same label at inference time, with no human in the loop. Anyone reasoning "add oversight to correct the bad output" rather than "remove the ambiguity that produces it" lands on A.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because reasoning transparency feels rigorous, but it moves correction to humans post-hoc — doesn't scale and leaves the model's ambiguity untouched.
- **B.** Tempting because relative ranking guarantees one "critical" per PR, but proportional-within-PR scoring makes the same issue critical in one PR and medium in another — it is inherently cross-PR inconsistent.
- **C.** Tempting because `CLAUDE.md` centralizes a mapping, but a default-severity list without concrete in-prompt criteria and code examples still leaves boundary cases ambiguous and is weaker than explicit criteria at inference time.
- **D.** Correct: explicit per-level criteria plus concrete code examples remove the ambiguity at its source and scale automatically.

## 7. Key takeaways
- Classification consistency is fixed at the *input* (rubric + concrete examples per level), not by post-hoc human calibration, which doesn't scale.
- Concrete code examples per severity level act as few-shot anchors that define category boundaries far better than abstract labels alone.
- Relative/proportional rating within a single PR optimizes the wrong axis — it produces stable intra-PR order but unstable cross-PR labels.
- A `CLAUDE.md` default-severity mapping is useful context but is no substitute for explicit, example-backed criteria in the prompt that does the classifying.

## 8. Official documentation
- [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Prompt engineering overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [GitHub Actions (CI/CD)](https://code.claude.com/docs/en/github-actions)
