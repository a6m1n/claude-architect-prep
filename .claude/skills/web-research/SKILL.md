---
name: web-research
description: Researches external libraries, frameworks, SDKs, protocols,
  or services on the web (official docs, GitHub CHANGELOG/source/releases/
  issues, migration guides) BEFORE answering or writing code that depends
  on the current API. Model knowledge of third-party APIs is unreliable;
  verify against source first. Make sure to use this skill IMMEDIATELY,
  before answering from memory, whenever ANY of these appear: import errors
  (ImportError "cannot import name", AttributeError "no attribute",
  TypeError "unexpected keyword argument", "removed in version X",
  "deprecated since"), adding or upgrading a dependency, technology released
  after the knowledge cutoff, or phrases like "fix this import", "suggest
  options to fix", "research X", "check docs for Y", "how does the new
  version of Z work". REQUIRED even when the model thinks it knows — one
  research pass beats a wrong import. Skip pure refactors with no external
  API change, stdlib basics, or anything grep can answer.
context: fork
agent: Explore
argument-hint: <library / API / symbol to research, with version if known — e.g. "httpx 0.27 timeout config">
---

# Web research before writing dependency-coupled code

Purpose: prevent shipping code based on stale model knowledge of an external
API. The cost of one focused research pass is small; the cost of a wrong
import or removed method discovered at runtime is much larger.

**This skill runs forked in an isolated subagent (`context: fork`, `agent: Explore`).**
You do not see the main conversation. The research target is whatever arrives in
`$ARGUMENTS` (a library / API / symbol, ideally with a version). Treat `$ARGUMENTS`
plus what you can read locally in this repo as the complete statement of what to
research, and return a findings report (exact version, canonical URLs, the specific
API facts) to the caller. If `$ARGUMENTS` is empty or too vague to research, say so
and return rather than guessing.

## Workflow

Follow these steps in order. Stop as soon as the question is answered;
do not open more sources than needed.

1. **Pin the version first.** Determine the EXACT installed version before
   researching anything. Research must target that version, not "latest in
   general".
   - Python: `uv pip show <pkg>` or `grep <pkg> pyproject.toml uv.lock`
   - Node: `cat package.json` and the lockfile
   - Anything else: the relevant lockfile / manifest

2. **Try local sources before the web.** If the answer can be obtained
   without a network call, do that first. The web is for what cannot be
   answered locally.
   - `grep -r '<symbol>' .venv/lib/python*/site-packages/<pkg>/`
   - Run `--help` on the CLI
   - Read the installed package's source directly

3. **Hit the source hierarchy** (in priority order, stop at the first
   source that resolves the question):
   1. **Official docs pinned to the installed version**
      (e.g. `docs.example.com/en/v2.4/...`, not "latest")
   2. **GitHub repo of the project**: `README.md`, `CHANGELOG.md`,
      `RELEASES`, `MIGRATION.md`, the relevant file under `src/`
   3. **Open and recently-closed GitHub issues** for known gotchas at the
      installed version
   4. **Migration / upgrade guides** when crossing a major version
   5. Recent authoritative posts (engineering blogs, conference talks).
      Distrust anything older than one major version back without
      cross-checking against source.
   6. Stack Overflow last; treat answers as hypotheses to verify against
      source, not as ground truth.

4. **Cite what you used.** When applying findings, include the canonical
   URL and the specific snippet you relied on, so the user can audit. Do
   not paraphrase API signatures without a source.

5. **Do not re-fetch within this run.** Once a source has answered part of the
   question, do not open it again. (Running forked, you have no prior conversation
   to reuse — `$ARGUMENTS` and local files are the only inputs.)

## When NOT to research

Do not invoke this workflow for:
- Refactors that touch only internal code, with no change in external API
  usage.
- Bug fixes whose mechanism is fully understood from reading the repo.
- Standard library / extremely stable APIs used at a basic level
  (`json`, `os`, `pathlib`, `requests.get`, basic `numpy`/`pandas`).
- Pure host-language syntax, style, or typing questions.
- Anything answerable by grepping the repo or reading installed package
  source (see step 2).
- The user explicitly says "don't research, just write it" or "go with
  what you know".

## Tools

- `WebSearch` — for discovering canonical URLs and recent release/issue
  pages. Prefer queries that include the exact version
  (`"<library> v3.2 <feature>"`) and the current year for freshness.
- `WebFetch` — for retrieving and reading a specific known URL.
- `Bash` (`grep`, `uv pip show`, lockfile reads) — for the local-first
  step.
- `gh` CLI via Bash — preferred over WebFetch for any github.com URL
  (issues, PRs, releases).

## Output contract

When research is done, the response to the user must contain, at minimum:
- The exact installed version that was researched against.
- The canonical source URL(s) used.
- The specific finding (API signature, behavior, migration step) drawn
  from those sources.
- If a recommendation depends on the user upgrading, say so explicitly
  rather than silently assuming the latest version.

## Examples of trigger situations

- **New dependency**: "Add `httpx` for async HTTP" — research current
  recommended client API and timeout/retry patterns for the version that
  will be installed.
- **Major upgrade**: "Bump Pydantic 1 → 2" — fetch the official migration
  guide and the breaking-changes section of the changelog before editing
  models.
- **API drift error**: `ImportError: cannot import name 'BaseTool' from
  'langchain.tools'` — pin the installed `langchain` version, then locate
  where `BaseTool` lives in that version (or find the replacement).
- **Post-cutoff technology**: a model ID, SDK, or framework released
  after the model's knowledge cutoff — research current docs rather than
  guess from naming conventions.
- **Less-common API, low confidence**: about to call a Temporal /
  OpenTelemetry / OAuth library with uncertainty about exact method
  names or option keys — confirm against source before writing the call.
