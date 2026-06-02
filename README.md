# Claude Certified Architect – Foundations · Study Workspace

A self-study workspace that turns **[Claude Code](https://code.claude.com)** into a personal tutor for the **Claude Certified Architect – Foundations** certification (designing agentic architectures). It is not a software project — there is no build, lint, or test step. The "product" is the tutoring: explain a concept, quiz it, track mastery, and drive readiness toward the **720 / 1000** pass bar.

## How it works

Open this folder in Claude Code. The tutor's behavior lives in **[`CLAUDE.md`](CLAUDE.md)** (always-on principles) and the on-demand skills under [`.claude/skills/`](.claude/skills). You drive a session with slash commands — each is a thin launcher for a skill:

| Command | What it does |
|---|---|
| `/teach <topic>` | Teach-first deep lesson: plain-language theory + an everyday analogy, then a breakdown of your past mistakes |
| `/tutor` | Adaptive teach → quiz session, interleaved and weighted toward weak + high-weight domains |
| `/quiz <topic \| due \| weak>` | One retrieval-first MCQ, then elaborated, doc-cited feedback |
| `/generate <topic>` | A single fresh exam-style question on demand |
| `/mock` | Full timed simulation, scored 100–1000 against the 720 bar |
| `/due` · `/readiness` | What's due for review · current readiness score |

Spaced-repetition state lives in `exam-notes/progress.json` (created on first run by the `progress-tracker` skill; it is personal and git-ignored).

## What it covers

The exam's five domains and six scenarios. The authoritative distillation is **[`exam-notes/00-EXAM-GUIDE.md`](exam-notes/00-EXAM-GUIDE.md)**; the full task-statement breakdown (1.1–5.6) is the study kit in **[`exam-prep/`](exam-prep/README.md)**.

| Domain | Weight |
|---|---|
| D1 — Agentic Architecture & Orchestration | 27% |
| D2 — Tool Design & MCP Integration | 18% |
| D3 — Claude Code Config & Workflows | 20% |
| D4 — Prompt Engineering & Structured Output | 20% |
| D5 — Context Management & Reliability | 15% |

## Getting started

1. Install Claude Code and open this folder.
2. New here? Start with the roadmap — **[`exam-prep/ROADMAP.md`](exam-prep/ROADMAP.md)**.
3. Run `/tutor` for a guided session, or `/teach <topic>` to learn one concept first.

## Repository layout

See **[`PROJECT-INDEX.md`](PROJECT-INDEX.md)** for the full map (every file and what it is for). At a glance:

- **[`exam-prep/`](exam-prep/README.md)** — the primary study kit: one file per task statement with theory, traps, and practice MCQs. Add a topic from [`exam-prep/_TEMPLATE-topic.md`](exam-prep/_TEMPLATE-topic.md).
- **[`exam-notes/`](exam-notes/INDEX.md)** — reference notes plus the `common-mistakes/` bank of tricky cases (each focuses on the trap most people fall for).
- **[`.claude/`](.claude)** — the Claude Code configuration that powers the tutor (skills, commands, agents, rules, hook).

## Contributing

Add a topic by copying [`exam-prep/_TEMPLATE-topic.md`](exam-prep/_TEMPLATE-topic.md). When you add, remove, rename, or move files, keep [`PROJECT-INDEX.md`](PROJECT-INDEX.md) in sync (the rule in [`.claude/rules/project-index.md`](.claude/rules/project-index.md) explains why). Every exam claim must cite an official source.

## License

The original study materials in this repository are licensed under **[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)** — use and adapt them freely, with attribution. See [`LICENSE`](LICENSE) for the full terms and scope.

## Disclaimer

An unofficial, community study aid. **Claude** and the **Claude Certified Architect** certification are products of **Anthropic**; this project is not affiliated with or endorsed by Anthropic. This repository does not bundle or redistribute Anthropic's materials — for the authoritative source, see [Anthropic Academy](https://www.anthropic.com/learn). The notes here are an independent, derived distillation; review Anthropic's terms before relying on them.
