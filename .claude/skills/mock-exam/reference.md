# mock-exam reference

Blueprint tables, scoring worked example, and official-doc citations for the
`mock-exam` skill. The skill body lives in `SKILL.md`; open this only when you
need exact counts, the scoring example, or a citation URL.

## Contents

- [Domains & weights](#domains--weights)
- [Scenarios (sample 4 of 6)](#scenarios-sample-4-of-6)
- [Question-count blueprint](#question-count-blueprint)
- [Scoring worked example](#scoring-worked-example)
- [Readiness bands](#readiness-bands)
- [progress.json record shape](#progressjson-record-shape)
- [Official docs by domain](#official-docs-by-domain)

## Domains & weights

| Domain | Name | Weight | Task statements |
| --- | --- | --- | --- |
| D1 | Agentic Architecture & Orchestration | 27% | 1.1–1.x |
| D2 | Tool Design & MCP Integration | 18% | 2.1–2.x |
| D3 | Claude Code Configuration & Workflows | 20% | 3.1–3.x |
| D4 | Prompt Engineering & Structured Output | 20% | 4.1–4.x |
| D5 | Context Management & Reliability | 15% | 5.1–5.6 |

Weights sum to 100%. Exact task statements (1.1–5.6) are in
`exam-notes/00-EXAM-GUIDE.md`.

## Scenarios (sample 4 of 6)

The real exam presents 4 of these 6 at random — do the same each run:

1. Customer Support Resolution Agent
2. Code Generation with Claude Code
3. Multi-Agent Research System
4. Developer Productivity with Claude  *(coverage gap — emphasize when sampled)*
5. Claude Code for Continuous Integration
6. Structured Data Extraction  *(coverage gap — emphasize when sampled)*

## Question-count blueprint

`count = round(weight × total)`; if rounded counts do not sum to `total`, give
the leftover (±) to the highest-weight domain (D1) so the sum is exact.

### 20-question short mock (default)

| Domain | Weight | round(weight×20) | Final |
| --- | --- | --- | --- |
| D1 | 27% | 5.4 → 5 | **5** |
| D2 | 18% | 3.6 → 4 | **4** |
| D3 | 20% | 4.0 → 4 | **4** |
| D4 | 20% | 4.0 → 4 | **4** |
| D5 | 15% | 3.0 → 3 | **3** |
| **Total** | 100% | 20 | **20** |

### 60-question full-length

| Domain | Weight | round(weight×60) | Final |
| --- | --- | --- | --- |
| D1 | 27% | 16.2 → 16 | **16** |
| D2 | 18% | 10.8 → 11 | **11** |
| D3 | 20% | 12.0 → 12 | **12** |
| D4 | 20% | 12.0 → 12 | **12** |
| D5 | 15% | 9.0 → 9 | **9** |
| **Total** | 100% | 60 | **60** |

For any other `total`, compute each domain's `round(weight × total)`, then
reconcile to `total` by adjusting D1.

## Scoring worked example

Shared formula (owned by [[progress-tracker]]):

- `mastery = (correct + 1) / (attempts + 2)` per concept.
- `domain_mastery = mean(concept masteries)` within a domain.
- `overall = Σ (weightᵈ × domain_masteryᵈ)`.
- `scaled = round(100 + overall × 900)`; **pass if scaled ≥ 720.**
- Rank weak areas by `weight × (1 − mastery)`.

**Example — 20Q mock, results by domain:**

| Domain | Weight | Correct/Total | domain_mastery* | weight × mastery | Contribution (×900) | weight×(1−mastery) |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | 0.27 | 3/5 | 0.571 | 0.154 | 138.8 | 0.116 |
| D2 | 0.18 | 3/4 | 0.667 | 0.120 | 108.1 | 0.060 |
| D3 | 0.20 | 2/4 | 0.500 | 0.100 | 90.0 | 0.100 |
| D4 | 0.20 | 3/4 | 0.667 | 0.133 | 120.0 | 0.067 |
| D5 | 0.15 | 3/3 | 0.800 | 0.120 | 108.0 | 0.030 |
| **Σ** | 1.00 | 14/20 | — | **0.627** | **564.9** | — |

\* Using `(correct + 1) / (attempts + 2)` at the domain level for a quick
estimate; for finer detail compute per-concept then average.

- `overall ≈ 0.627` → `scaled = round(100 + 0.627 × 900) = round(664.6) = 665`.
- 665 < 720 → **NOT-YET** (and below the 760 safety target).
- Ranked weak high-weight areas: **D1 (0.116) > D3 (0.100) > D4 (0.067)** →
  study D1 first, then D3.

(Raw 14/20 = 70% maps to a scaled 665 here — confirming raw % is not the score.)

## Readiness bands

| Scaled score | Verdict | Guidance |
| --- | --- | --- |
| ≥ 760 | PASS (comfortable) | Ready; maintain with periodic drills. |
| 720–759 | PASS (borderline) | Sampling variance risk — drill weak domains, re-mock before booking. |
| < 720 | NOT-YET | Follow the study plan; re-mock after closing top-ranked gaps. |

## progress.json record shape

Append (do not overwrite) one entry per administered item via [[progress-tracker]]
conventions, e.g.:

```json
{
  "ts": "2026-05-31T00:00:00Z",
  "source": "mock-exam",
  "domain": "D1",
  "concept": "subagent-orchestration",
  "scenario": "Multi-Agent Research System",
  "correct": false
}
```

The mock contributes attempts that the spaced-repetition schedule consumes.

## Official docs by domain

Cite the relevant URL in the rationale of every missed question.
(docs.claude.com redirects to these canonical hosts.)

**D1 — Agentic Architecture & Orchestration**
- https://code.claude.com/docs/en/agent-sdk/overview
- https://code.claude.com/docs/en/agent-sdk/subagents
- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/hooks
- https://code.claude.com/docs/en/agent-sdk/sessions
- https://platform.claude.com/docs/en/build-with-claude/tool-use/overview
- https://www.anthropic.com/engineering/building-effective-agents

**D2 — Tool Design & MCP Integration**
- https://www.anthropic.com/engineering/writing-tools-for-agents
- https://platform.claude.com/docs/en/build-with-claude/tool-use/implement-tool-use
- https://modelcontextprotocol.io/docs/getting-started/intro
- https://code.claude.com/docs/en/mcp
- https://modelcontextprotocol.io/specification/2025-06-18/server/tools

**D3 — Claude Code Configuration & Workflows**
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/slash-commands
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/permission-modes
- https://code.claude.com/docs/en/headless
- https://code.claude.com/docs/en/cli-reference

**D4 — Prompt Engineering & Structured Output**
- https://platform.claude.com/docs/en/build-with-claude/structured-outputs
- https://platform.claude.com/docs/en/build-with-claude/tool-use/implement-tool-use
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/multishot-prompting
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview

**D5 — Context Management & Reliability**
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/long-context-tips
- https://platform.claude.com/docs/en/build-with-claude/batch-processing
- https://platform.claude.com/docs/en/build-with-claude/prompt-caching
- https://platform.claude.com/docs/en/build-with-claude/context-windows
- https://code.claude.com/docs/en/costs
