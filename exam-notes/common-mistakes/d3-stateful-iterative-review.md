# Stateful iterative review — feed prior findings back into context

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.6 (CI/CD: include prior review findings to avoid duplicate comments)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Iterative review — stateful context / eliminating redundant feedback
> **Trap level:** 🟡 Medium — "just filter out the duplicates after the fact" sounds like a clean fix
> **Trap archetype:** Right workload, wrong mechanism
> **Source:** Claude Certified Architect practice exam, Q28 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
The Messages API is stateless: each review invocation is an independent call with no memory of what a prior run reported or what the developer has since fixed. To make an iterative CI review *state-aware*, the architect must reify the missing state — the earlier findings — and pass it into the model's context, then instruct the model to reason about what is already resolved. This is a context-engineering problem, not a string-matching problem: the deduplication decision ("is finding X still valid given these new commits?") requires semantic judgment about code that has changed, which only the model has the information to make. The transferable principle is that statelessness is solved by feeding the relevant prior state forward, letting the model reason over it, rather than by bolting brittle heuristics onto the output.

## 2. Question
> After an initial automated review generates 12 findings, a developer pushes new commits to address the issues. When the review runs again, it produces 8 findings—but developers report that 5 duplicate earlier comments on code that was already fixed in the new commits. What's the most effective way to eliminate this redundant feedback while maintaining thorough analysis?

## 3. Answer options
- **A.** Run reviews only on initial PR creation and final pre-merge state, skipping intermediate commits.
- **B.** Add a post-processing filter that removes findings matching previous file paths and issue descriptions before posting comments. — ⚠️ **Most common wrong answer**
- **C.** Restrict the review scope to only files modified in the most recent push, excluding files from earlier commits.
- **D.** Include prior review findings in context, instructing Claude to only report new or still-unaddressed issues. — ✅ **Correct**

## 4. Correct answer — D
**Include prior review findings in context, instructing Claude to only report new or still-unaddressed issues.**

Including prior review findings in context allows Claude to intelligently distinguish between new issues and those already addressed by recent commits. This approach maintains thorough analysis while leveraging Claude's reasoning ability to avoid redundant feedback on fixed code. Generalized: when an agent step appears to "forget" earlier work, supply the prior state as input and let the model reason over it — semantic deduplication beats mechanical filtering because the model can tell a genuinely-fixed issue from one that merely looks similar.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "add a post-processing filter that removes findings matching previous file paths and issue descriptions."** It is seductive because the problem is literally framed as "duplicate comments," so the instinct is to deduplicate the output: match this run's findings against the last run's text and drop the repeats. The tell that it's wrong: a string filter judges by surface text, not by whether the code is actually fixed — it cannot tell a still-unfixed issue from a resolved one, so it suppresses genuinely-valid findings while letting near-identical-but-not-exact duplicates through. Routing a semantic-judgment task ("is this issue still valid given the new commits?") to a mechanical text-matcher is the wrong-mechanism trap. The correct move feeds the prior findings into context and lets the model reason over what changed — semantic deduplication, not string matching.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Skipping intermediate commits trades away the fast iterative feedback that makes CI review valuable, and the final-state run could still surface stale findings — it dodges the problem instead of solving it.
- **B.** A post-processing string filter on file paths and issue descriptions is brittle: it cannot tell a still-unfixed issue from a fixed one, so it suppresses by surface text and risks dropping valid new findings while keeping non-identical duplicates.
- **C.** Restricting scope to the most recently modified files loses coverage — regressions or issues spanning earlier files go unreviewed — violating the "maintain thorough analysis" requirement.
- **D.** Correct — passes prior findings into context so Claude reasons about what is resolved, preserving thoroughness while eliminating duplicates.

## 7. Key takeaways
- The Messages API is stateless; make iterative workflows state-aware by passing prior outputs (findings) forward into context, not by adding external memory hacks.
- Deduplication that depends on judging whether code is "now fixed" is a reasoning task — give the model the context and let it decide, rather than matching strings after the fact.
- Heuristics that skip commits or narrow scope reduce noise by sacrificing coverage; prefer solutions that keep analysis thorough while removing only true redundancy.

## 8. Official documentation
- [Common workflows](https://code.claude.com/docs/en/common-workflows)
- [GitHub Actions (CI/CD)](https://code.claude.com/docs/en/github-actions)
- [Code review](https://code.claude.com/docs/en/code-review)
