# D5 · Context Management & Reliability — 15%

About keeping critical information in a long context, escalation, error propagation, exploring large codebases, calibration, and provenance.

← [Back to hub](../README.md) · [Plan](../STUDY-PLAN.md) · [Glossary](../GLOSSARY.md)

**Cross-cutting principle of the domain:** context engineering and honesty about uncertainty. Durable facts instead of lossy summaries; structured error context instead of "operation failed"; tell "I don't know / no data" apart from "empty / error"; keep provenance and dates through synthesis.

## Topics
| # | Topic | One-line gist |
|---|---|---|
| [5.1](5.1-conversation-context.md) | Conversation context | "case facts" block outside the summary; lost-in-the-middle → front-load + headers; trim outputs |
| [5.2](5.2-escalation-ambiguity.md) | Escalation & ambiguity | Escalate on a human's request / policy gap / no progress; sentiment is a poor proxy |
| [5.3](5.3-error-propagation.md) | Error propagation | Structured context (type/query/partial/alt); don't silence it and don't kill the whole workflow |
| [5.4](5.4-large-codebase-context.md) | Large-codebase context | Scratchpads, subagent delegation, manifest for recovery, `/compact` |
| [5.5](5.5-human-review-calibration.md) | Human review & calibration | Aggregate masks segments; stratified sampling; field-level confidence |
| [5.6](5.6-provenance-uncertainty.md) | Provenance & uncertainty | Claim-source through synthesis; conflict → attribution; require dates |

**Scenarios:** Customer Support (1), Multi-Agent Research (3), Structured Data Extraction (6), Developer Productivity (4).
