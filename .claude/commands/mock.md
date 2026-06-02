---
description: Run a full timed exam simulation — sample 4 of 6 scenarios, distribute fresh MCQs across the five domains by official weighting, score on the 100–1000 scale, and return a PASS/NOT-YET verdict vs 720 plus a ranked study plan.
argument-hint: ""
disable-model-invocation: true
---
Use the `mock-exam` skill to run a full simulation under test conditions: retrieval-first, unanswered = wrong, no mid-exam feedback. Afterward, report the scaled score vs the 720 pass bar, a per-domain breakdown, and a ranked study plan, then bulk-record results via `progress-tracker`.
