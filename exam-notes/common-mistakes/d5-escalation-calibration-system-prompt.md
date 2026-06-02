# Escalation calibration — teach decision boundaries in the system prompt

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.2 (explicit escalation criteria + few-shot examples)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Escalation calibration — explicit criteria + few-shot examples
> **Trap level:** 🟡 Medium — confidence scores and sentiment both sound principled but are weak proxies
> **Trap archetype:** Explicit criteria vs. self-confidence/sentiment
> **Source:** Claude Certified Architect practice exam, Q54 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question probes how an architect diagnoses and corrects a mis-calibrated escalation policy. The symptom — escalating easy cases while attempting hard ones — is the signature of an undefined decision boundary, not a missing model or pipeline. The discipline being tested is choosing the most *proportionate* first intervention: fix the behavior at its source (the system prompt) before reaching for confidence scores, sentiment heuristics, or auxiliary classifiers. Explicit criteria paired with few-shot examples teach the agent exactly where the line sits, which is cheaper, lower-latency, and more directly debuggable than added infrastructure. The transferable lesson: when an agent's judgment is inverted, clarify the judgment before you wrap it in machinery.

## 2. Question
> Your agent achieves 55% first-contact resolution, well below the 80% target. Logs show it escalates straightforward cases (standard damage replacements with photo evidence) while attempting to autonomously handle complex situations requiring policy exceptions. What's the most effective way to improve escalation calibration?

## 3. Answer options
- **A.** Add explicit escalation criteria to your system prompt with few-shot examples demonstrating when to escalate versus resolve autonomously. — ✅ **Correct**
- **B.** Have the agent self-report a confidence score (1-10) before each response and automatically route requests to humans when confidence falls below a threshold. — ⚠️ **Most common wrong answer**
- **C.** Implement sentiment analysis to detect customer frustration levels and automatically escalate when negative sentiment exceeds a threshold.
- **D.** Deploy a separate classifier model trained on historical tickets to predict which requests need escalation before the main agent begins processing.

## 4. Correct answer — A
**Add explicit escalation criteria to your system prompt with few-shot examples demonstrating when to escalate versus resolve autonomously.**

Adding explicit escalation criteria with few-shot examples directly addresses the root cause — unclear decision boundaries between straightforward and complex cases. This is the most proportionate and effective first intervention, as it teaches the agent precisely when to escalate versus resolve autonomously without requiring additional infrastructure. Generalizing: when an agent applies a policy inconsistently, the fix is usually to make the policy explicit and demonstrate it, not to bolt on a separate control system. Few-shot examples encode the boundary in the exact terms the model reasons over, and they remain inspectable and tunable as edge cases surface.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "have the agent self-report a confidence score and route to humans below a threshold."** It is seductive because a numeric confidence gate sounds principled and measurable, as if the agent could simply flag what it is unsure about. The tell that it's wrong: model self-reported confidence is poorly calibrated and easily gamed — the very agent that confidently mishandles policy exceptions will also report high confidence on them, so the gate fires exactly when it shouldn't. The correct move clarifies the decision boundary at its source with explicit criteria and few-shot examples, rather than wrapping an unreliable self-assessment in routing machinery. The archetype: prefer explicit, inspectable criteria over self-confidence or sentiment as the escalation signal.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — explicit criteria plus few-shot examples fix the decision boundary at its source.
- **B.** Tempting because a confidence threshold sounds principled, but model self-reported confidence is poorly calibrated and easily gamed — the agent that confidently mishandles policy exceptions will also report high confidence on them.
- **C.** Sentiment is a weak proxy for complexity: hard policy-exception cases can arrive perfectly calm, while routine replacements can be filed by frustrated customers, so it would mis-route in both directions.
- **D.** A separate trained classifier over-engineers the problem — it adds training data needs, maintenance, and per-request latency to solve what a clarified prompt resolves directly.

## 7. Key takeaways
- Inverted escalation behavior (easy out, hard in) is a decision-boundary problem; fix it where decisions are made — the system prompt.
- Prefer the most proportionate intervention first; explicit criteria + few-shot examples beat added infrastructure on cost, latency, and debuggability.
- Self-reported confidence and sentiment are unreliable proxies; a separate classifier trades a prompt edit for a model to train and maintain.

## 8. Official documentation
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
