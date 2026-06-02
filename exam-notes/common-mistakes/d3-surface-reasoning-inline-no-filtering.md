# Reduce triage time by surfacing reasoning inline (without filtering)

> **Domain:** D3 · Claude Code Config & Workflows (20%) — Task 3.6 (CI: structured findings as inline PR comments)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Review UX — surface reasoning inline; honor design constraints
> **Trap level:** 🟡 Medium — every distractor targets the loud 40% false-positive number instead of the real bottleneck
> **Trap archetype:** Respect the stated constraint
> **Source:** Claude Certified Architect practice exam, Q20 — reproduced as a common-mistake case study.

## 1. Topic — what this really tests
This question is about designing an agentic review pipeline that solves the *real* bottleneck while respecting *hard* stakeholder constraints. The cost here is not the volume of findings or even the false positive rate — it is the per-finding investigation time, because developers must click into each finding to retrieve Claude's reasoning before they can act. The architectural lever is *output shaping*: make the model emit the information a human needs to triage (reasoning + confidence) in the same place the finding appears, so the human can decide at a glance. Critically, any solution that reduces visible findings is off the table — stakeholders have explicitly rejected pre-filtering. The transferable skill is to separate the bottleneck (investigation time) from the symptoms (volume, false positives) and to treat stated constraints as non-negotiable design boundaries.

## 2. Question
> Your automated code review averages 15 findings per pull request, with developers reporting a 40% false positive rate. The bottleneck is investigation time: developers must click into each finding to read Claude's reasoning before deciding whether to address or dismiss it. Your CLAUDE.md already contains comprehensive rules for acceptable patterns, and stakeholders have rejected any approach that filters findings before developers see them. What change would most directly address the investigation time bottleneck?

## 3. Answer options
- **A.** Require Claude to include its reasoning and confidence assessment inline with each finding — ✅ **Correct**
- **B.** Add a post-processor that analyzes finding patterns and automatically suppresses those matching historical false positive signatures — ⚠️ **Most common wrong answer**
- **C.** Configure Claude to only surface findings it assesses as high confidence, filtering out uncertain flags before developers see them
- **D.** Categorize findings as 'blocking issues' versus 'suggestions' with tiered review requirements

## 4. Correct answer — A
**Require Claude to include its reasoning and confidence assessment inline with each finding**

Including reasoning and confidence assessments inline with each finding directly addresses the investigation time bottleneck by allowing developers to quickly evaluate findings without clicking into each one separately. This approach respects the constraint against filtering, since all findings remain visible while making triage significantly faster. The generalizable principle: when the cost is *human evaluation time per item*, move the evaluation-relevant context (rationale, confidence, evidence) into the surface where the item is first seen, rather than reducing or reordering the items. Output shaping changes the triage experience without changing what the model is allowed to flag.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "add a post-processor that suppresses findings matching historical false-positive signatures."** It is seductive because the stem dangles a loud 40% false-positive rate, so the instinct is to attack that number and quiet the noise. The tell that it's wrong: suppressing findings by signature *is* filtering before developers ever see them, which the stakeholders explicitly rejected — and it still does nothing for the real bottleneck, the per-finding investigation time. The correct move shapes the output to surface reasoning and confidence inline, speeding triage while keeping every finding visible. Generalizing the archetype: a stated constraint ("no filtering") is a hard design boundary, and the highlighted metric is often a symptom, not the bottleneck to solve.

## 6. Distractor analysis — look-alikes to watch for
- **A.** Correct — surfaces reasoning and confidence inline so triage is fast, and keeps every finding visible (no filtering).
- **B.** Tempting because it targets the 40% false positive rate, but suppressing findings by signature *is* filtering before developers see them — it violates the explicit stakeholder constraint.
- **C.** Tempting as a "smart" volume reduction, but gating on confidence filters out uncertain flags before developers see them, again breaking the no-filtering constraint (and risking suppressed true positives).
- **D.** Tempting because tiering looks like prioritization, but it only adds metadata/labels — developers must still click into each finding to understand it, so the per-finding investigation time bottleneck remains.

## 7. Key takeaways
- Identify the *actual* bottleneck (per-finding investigation time) and solve it directly; do not be drawn to attacking adjacent symptoms like volume or false positive rate.
- Treat stated stakeholder constraints (here, "no filtering before developers see findings") as hard design boundaries — any answer that violates them is disqualified regardless of its other merits.
- When the cost is human evaluation time, shape the model's output to surface reasoning, confidence, and evidence inline rather than behind extra navigation.
- Adding labels or categories (metadata) does not reduce investigation effort if the human still has to drill in to understand each item.

## 8. Official documentation
- [Code review](https://code.claude.com/docs/en/code-review)
- [Common workflows](https://code.claude.com/docs/en/common-workflows)
