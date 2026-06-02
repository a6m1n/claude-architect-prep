# 📅 Study plan — Claude Certified Architect · Foundations

Goal: pass the **720/1000** bar with room to spare. Strategy = domain weight × your weakness. The order below reflects the official weights and the topics that trip people up most often (per `../exam-notes/INDEX.md`).

> The method is based on learning science: **retrieval practice, spaced repetition, interleaving, desirable difficulties** (more in the `teaching-method` skill). The key rule: answer each MCQ BEFORE the answer is revealed.

---

## 🎯 Priorities (where to spend time first)

**Weight rule:** D1 (27%) + D3 (20%) + D4 (20%) = **67%** of the exam → put the main time budget here.

**High-payoff cross-cutting topics** (they recur across scenarios — learn these first):
1. **Tool distribution / least privilege** — 2.1, 2.3, 1.3 *(frequent misses)*
2. **Error propagation in multi-agent** — 5.3, 2.2, 1.2
3. **Determinism vs probabilistic** — 1.4, 1.5 (hooks/gates instead of a prompt)
4. **Context engineering** — 5.1 (durable facts, lost-in-the-middle), 5.4, 5.6
5. **Match workload to mechanism** — 4.5 (batch vs sync), 1.6 (chaining vs adaptive)
6. **Root cause over symptom** — 1.2 (decomposition, not a subagent), 2.1 (description, not few-shot)

---

## 🗓 Phased route (≈ 5 working sessions)

### Phase 0 — Map (30 min)
- Read [`README.md`](README.md), [`SCENARIOS.md`](SCENARIOS.md), [`GLOSSARY.md`](GLOSSARY.md).
- Run the official 12 sample questions from the exam guide (Sample Questions section) "cold" — that is your baseline.

### Phase 1 — D1 Agentic Architecture (27%) · core
Order: **1.1 → 1.2 → 1.4 → 1.3 → 1.6 → 1.5 → 1.7**
- 1.1 `stop_reason` control flow · 1.2 hub-and-spoke + narrow decomposition · 1.4 programmatic prerequisites · 1.3 explicit context handoff + parallel `Task`.
- Checkpoint: explain "why a prompt instruction does not guarantee call order, but a gate does."

### Phase 2 — D3 Claude Code Config (20%)
Order: **3.4 → 3.2 → 3.1 → 3.3 → 3.6 → 3.5**
- Learn the location/scope differences: `.claude/commands` vs `~/.claude/commands`; project vs user CLAUDE.md; `.claude/rules` globs; skills (on-demand) vs CLAUDE.md (always-loaded); `-p`/`--output-format json`.
- Checkpoint: for each of sample Q4/Q5/Q6/Q10, name the correct answer and why the others are wrong.

### Phase 3 — D4 Prompt Engineering & Structured Output (20%)
Order: **4.3 → 4.4 → 4.1 → 4.2 → 4.5 → 4.6**
- 4.3 `tool_use`+schema (syntax ≠ semantic) · 4.4 retry is useless if the data is NOT in the source · 4.5 batch only for latency-tolerant · 4.6 independent review > self-review.
- Checkpoint: "schema guarantees syntax, but NOT semantics" — give an example of a semantic error.

### Phase 4 — D2 Tool Design & MCP (18%)
Order: **2.1 → 2.3 → 2.2 → 2.4 → 2.5**
- 2.1 description is the primary signal (expanding the description = a cheap first step) · 2.3 least privilege + `tool_choice` auto/any/forced · 2.2 `errorCategory`/`isRetryable` · 2.4 `.mcp.json` vs `~/.claude.json` + `${ENV}`.

### Phase 5 — D5 Context & Reliability (15%)
Order: **5.3 → 5.1 → 5.2 → 5.6 → 5.4 → 5.5**
- 5.1 durable "case facts" vs lossy summary + lost-in-the-middle · 5.3 structured error-context, access-failure ≠ empty · 5.2 escalate on policy-gap, not on sentiment.

### Phase 6 — Simulation and shoring up the weak spots
- Run **mock-exam** (skill) → you get a scaled score and a ranked list of weak topics.
- Go back to the 🔴 topics from the result; re-read only the "⚠️ Traps" section + re-solve the tricky questions.

---

## 🔁 Spaced repetition (how to come back)

| Topic result | When to return |
|---|---|
| 🔴 missed / guessed | next session (in ~1 day) |
| 🟡 correct, but unsure | in 2–3 days |
| 🟢 correct and confident | in ~1 week |

Confident-but-wrong is the most expensive miss: bring those topics back first. Calibrate your confidence before every answer.

## ✅ Readiness checkpoints (720)

- [ ] All 12 official sample questions — correct and with an explanation of "why the others are wrong."
- [ ] The `**` tricky question in each file — solved cold.
- [ ] Mock-exam ≥ **750** under honest conditions (no peeking, unanswered = wrong).
- [ ] For each cross-cutting principle (the 6 above) you can name ≥2 topics where it is tested.
- [ ] You confidently tell apart the "paired traps": Grep↔Glob · auto↔any↔forced · project↔user scope · access-failure↔empty-result · syntax↔semantic · batch↔sync · plan↔direct.

## 🧰 Workspace tools

- **exam-tutor** — adaptive session (teach → quiz → feedback), weighted toward weak/heavy domains.
- **quiz-me** — one fresh MCQ on a topic of your choice.
- **mock-exam** — full 60-question simulation + a 100–1000 score + a plan.
- **progress-tracker** — what to review (`due`/`weak`) and current readiness.
- **Official prep exercises** (from the exam guide, Preparation Exercises section) — build real mini-projects: multi-tool agent, Claude Code team config, extraction pipeline, multi-agent research. Hands-on practice sticks better than reading.
