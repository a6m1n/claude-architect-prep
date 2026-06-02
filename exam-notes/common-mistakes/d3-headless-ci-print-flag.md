# Running Claude Code non-interactively in CI with `-p` / `--print`

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.6 (CI/CD: `-p`/`--print`, `--output-format json`)
> **Scenario:** Claude Code for Continuous Integration · **Study area:** Headless/non-interactive CLI (`-p`/`--print`)
> **Trap level:** 🟡 Medium — distractors mimic real Unix/env conventions and plausible flag names
> **Trap archetype:** Headless/non-interactive mode vs. interactive (invented-feature look-alikes)
> **Source:** Official Claude Certified Architect exam guide — Sample Question 10.

## 1. Topic — what this really tests

By default `claude` starts an **interactive** session and blocks waiting for terminal input. In an automated pipeline there is no human at the keyboard, so the job hangs forever. The fix is to run Claude Code in **headless / non-interactive (print) mode** with `-p` (`--print`): it consumes the prompt, streams the result to stdout, and exits with a status code — the contract a CI step needs. This tests whether you know the *real* documented flag versus plausible-sounding inventions.

## 2. Question

> Your pipeline script runs `claude "Analyze this pull request for security issues"` but the job hangs indefinitely. Logs indicate Claude Code is waiting for interactive input. What's the correct approach to run Claude Code in an automated pipeline?
>
> - **A.** Add the `-p` flag: `claude -p "Analyze this pull request for security issues"`
> - **B.** Set the environment variable `CLAUDE_HEADLESS=true` before running the command
> - **C.** Redirect stdin from /dev/null: `claude "Analyze this pull request for security issues" < /dev/null`
> - **D.** Add the `--batch` flag: `claude --batch "Analyze this pull request for security issues"`

## 3. Answer options

- **A.** Add `-p` — ✅ **Correct**
- **B.** `CLAUDE_HEADLESS=true` env var — invented feature
- **C.** `< /dev/null` stdin redirect — Unix workaround, not the supported mechanism — ⚠️ **Most common wrong answer**
- **D.** `--batch` flag — invented feature

## 4. Correct answer — A

`-p` (or `--print`) is the documented switch for running Claude Code non-interactively: "Print response without interactive mode." It processes the prompt, prints the result to stdout, and exits without waiting for user input — exactly what a CI/CD step requires. Add `--bare` for reproducible runs that skip auto-discovery of local hooks/MCP/CLAUDE.md.

For machine-parseable CI output, pair `-p` with the companion flags: `--output-format json` returns the result plus session/usage metadata (extract fields with `jq`), and `--json-schema '<schema>'` forces the model's output to conform to a JSON Schema (the validated payload lands in `structured_output`). Generalizing: a CI step that gates a build wants `claude -p ... --output-format json --json-schema ...` so it can branch on a structured verdict rather than scrape prose. The canonical PR-review pattern is `gh pr diff "$1" | claude -p --append-system-prompt "...review for vulnerabilities" --output-format json`.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **C — redirecting stdin from `/dev/null`.** It is seductive because it is a genuine Unix idiom: closing stdin really does stop a process from blocking on input, so it *looks* like it solves the hang. The tell that it's wrong: it treats the symptom (a blocked read) rather than the cause (the wrong run mode), and it never gives you print-mode behavior — a single result to stdout, a clean exit code, and `--output-format`/`--json-schema` support. The correct move selects the documented non-interactive mode with the `-p`/`--print` flag, which is the supported headless contract a CI step is built for. Generalizing the archetype: when a workload needs headless operation, reach for the product's own non-interactive mode, not a shell workaround or a plausible-sounding invented flag/env var.

## 6. Distractor analysis — look-alikes to watch for

- **B — `CLAUDE_HEADLESS=true`:** plausible naming, but no such environment variable exists. Headless mode is selected by the `-p`/`--print` *flag*, not an env var.
- **C — `< /dev/null`:** a real shell trick that stops stdin from blocking, but it is not Claude Code's documented non-interactive path and does not give you print-mode behavior (single result to stdout, clean exit, `--output-format`/`--json-schema` support). It treats the symptom, not the cause.
- **D — `--batch`:** invented flag. Easy to confuse with the unrelated **Message Batches API** (a server-side bulk API), which has nothing to do with the Claude Code CLI.

## 7. Key takeaways

- Bare `claude "prompt"` is interactive and will hang in CI; `-p` / `--print` is the non-interactive mode.
- `-p` prints one result to stdout and exits with a status code — pipeline-friendly.
- For structured CI gates, combine `-p` with `--output-format json` (+ `--json-schema`); parse with `jq`.
- `CLAUDE_HEADLESS`, `--batch`, and a `< /dev/null` redirect are not the supported mechanism — beware invented-feature distractors.
- Add `--bare` for deterministic CI runs; on GitHub use the `anthropics/claude-code-action@v1` action.

## 8. Official documentation

- Run Claude Code programmatically (headless / `-p`): https://code.claude.com/docs/en/headless
- CLI reference (`--print`, `--output-format`, `--json-schema`): https://code.claude.com/docs/en/cli-reference
- Claude Code GitHub Actions (CI/CD): https://code.claude.com/docs/en/github-actions
