# 🗂 PROJECT-INDEX — the repo map

> **What this is:** the single index of the workspace. It describes the project tree — what lives where, what each file is, and why it exists. Start here to understand the structure fast.
>
> ⚠️ **Keep it current:** this file is the repository's map. Whenever you create / delete / rename / move a file or folder (or change a file's purpose), **update this index in the same change.** See the rule in `CLAUDE.md` → *Conventions* and the path-scoped rule `.claude/rules/project-index.md`.

---

## 🎯 The project in one line

A personal **study workspace** with one goal — **prepare the learner to pass the Claude Certified Architect – Foundations certification** (designing agentic architectures). It is **not a software project**: no build, lint, or tests. The "product" is teaching: explain concepts, drill questions, track progress. The exam: 60 MCQs, scaled 100–1000, pass mark **720**.

## 🧭 Where to start

| I want to… | Go to… |
|---|---|
| see the front door / how to use it | `README.md` |
| understand the whole project | **this file** |
| learn the theory topic by topic | `exam-prep/README.md` → `exam-prep/ROADMAP.md` |
| see exactly what the exam tests | `exam-notes/exam-topics-index.md`, `exam-notes/00-EXAM-GUIDE.md` |
| the source of truth | `exam-notes/00-EXAM-GUIDE.md` (in-repo distillation of Anthropic's official online exam guide) |
| how the tutor should behave | `CLAUDE.md` + `.claude/skills/` |

---

## 🌳 Tree (top level)

```
claude exam/
├── README.md              # front door: what this is, how to use it, links into the kit
├── CLAUDE.md              # always-on tutor instructions (role, principles, citation rule)
├── PROJECT-INDEX.md       # ← this file: the repo map
├── .claude/               # Claude Code config (the tutoring engine)
│   ├── skills/            #   8 skills = the teaching method, on demand (teach/quiz/mock/track)
│   ├── commands/          #   7 slash commands = thin launchers for the skills
│   ├── agents/            #   3 subagents = isolated-context jobs
│   ├── rules/             #   path-scoped rules (e.g. keep this index in sync)
│   ├── hooks/             #   bash hook (SessionStart "what's due" digest)
│   ├── settings.json      #   registers the hook
│   └── settings.local.json#   local per-machine override (git-ignored)
├── exam-prep/             # PRIMARY study kit: 1 task statement = 1 topic = 1 file (30 topics)
│   ├── README/ROADMAP/…   #   navigation + meta files
│   └── domain-1..5-*/     #   5 domain folders × topics N.N-*.md
└── exam-notes/            # REFERENCE layer + common-mistakes/ (tricky-case bank)
```

> 📌 Claude Code's per-project memory lives **outside** this tree, under `~/.claude/projects/<project-id>/memory/` (`MEMORY.md` + fact files).

---

## 📁 Root files

| Path | What / why |
|---|---|
| `README.md` | The front door: what the project is, how it works (slash commands), what it covers, getting started, and links into the kit. Points to this index for the full map. |
| `CLAUDE.md` | Always-on project instructions, loaded every session: the tutor role, the non-negotiable learning-science principles, the skill/command map, the "always cite official docs" rule, the exam structure, and the materials map. |
| `PROJECT-INDEX.md` | This index — the repository map. |
| `.gitignore` | Excludes macOS cruft (`.DS_Store`), IDE config (`.idea/`), local Claude Code settings (`.claude/settings.local.json`), and personal progress (`exam-notes/progress.json`). |

---

## ⚙️ `.claude/` — Claude Code config (the tutoring engine)

> This is harness config: it changes how Claude Code behaves, not the study content.

### `.claude/skills/` — the teaching method, on demand (8 skills)

Each skill is a folder with a `SKILL.md` (and sometimes a `reference.md` with the details). This is the "how to teach": deliver material in a structure and make hard things simple.

| Skill | Purpose | Launch | reference.md |
|---|---|---|---|
| `deep-teach/` | Teach-FIRST lesson: theory + everyday analogy → breakdown of past mistakes → 🚩 trap-detector + cheat-sheet → 1 retrieval question | `/teach` | — |
| `exam-tutor/` | Adaptive teach→quiz→feedback session, interleaved, weighted to weak/heavy domains → toward 720 | `/tutor` | ✅ |
| `quiz-me/` | Fresh MCQs one at a time, retrieval-first, feedback with citations | `/quiz` | ✅ |
| `question-generator/` | One fresh MCQ on any topic, on demand | `/generate` | — |
| `mock-exam/` | Full simulation: 4 of 6 scenarios, 60 questions by weight, score 100–1000, verdict vs 720 | `/mock` | ✅ |
| `progress-tracker/` | **The only writer of `progress.json`**: mastery, spaced repetition (SM-2 + Leitner), readiness | `/due`, `/readiness` | ✅ |
| `teaching-method/` | The "WHY we teach this way" playbook (retrieval, spacing, interleaving, calibration) — the reference for the other skills | — (on demand) | ✅ |
| `web-research/` | Web research on external docs/SDKs before citing them | — (as a tool) | — |

### `.claude/commands/` — slash commands (7, thin launchers)

| Command | Launches skill | Model-invokable? |
|---|---|---|
| `/teach` | deep-teach | yes |
| `/tutor` | exam-tutor | yes |
| `/quiz` | quiz-me | yes |
| `/generate` | question-generator (topic) | yes |
| `/mock` | mock-exam | **no** (`disable-model-invocation: true`, manual only) |
| `/due` | progress-tracker → what to review | **no** (manual only) |
| `/readiness` | progress-tracker → readiness score | **no** (manual only) |

### `.claude/agents/` — subagents (3, isolated context, read-only)

| Agent | Job | Tools | Model |
|---|---|---|---|
| `answer-checker.md` | Independent 2nd-opinion grading of an MCQ — gets **only** the stem + options, never the author's key | Read, Grep, Glob, WebFetch | inherit |
| `doc-verifier.md` | Confirms cited doc links resolve to a canonical official host (PASS/FAIL) | WebFetch | haiku |
| `question-author.md` | Batch-generates MCQs from the local notes in isolation (keeps the main context clean) | Read, Glob, Grep | inherit |

> All three are read-only and write no files; `answer-checker` deliberately never sees the correct answer (it dogfoods the exam principle "independent verification beats self-checking").

### `.claude/rules/` — path-scoped rules

| File | What it does |
|---|---|
| `project-index.md` | A rule with frontmatter `paths: ["**/*"]`: while working with project files, it reminds you to update `PROJECT-INDEX.md` on add/remove/rename/move or a changed purpose. Loaded as context (not enforcement) — the deliberate counterpart to a hook, because the update needs judgment. |

### `.claude/hooks/` + settings

| File | What it does |
|---|---|
| `hooks/due-today.sh` | **SessionStart** hook: prints a read-only "what's due today" digest (via `jq` over `progress.json`), degrading gracefully if the tracker is uninitialized or `jq` is missing. Its stdout is injected into the session context. |
| `settings.json` | Registers the SessionStart hook (→ `due-today.sh`). |
| `settings.local.json` | Local per-machine override; currently empty (`{}`). |

---

## 📘 `exam-prep/` — the primary study kit

Principle: **1 task statement from the official blueprint = 1 topic = 1 file** (30 topics, 1.1–5.6). Questions and options stay in the exam register; theory and rationales are written in plain language; terms / flags / paths go in `code`.

### Navigation + meta files

| File | Why |
|---|---|
| `README.md` | Kit hub: exam numbers, domain weights, **the full index of 30 topics**, how to use the method. |
| `ROADMAP.md` | The simple path through the hard topics (lever-ladder, 5 analogy anchors, 🚩 detectors, spacing calendar). **Start here.** |
| `STUDY-PLAN.md` | Phased plan: what to learn in what order, readiness checkpoints. |
| `SCENARIOS.md` | The 6 exam scenarios (the exam shows 4 of 6) × domains. |
| `GLOSSARY.md` | Exam-day cheat-sheet: flags, files, terms, one line each. |
| `AUDIT.md` | QA report on the kit: correctness, coverage, plain-language clarity + what was fixed. |
| `_TEMPLATE-topic.md` | Template for a new topic (strict section order — see below). |

### 5 domain folders (each with its own `README.md`)

| Folder | Domain | Weight | Topics |
|---|---|---|---|
| `domain-1-agentic-architecture/` | D1 — Agentic Architecture & Orchestration | **27%** 🔝 | 1.1–1.7 (7) |
| `domain-2-tool-design-mcp/` | D2 — Tool Design & MCP Integration | 18% | 2.1–2.5 (5) |
| `domain-3-claude-code-config/` | D3 — Claude Code Config & Workflows | 20% | 3.1–3.6 (6) |
| `domain-4-prompt-engineering/` | D4 — Prompt Engineering & Structured Output | 20% | 4.1–4.6 (6) |
| `domain-5-context-reliability/` | D5 — Context Management & Reliability | 15% | 5.1–5.6 (6) |

### Anatomy of a topic file (`domain-*/N.N-slug.md`, 30 of them)

Strict section order: **⚡ TL;DR → 🧠 In plain words** (analogy + 🚩 detector) **→ 📘 Theory → ⚠️ Traps and distractors → 🔑 Remember → 📝 Practice** (3–4 MCQs of rising difficulty + **1 tricky `**` question** at the end) **→ 🔗 Official documentation** (links verified via WebFetch). Focused size (~110–180 lines).

---

## 📝 `exam-notes/` — reference layer + distractor bank

The earlier notes layer that `exam-prep/` was built from.

| Path | Why |
|---|---|
| `00-EXAM-GUIDE.md` | Authoritative distillation of the official guide: domains + weights, the 6 scenarios, the task-statement outline, sample questions, gap map. |
| `INDEX.md` | Registry of all 43 `common-mistakes/` cases (domain · scenario · trap level · file) + cross-cutting themes. Flags 🔴 High-trap / 🟡 Medium = distractor difficulty (**not** a personal score; personal history lives in `progress.json`). |
| `exam-topics-index.md` | Compact scope navigator: exactly what each task statement 1.1–5.6 tests. |
| `learned-rules.md` | **Principle cheat-sheet** (de-personalized for the public repo): rules worked out in tutoring sessions + how to catch their traps on the exam. |
| `useful-links.md` | External prep resources: 1 official practice exam (Skilljar) + 4 third-party (question banks / mock / anti-pattern cheat-sheet). Deduplicated by domain; each tagged 🟢 official / 🔵 third-party with a "when it helps" phase. |
| `common-mistakes/` (43 + `README.md`) | **The tricky-case bank of common mistakes.** 43 notes in a unified `dN-<slug>.md` naming: 24 scenario case studies + 14 concept gap-fills + 5 official sample questions. Each has 8 sections; the focus is de-personalized — §5 "Common mistake" = the trap most people fall for (not a personal choice), and the header carries Domain · Trap level · Trap archetype · Source. `README.md` is the per-domain index. |

> ⚠️ `exam-notes/progress.json` (mastery + review schedule; written only by `progress-tracker`) **does not exist yet** — the tracker is uninitialized, so the SR system and the SessionStart digest are inactive for now. It is created by `progress-tracker init`.

---

## 🗃 Other

| Path | Why |
|---|---|
| `~/.claude/projects/<project-id>/memory/` | Claude Code's per-project memory, **outside** this tree: `MEMORY.md` (index) + fact files. Persists facts across sessions. |

---

## 🔢 Summary

| Entity | Count |
|---|---|
| exam-prep topics (`N.N-*.md`) | **30** (across 5 domains) |
| skills / commands / subagents / hooks / rules | 8 / 7 / 3 / 1 / 1 |
| exam-notes: reference files / common-mistakes cases (+README) | 5 / 43 (+1) |

## 📐 Key conventions

1. **Always cite official docs** (`code.claude.com` / `platform.claude.com` / Anthropic's official exam guide); verify each URL with WebFetch.
2. **`progress.json` is written only by `progress-tracker`.**
3. **Keep this index in sync** with the project tree (see the header + `CLAUDE.md`).
