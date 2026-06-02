# False-positive management — disable low-precision categories to protect trust

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.1 (disable high-FP categories to restore trust while improving prompts)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Code review quality — false-positive management & developer trust
> **Trap level:** 🟡 Medium — the "right long-term fix" distractor quietly ignores the urgency of trust erosion
> **Trap archetype:** Precision vs. recall trade-off
> **Source:** Claude Certified Architect practice exam, Q29 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question tests how an agentic reviewer's output quality affects *human adoption*, not just per-finding accuracy. In a code-review system, false positives are a trust multiplier: a high-noise category does not just waste time on its own findings — it teaches developers to dismiss *all* findings, including the high-precision ones. The architect's job is to manage the system at the category level, treating precision as a property you can selectively enable or quarantine rather than a single global dial. The transferable principle is that mixed-precision outputs converge to the trust level of their worst component, so you protect signal by isolating noise.

## 2. Question
> Analysis of your automated code review shows significant variation in false positive rates across finding categories. Security and correctness findings have an 8% false positive rate, performance findings have 18%, style and naming findings have 52%, and documentation findings have 48%. Developer surveys indicate growing distrust—many have started dismissing findings without review because 'half are wrong.' The high false positive categories are undermining confidence in the accurate categories. What approach best restores developer trust while improving the system?

## 3. Answer options
- **A.** Keep all categories but display a confidence score with each finding, letting developers decide which to investigate.
- **B.** Keep all categories enabled while adding few-shot examples to improve each category's accuracy over the coming weeks. — ⚠️ **Most common wrong answer**
- **C.** Apply a uniform strictness reduction across all categories to bring the overall false positive rate to an acceptable level.
- **D.** Temporarily disable high false positive categories (style, naming, documentation) and run only high-precision categories while improving prompts. — ✅ **Correct**

## 4. Correct answer — D
**Temporarily disable high false positive categories (style, naming, documentation) and run only high-precision categories while improving prompts.**

Temporarily disabling the high false positive categories (style, naming, documentation) immediately stops trust erosion by removing the noise that causes developers to dismiss all findings, while preserving the value of high-precision categories like security and correctness. This approach allows time to improve prompts for the problematic categories before re-enabling them, rebuilding trust through demonstrated accuracy. Generalized: when a system's output is consumed by humans whose attention is finite, isolate and quarantine the low-precision sources first so the high-precision signal is not discarded along with the noise, then iterate on the quarantined components offline before reintroducing them.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "keep all categories enabled while adding few-shot examples to improve each category's accuracy over the coming weeks."** It is seductive because few-shot improvement genuinely is the right *long-term* remedy for a noisy category, so it feels both correct and constructive. The tell that it's wrong: it leaves the noisy categories live "over the coming weeks," meaning developers keep seeing wrong findings and trust keeps eroding the entire time — it treats a trust emergency as a slow optimization project. The correct move quarantines the low-precision categories *now* to stop the bleeding, then improves their prompts offline before re-enabling. Generalizing the archetype: when precision is too low, you must stop emitting the unreliable signal first, not merely promise to tune it later while it keeps poisoning the reliable signal.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Confidence scores add per-finding metadata but do nothing to stop the immediate noise; developers already dismissing findings won't start triaging by score, and you've offloaded the precision problem onto humans.
- **B.** Improving accuracy with few-shot examples is the right *long-term* fix, but keeping noisy categories enabled "over the coming weeks" lets trust keep eroding the entire time — it ignores the urgency of the trust problem.
- **C.** A uniform strictness reduction drags the already-accurate categories (8% security/correctness) down to fix the bad ones, suppressing valuable true positives instead of targeting the actual high-FP categories.
- **D.** Correct — quarantines only the low-precision categories, preserving high-precision signal while prompts are improved offline.

## 7. Key takeaways
- False positives are a trust multiplier: noisy categories cause humans to dismiss accurate ones, so mixed-precision output converges to its worst component's credibility.
- Manage precision at the category level — selectively disable or quarantine low-precision sources rather than applying one global strictness setting.
- Never fix per-category noise with a uniform reduction; it sacrifices true positives in your best categories to compensate for the worst.
- Stopping active trust erosion is urgent; improve and validate the disabled categories offline, then re-enable once accuracy is demonstrated.

## 8. Official documentation
- [Code review](https://code.claude.com/docs/en/code-review)
- [Best practices](https://code.claude.com/docs/en/best-practices)
- [GitHub Actions (CI/CD)](https://code.claude.com/docs/en/github-actions)
