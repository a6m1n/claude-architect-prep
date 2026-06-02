# D4 · Prompt Engineering & Structured Output — 20%

About precise criteria, few-shot, guaranteed structured output and its validation, batch processing, multi-pass review.

← [Back to hub](../README.md) · [Plan](../STUDY-PLAN.md) · [Glossary](../GLOSSARY.md)

**Cross-cutting domain principle:** specificity wins. Explicit categorical criteria > vague instructions; `tool_use`+schema removes syntax, but not semantics; match the mechanism to the workload (batch vs sync, retry only when the data exists in the source).

## Topics
| # | Topic | One-line gist |
|---|---|---|
| [4.1](4.1-explicit-criteria-false-positives.md) | Explicit criteria | Categorical criteria > "be conservative"; turn off noisy categories |
| [4.2](4.2-few-shot-prompting.md) | Few-shot | 2–4 targeted examples for format/ambiguous/generalization |
| [4.3](4.3-structured-output-tooluse.md) | Structured output | `tool_use`+schema removes syntax, NOT semantics; nullable against fabrication |
| [4.4](4.4-validation-retry-loops.md) | Validation & retry | Add the specific error; retry is useless if the data isn't in the source |
| [4.5](4.5-batch-processing.md) | Batch processing | ~50% cheaper, ≤24h, no SLA, no multi-turn tools; latency-tolerant only |
| [4.6](4.6-multipass-review.md) | Multi-pass review | Independent instance > self-review; per-file + cross-file pass |

**Scenarios:** CI/CD (5), Structured Data Extraction (6), Customer Support (1).
