# Escalation Decisions — escalate policy ambiguity, not factual conflict

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.2 (escalation/ambiguity)
> **Scenario:** Customer Support Resolution Agent · **Study area:** Escalation Decisions
> **Trap level:** 🔴 High — "contradictory evidence feels delicate" makes the wrong pick read as caring
> **Trap archetype:** Escalate ambiguity, not facts
> **Source:** Claude Certified Architect practice exam, Q49 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This tests when an agent should hand control to a human via an escalation tool like `escalate_to_human`. A well-designed agent escalates when it lacks the *authority* or *information* to act safely — not whenever a conversation is uncomfortable. The sharpest signal is a **policy gap**: the agent has all the facts but the governing rules are silent or ambiguous, so any decision would require fabricating policy. Contrast this with situations where facts are complete *and* a policy applies — the agent should simply execute the procedure. The transferable skill is mapping the (facts × policy) state of a request to the correct action: act, escalate, or gather more data.

## 2. Question
> After calling `get_customer` and `lookup_order`, the agent has retrieved all available system data but faces uncertainty. Which situation represents the most appropriate trigger for calling `escalate_to_human`?

## 3. Answer options
- **A.** The customer's message mentions a billing question and a product return. The agent should escalate so a human can coordinate handling both issues in a single interaction.
- **B.** The customer wants to cancel an order that shipped yesterday, with delivery scheduled for tomorrow. The agent should escalate because the customer might change their mind once they receive the package.
- **C.** The customer requests a price match against a competitor. Your policies allow adjustments for price drops on your own site within 14 days but are silent on competitor pricing. The agent should escalate for policy interpretation. — ✅ **Correct**
- **D.** The customer claims they never received their order, but tracking shows it was delivered and signed for at their address three days ago. The agent should escalate because presenting contradictory evidence might damage the customer relationship. — ⚠️ **Most common wrong answer**

## 4. Correct answer — C
**The customer requests a price match against a competitor. Your policies allow adjustments for price drops on your own site within 14 days but are silent on competitor pricing. The agent should escalate for policy interpretation.**

Per the official explanation, this "represents a genuine policy gap where the company's guidelines cover on-site price drops but are silent on competitor price matching, meaning the agent cannot fabricate a policy and must escalate for human judgment on how to interpret or extend existing rules." The agent already has all needed facts; what it lacks is the *authority* to invent a rule the company never set. Generalizing: escalate when the decision requires interpreting or extending policy that does not exist, because guessing here risks inconsistent or unauthorized commitments. Escalation is the safe default precisely when no procedure covers the case.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **D — escalate because contradictory tracking evidence "might damage the customer relationship."** It is seductive because a customer claiming non-receipt while tracking shows a signed delivery feels delicate, and routing it to a human reads as the caring, conflict-averse choice. The tell that it's wrong: the agent already has clear factual tracking data and a standard procedure to share it, so this is emotional avoidance of an awkward message rather than an operational need for human intervention. Contrast with the correct move (C), where the agent has every fact but no rule to apply and genuinely cannot invent one. Generalizing the archetype: escalate when policy is ambiguous or absent, not when the *facts* are simply uncomfortable to deliver.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Tempting because two requests sounds complex, but multiple in-scope issues are just sequential work the agent can handle — handling-both-at-once is a UX preference, not a reason to escalate.
- **B.** Tempting because predicting the customer "might change their mind" feels considerate, but it's speculation about a future the agent cannot know; the cancellation request is clear and actionable now.
- **C.** Correct — a true policy gap (silent on competitor pricing) where the agent has no rule to apply and cannot invent one, so human interpretation is required.
- **D.** Tempting because contradictory evidence feels delicate, but the agent has the facts and a standard procedure; escalating only to avoid an uncomfortable message is emotional avoidance, not an operational need.

## 7. Key takeaways
- Decision frame: facts + applicable policy → act; facts but no/ambiguous policy → escalate; missing facts → gather more data first.
- Escalate on **policy ambiguity or lack of authority**, never merely because the conversation is awkward or the evidence is contradictory.
- An agent must not fabricate or guess policy that the organization never defined — that gap is exactly what human judgment is for.
- Speculation about future customer behavior and a preference for bundling tasks are not valid escalation triggers; only genuine inability to act safely is.

## 8. Official documentation
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Writing effective tools for agents](https://www.anthropic.com/engineering/writing-effective-tools-for-agents)
