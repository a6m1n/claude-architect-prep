# Batch Processing — match async/poll workloads to the Message Batches API

> **Domain:** D4 · Prompt Engineering & Structured Output (20%) — Task 4.5 (batch processing)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Batch Processing
> **Trap level:** 🔴 High — "play it safe, batch nothing" feels prudent but silently wastes 50%
> **Trap archetype:** Match the workload to the API
> **Source:** Claude Certified Architect practice exam, Q24 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question is about matching a workload's latency profile to the right execution mode. The Message Batches API trades immediacy for cost: it cuts API spend by 50% but is asynchronous, poll-based, and may take up to 24 hours to return. The architect's job is to classify each workload as latency-sensitive (blocking, on the critical path) or latency-tolerant (deferred, off the critical path), and route only the tolerant ones to batch. A blocking gate that humans wait on must stay synchronous; a deferred job that already runs overnight is the textbook batch candidate. The transferable skill is reading the timing constraint of a workload and selecting the delivery model that fits it without overpaying.

## 2. Question
> Your CI pipeline includes two Claude-powered code review modes: a `pre-merge-commit` hook that blocks PR merging until complete, and 'deep analysis' that runs overnight for batch completion, then posts detailed suggestions to the PR. You want to reduce API costs using the Message Batches API, which offers 50% cost savings but requires polling and may take up to 24 hours to complete. Which mode should use batch processing?

## 3. Answer options
- **A.** Deep analysis only — ✅ **Correct**
- **B.** Both modes
- **C.** Neither mode — ⚠️ **Most common wrong answer**
- **D.** Pre-merge-commit hook only

## 4. Correct answer — A
**Deep analysis only**

Per the official explanation: "Deep analysis is the ideal candidate for batch processing because it already runs overnight, tolerates latency, and uses a polling model to check for completion before posting results—perfectly matching the Message Batches API's asynchronous, poll-based design while capturing the 50% cost savings." The deep-analysis job is off the critical path, so a multi-hour, poll-based turnaround costs nothing in user experience while halving spend. Generalize this: route a workload to batch when, and only when, its delivery deadline is looser than the API's worst-case completion window and nothing blocks on its result. The `pre-merge-commit` hook fails that test because it gates merges in real time.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **C — "Neither mode."** It is seductive because the blocking `pre-merge-commit` hook genuinely cannot tolerate a 24-hour batch window, so rejecting batch wholesale feels like the safe, conservative call. The tell that it's wrong: "neither" treats the two modes as one undifferentiated workload, when the deep-analysis job is already overnight and poll-based — a textbook latency-tolerant fit that loses nothing by going async. Refusing to classify each workload separately leaves a clean 50% savings on the table for no benefit. The correct move is to match each workload to the mechanism its deadline allows: batch the deferred job, keep the blocking gate synchronous.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — the only workload that is both latency-tolerant and already poll-based.
- **B.** "Both modes" misapplies batch to the `pre-merge-commit` hook, which blocks PR merging and needs immediate, synchronous results; a 24-hour batch would stall every merge.
- **C.** "Neither mode" avoids the misuse on the hook but throws away the legitimate 50% savings on deep analysis — over-conservative.
- **D.** "Pre-merge-commit hook only" is exactly inverted: it batches the one latency-sensitive gate and skips the latency-tolerant job that should be batched.

## 7. Key takeaways
- Batch processing fits latency-TOLERANT, asynchronous, poll-based workloads — overnight deep analysis is the canonical case, earning the 50% discount.
- Never put a blocking, on-the-critical-path step (like a pre-merge gate humans wait on) into a batch that can take up to 24 hours.
- Classify each workload by its real deadline before optimizing cost: "neither" leaves savings unclaimed; "both" breaks a latency-sensitive path.

## 8. Official documentation
- [Batch processing (Message Batches API)](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [GitHub Actions (CI/CD)](https://code.claude.com/docs/en/github-actions)
