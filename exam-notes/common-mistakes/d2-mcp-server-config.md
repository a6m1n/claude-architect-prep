# Project vs user MCP scope: sharing boundary + secret-free credentials

> **Domain:** D2 · Tool Design & MCP Integration (18%) — Task 2.4 (MCP server integration)
> **Scenario:** Code Generation with Claude Code · **Study area:** MCP server config (`.mcp.json` vs `~/.claude.json`, env-var expansion, resources)
> **Trap level:** 🔴 High — the wrong scope ships the server but the secret leaks, looking correct on first read
> **Trap archetype:** Project scope vs. user scope
> **Source:** Concept note grounded in the official exam guide, Task 2.4.

## 1. Topic — what this really tests

The MCP **scope** is the sharing boundary, not just a file location. Project scope (`.mcp.json` at the repo root) is checked into version control so every teammate gets the same servers; user scope (`~/.claude.json`) stays private to one machine. To share a server that needs a credential without leaking the secret, the token is referenced via **environment-variable expansion** (`${GITHUB_TOKEN}`) — each developer supplies their own value at runtime, so the committed file carries the config but never the secret. Separately, MCP **resources** let a server expose content catalogs (issue summaries, doc hierarchies, DB schemas) so the agent sees what data exists without burning exploratory tool calls.

## 2. Question

> A platform team wants every developer on the repo to automatically get the same GitHub MCP server when they clone the project. The server authenticates with a personal access token. The team must share the configuration through the repository but must **not** commit the token. What is the correct setup?
>
> - **A.** Add the server to project-scoped `.mcp.json` and reference the token as `${GITHUB_TOKEN}` so each developer supplies the value via their environment.
> - **B.** Add the server to user-scoped `~/.claude.json` so the token stays off the repo.
> - **C.** Add the server to `.mcp.json` with the token hardcoded in the `headers`/`env` block.
> - **D.** Add the server to `.mcp.json` with a placeholder and paste the real token into `CLAUDE.md` for teammates to copy.

## 3. Answer options

- **A.** Project-scoped `.mcp.json` + `${GITHUB_TOKEN}` env-var expansion. ✅ **Correct**
- **B.** User-scoped `~/.claude.json`.
- **C.** Hardcode the token in `.mcp.json`. — ⚠️ **Most common wrong answer**
- **D.** Placeholder in `.mcp.json`, real token in `CLAUDE.md`.

## 4. Correct answer — A

Project scope is the only scope that ships through version control, so it is the one that actually shares the server with the team. Env-var expansion (`${GITHUB_TOKEN}`, with `${VAR:-default}` available for optional values) keeps the committed `.mcp.json` secret-free: the config is shared, the credential is resolved per-machine at connection time. Generalize: **scope = who gets the server** (project = team, user = just me); **env-var expansion = secret hygiene** — never put a literal secret in a tracked file.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **C — hardcode the token directly in `.mcp.json`.** It is seductive because it gets the scope right: project-scoped `.mcp.json` does ship through version control, so every teammate genuinely receives the same server on clone, which satisfies the visible half of the requirement. The tell that it's wrong: the token is now a literal secret living in a tracked file — the exact thing the requirement explicitly forbids ("must not commit the token"). Getting the scope right is necessary but not sufficient; the credential still has to be resolved per-machine via `${GITHUB_TOKEN}` expansion so the committed config stays secret-free. The trap is treating the project-scope decision as the whole answer and ignoring the second, independent constraint — credential hygiene rides on the same choice.

## 6. Distractor analysis — look-alikes to watch for

- **B (wrong scope):** `~/.claude.json` is private to one machine and not in the repo, so teammates get nothing on clone. It fails the "share via the repository" requirement; it is the right home for *personal/experimental* servers, not shared team tooling.
- **C (committed secret):** Hardcoding the token in `.mcp.json` does share the server, but the secret is now in version control — the exact thing the requirement forbids. Looks correct because the scope is right; fails on credential hygiene.
- **D (secret in the wrong file):** `CLAUDE.md` is also tracked, so pasting the token there leaks it just like C; manual copy-paste also defeats the "automatically get it on clone" goal. Env-var expansion is the supported mechanism, not a side file.

## 7. Key takeaways

- **Scope is the sharing boundary:** project `.mcp.json` (version-controlled, team-wide) vs user `~/.claude.json` (private, personal/experimental, cross-project).
- **`${VAR}` expansion = secret-free config:** commit the structure, resolve tokens from each developer's environment; required vars with no default cause a parse failure (fail loud, not silent).
- **All servers' tools are available simultaneously** — tools from every configured MCP server are discovered at connection time, so the agent can use them all at once.
- **Resources expose content catalogs** (issue summaries, doc trees, DB schemas) so the agent sees available data without exploratory tool calls.
- **Write rich tool descriptions** — detailed capability/output descriptions stop the agent from defaulting to built-ins (e.g., `Grep`) over a more capable MCP tool; prefer existing community servers (e.g., Jira) for standard integrations, reserve custom servers for team-specific workflows.

## 8. Official documentation

- Connect Claude Code to tools via MCP (scopes table, project vs user, env-var expansion, resources): https://code.claude.com/docs/en/mcp
- Model Context Protocol — what MCP is (tools, resources, open standard): https://modelcontextprotocol.io/
