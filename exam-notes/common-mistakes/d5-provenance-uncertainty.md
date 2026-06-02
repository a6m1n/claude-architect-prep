# Preserve claim-source mappings; annotate conflicts, don't pick one

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.6 (provenance & uncertainty in multi-source synthesis)
> **Scenario:** Multi-Agent Research System · **Study area:** Provenance & uncertainty (claim-source mappings, conflict annotation, temporal data)
> **Trap level:** 🟡 Medium — three plausible "resolve the conflict" moves, each loses provenance differently
> **Trap archetype:** Preserve provenance vs. flatten claims
> **Source:** Concept note grounded in the official exam guide, Task 5.6.

## 1. Topic — what this really tests
Summarization steps compress findings and silently drop the mapping between a claim and the source it came from. The architecture must force subagents to emit **structured claim-source mappings** (source URL/document name + the relevant excerpt) and require downstream agents to preserve and merge them through synthesis. When credible sources disagree, the system must **annotate the conflict with attribution** rather than arbitrarily reconciling it. Publication/collection **dates** must travel in the structured output so that values measured at different times are not misread as contradictions.

## 2. Question
> A coordinator delegates a market-size question to two document-analysis subagents. Source A (report dated 2023) reports the metric as $4.2B; Source B (report dated 2024) reports $5.1B. Both are credible. How should the document-analysis stage hand this off so the synthesis stage produces a trustworthy report?

## 3. Answer options
- **A.** Output both values with full source attribution and publication dates, explicitly annotate them as conflicting, and let the coordinator decide reconciliation; the report then separates well-established from contested findings. — ✅ **Correct**
- **B.** Pick the more recent value ($5.1B) and discard the older one, since newer data supersedes older data. — ⚠️ **Most common wrong answer**
- **C.** Average the two values ($4.65B) and report the single blended figure.
- **D.** Pick the higher value ($5.1B) so the report does not understate the opportunity, and drop the conflicting figure to keep the summary clean.

## 4. Correct answer — A
Provenance and dates must survive every compression step. The analysis stage's job is to surface conflicts **with attribution**, not to silently resolve them — reconciliation is a deliberate decision made downstream (coordinator/report), which can then distinguish well-established findings from contested ones. Carrying both dated values shows the apparent conflict may be a **temporal difference**, not a contradiction. Generalize: never silently reconcile; preserve claim-source mappings + dates through synthesis.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "pick the more recent value ($5.1B) and discard the older one."** It is seductive because dates genuinely do matter, so "newer supersedes older" feels like sound judgment rather than data loss. The tell that it's wrong: discarding the 2023 figure throws away a credible data point and hides the conflict instead of surfacing it — and the date difference is exactly what *interprets* the two values, not what licenses deleting one. The correct move keeps both dated values with attribution and lets the conflict be visible downstream, where reconciliation is a deliberate decision. Generalize to the archetype: the analysis stage preserves provenance and annotates uncertainty; it never flattens credible-but-conflicting claims into a single tidy number.

## 6. Distractor analysis — look-alikes to watch for
- **B (pick most recent):** Tempting because dates matter — but dates exist to *interpret* values, not to auto-discard one. Throws away a credible data point and hides the conflict.
- **C (average):** Fabricates a number no source reported, manufacturing false certainty and erasing both source characterizations and methodology.
- **D (pick higher / drop conflict):** Injects bias and destroys provenance; "clean summary" is exactly the summarization failure mode that loses attribution.

## 7. Key takeaways
- Require subagents to output **structured claim-source mappings** (source URL, document name, excerpt) and preserve them unbroken through synthesis.
- **Annotate conflicts with attribution**; let the coordinator/report reconcile — distinguish well-established vs contested findings explicitly.
- Carry **publication/collection dates** in structured output so temporal differences aren't misread as contradictions.
- Never average or silently drop credible-but-conflicting values — that fabricates certainty and loses information.
- **Render content types appropriately** in synthesis: financial data as tables, news as prose, technical findings as structured lists — don't flatten everything to one format.

## 8. Official documentation
- How we built our multi-agent research system — https://www.anthropic.com/engineering/multi-agent-research-system
- Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
