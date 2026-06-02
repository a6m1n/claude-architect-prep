# Aggregate accuracy hides segment failures — stratify and calibrate before automating

> **Domain:** D5 · Context Management & Reliability (15%) — Task 5.5 (human review & confidence calibration)
> **Scenario:** Structured Data Extraction · **Study area:** Human review & confidence calibration (stratified sampling, segment accuracy)
> **Trap level:** 🟡 Medium — three plausible "reduce review" moves, but only one segments and calibrates first
> **Trap archetype:** Stratified sampling vs. blanket review
> **Source:** Concept note grounded in the official exam guide, Task 5.5.

## 1. Topic — what this really tests
A single aggregate accuracy number (e.g., 97% overall) can mask systematic failure on a specific document type or field while the average stays high. Before reducing human review, you must analyze accuracy **by document type and by field segment** to confirm performance is consistent everywhere. Reliable routing also requires **field-level confidence scores calibrated against a labeled validation set**, so thresholds actually correspond to real error rates. Ongoing assurance uses **stratified random sampling** of high-confidence extractions to keep measuring error rates and surface novel error patterns.

## 2. Question
> An extraction pipeline parses invoices, contracts, and receipts, reporting 97% aggregate field accuracy. The team wants to cut human review to save reviewer capacity. What should they do first?
>
> - **A.** Analyze accuracy broken down by document type and field, and calibrate field-level confidence thresholds on a labeled validation set, before reducing review on any segment that proves consistently accurate.
> - **B.** Trust the 97% aggregate figure and automate all extractions, removing human review across every document type and field.
> - **C.** Replace human review with uniform random sampling of all extractions at a fixed rate, regardless of confidence or document type.
> - **D.** Send to humans only the extractions the model flags as low confidence, using the raw model scores directly without calibrating them against labeled data.

## 3. Answer options
- **A.** (correct) — segment the metric, calibrate confidence, then automate the proven segments. — ✅ **Correct**
- **B.** — blindly trusts the masked aggregate. — ⚠️ **Most common wrong answer**
- **C.** — samples uniformly instead of stratifying; inefficient and blind to segment risk.
- **D.** — routes on uncalibrated raw confidence.

## 4. Correct answer — A
A 97% average is an aggregate that can hide a document type or field performing far worse. The disciplined move is to **stratify the metric** — measure accuracy per document type and per field — and only reduce review on segments that demonstrably hold up. To route review attention you have the model emit **field-level confidence scores**, then **calibrate the thresholds on a labeled validation set** so a "high confidence" label maps to a known, acceptable error rate. Generalize: *segment before you automate, and calibrate confidence on labeled data.* After automating, keep **stratified random sampling** of high-confidence extractions running to detect drift and novel error patterns, and route low-confidence or ambiguous/contradictory documents to humans, prioritizing limited reviewer capacity.

## 5. Common mistake — the trap most people fall for
The most-picked wrong answer is **B — "trust the 97% aggregate and automate everything."** It is seductive because 97% reads as a single, authoritative pass-mark: if the headline number is high, removing review feels like a safe efficiency win. The tell that it's wrong: an aggregate is a *blend*, so a field or document type failing badly can sit hidden under the average while the masked segment gets silently automated. The correct move decomposes the metric first — measuring accuracy per document type and per field, calibrating confidence on labeled data, and reducing review only on segments that demonstrably hold up. This is the stratified-vs-blanket trap: acting on an un-decomposed number instead of measuring the worst segment before trusting any of them.

## 6. Distractor analysis — look-alikes to watch for
- **B (trust the aggregate):** the core trap — a high overall number says nothing about the worst segment, and a failing field could be silently automated. Never automate on an un-decomposed metric.
- **C (uniform sampling):** sampling is right, but flat random sampling wastes effort and can miss rare high-risk segments. Sampling for error-rate measurement should be **stratified** so each document-type/field segment is actually observed.
- **D (uncalibrated confidence):** using raw model confidence to gate review feels reasonable, but without calibration on a **labeled validation set** the threshold has no known relationship to real accuracy — "high confidence" may still be wrong often.

## 7. Key takeaways
- An aggregate accuracy figure can mask poor performance on a specific document type or field — decompose it before trusting it.
- Verify accuracy **by document type and field segment**; only reduce human review on segments proven consistently accurate.
- Calibrate **field-level confidence thresholds on a labeled validation set** so confidence maps to real error rates.
- Use **stratified random sampling** of high-confidence extractions for ongoing error-rate measurement and novel-pattern detection.
- Route **low-confidence or ambiguous/contradictory** extractions to humans, prioritizing limited reviewer capacity.

## 8. Official documentation
- Building effective agents — https://www.anthropic.com/engineering/building-effective-agents
- Prompt engineering overview — https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
