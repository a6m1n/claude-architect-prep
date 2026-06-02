---
description: Compute the exam-readiness score on the 100–1000 scale versus the 720 pass bar, and rank the domains by recoverable points so study time goes where it matters most.
argument-hint: ""
disable-model-invocation: true
---
Use the `progress-tracker` skill (`readiness`) to compute the scaled score (100–1000) vs the 720 pass bar from recorded data, then rank domains by `weight × (1 − mastery)` (expected points recoverable) and surface the top 2–3 to focus next.

If `exam-notes/progress.json` does not exist yet, say so and offer to run `progress-tracker init`.
