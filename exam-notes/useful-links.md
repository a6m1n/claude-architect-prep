# Useful links for prep — Claude Certified Architect (Foundations)

External resources for certification prep. The list is **deduplicated by domain** — one unique domain = one entry.

> ⚠️ **Only one source is official** (`anthropic.skilljar.com`). The rest are third-party community projects, **not affiliated with Anthropic**. Cross-check any fact from them against authoritative sources ([`00-EXAM-GUIDE.md`](00-EXAM-GUIDE.md), `code.claude.com`, `platform.claude.com`) before you commit it to memory. Do not cite third-party sites as a source of truth.

## Quick table

| Resource | What it is | Status | Access | When it's useful |
|--------|---------|--------|--------|---------------|
| [anthropic.skilljar.com](https://anthropic.skilljar.com/anthropic-certification-practice-exam/425721/scorm/9tk8iybcpyl9) | Official practice exam (SCORM module) | 🟢 **Official** (Anthropic) | Login required (free Skilljar account) | Final rehearsal before the exam |
| [claudecertificationguide.com](https://claudecertificationguide.com/) | Study hub: lessons + question bank + diagnostics + mock | 🔵 Third-party | Free, no registration | Early–mid phase (learn + drill), mock at the end |
| [certsafari.com](https://www.certsafari.com/anthropic/claude-certified-architect) | Bank of practice questions (~630 MCQ) | 🔵 Third-party | Free (on the landing page) | Mid–late phase: volume of retrieval practice across all domains |
| [claudecertifications.com/.../anti-patterns](https://claudecertifications.com/claude-certified-architect/anti-patterns) | Cheat-sheet of anti-patterns / distractors (by domain) | 🔵 Third-party | Free, no registration | Late phase: trap recognition before the mock |
| [claude-cert-arch-guide.moisesprat.dev](https://claude-cert-arch-guide.moisesprat.dev/exam) | Personal guide + exam simulator (progress in the browser) | 🔵 Third-party (personal project) | Free, progress stored locally | Mid–late phase: fresh scenario questions and mock reps |

---

## In more detail

### 🟢 anthropic.skilljar.com — official practice exam
**What it covers:** the official Claude Certified Architect practice exam, packaged as a SCORM module on Anthropic's learning platform (`anthropic.skilljar.com` is Anthropic's platform; Skilljar is only the LMS vendor). This is the **only official** resource in the list and the closest proxy to the real exam.
**Access:** login required (a free Skilljar account is enough; an Anthropic account is not needed; no payment seen). The content sits behind the login — the exact format (60 questions / 720 pass mark) cannot be confirmed without logging in.
**When it's useful:** **final readiness check / format rehearsal** closer to the exam date — *after* you have learned the concepts and worked through the domains (`/teach`, `/tutor`, `/quiz`). It complements the local `/mock`: `/mock` is for repeatable scaled simulations throughout your prep, while this one is for the "dress rehearsal" right before the exam.

### 🔵 claudecertificationguide.com — study hub + mock
**What it covers:** a free third-party hub built specifically for this exam. It mirrors the official structure (the same 5 domains with weights D1 27% / D2 18% / D3 20% / D4 20% / D5 15%, 720/1000 pass mark): ~30 lessons, 150+ practice questions, diagnostics, flash-card cheat-sheets, and a full timed mock (`/mock-exam/start`: ~24–28 MCQ, 4 of 6 scenarios, 60-minute timer, scale up to 1000).
**Access:** fully free, no registration. Stated as an "independent community resource — not affiliated with Anthropic".
**When it's useful:** lessons/practice/cards — early–mid phase (learn and drill in parallel with `exam-prep/`); the built-in mock — late phase, to check whether you clear the 720 pass mark under timed conditions.
**Note on deduplication:** the source list had two links for this domain (the home page and `/mock-exam/start`). The **home page** was kept — it is the entry point, leads to all content including the mock; a bare deep-link to "Start Exam" would lose the lessons/bank/cards and breaks more easily.

### 🔵 certsafari.com — question bank
**What it covers:** a third-party bank of CCA-F practice questions (~630 MCQ) with a random/mixed selection mode, a domain filter, and attempt history. It correctly reflects the exam frame (720/1000, scenario MCQs, audience of 6+ months of experience).
**Access:** the public landing page has no login or payment (main CTA "Start Practicing"); a gate deeper in the flow can't be ruled out. Footer: "not affiliated with … Anthropic".
**When it's useful:** mid–late phase, once the concepts are already learned — **large volume of retrieval practice and interleaving** across all five domains, exposure to different phrasings. A supplement to `/quiz` and `/mock`, not a replacement. Not suited for initial learning or as an authoritative fact-check.

### 🔵 claudecertifications.com/anti-patterns — trap cheat-sheet
**What it covers:** a free cheat-sheet of "common wrong answers / distractors", grouped by the 5 domains (~18 items): D1 — parsing NL for loops, no iteration limit, enforcement via prompt, escalation by sentiment; D2 — generic error messages, silently empty results, too many tools per agent, hardcoded keys; D3 — personal settings in team configs, commands-vs-skills confusion, self-verification in the same session; D4 — vague instructions, incorrect use of `tool_use`, generic retry messages; D5 — losing important details in summarization, aggregate-only metrics, no provenance.
**Access:** fully free, no registration. There's no explicit "not affiliated", but it is not Anthropic either.
**When it's useful:** late phase — **practicing trap recognition** exactly along our recurring themes (least privilege, error propagation, determinism-vs-prompting, context engineering, root-cause). Good for a quick review of "why a wrong answer looks tempting" before the mock. Workflow: skim through → run unfamiliar traps through a cross-checked `/teach`/`/quiz` → record the confirmed rule in [`learned-rules.md`](learned-rules.md). Not suited for first learning a concept.

### 🔵 claude-cert-arch-guide.moisesprat.dev — guide + simulator
**What it covers:** a free community guide and exam simulator (author Moises Prat, a personal project). It covers all 5 domains / 30 task statements, has an "Exam Simulation" section with scenario questions, and a progress page (domain scores and attempt history are stored locally in the browser, no account).
**Access:** no registration or payment, progress stored locally. Marked "Community study resource · Not affiliated with Anthropic". The exact simulator parameters (number of questions, timing, scale) are not confirmed — the section is rendered via JS.
**When it's useful:** mid–late phase, once the concepts are already learned — an extra source of **fresh scenario questions and mock reps**, to probe readiness and surface weak domains. Weakly suited as a primary learning source (unofficial, no links to sources).
