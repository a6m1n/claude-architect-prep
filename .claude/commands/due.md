---
description: Show what is due for spaced-repetition review today and the weakest items to study next.
argument-hint: ""
disable-model-invocation: true
---
Use the `progress-tracker` skill (`next`) to list the concepts due today (`next_due` ≤ today), interleaved across domains and biased toward 🔴 and low-mastery items in high-weight domains. For any concept that also has a block in `exam-notes/learned-rules.md`, remind the user to re-read it.

If `exam-notes/progress.json` does not exist yet, say the tracker is not initialized and offer to run `progress-tracker init` first.
