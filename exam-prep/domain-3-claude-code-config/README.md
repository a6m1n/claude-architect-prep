# D3 · Claude Code Configuration & Workflows — 20%

About configuring Claude Code for a team: CLAUDE.md, commands, skills, rules, plan mode, CI/CD.

← [Back to hub](../README.md) · [Plan](../STUDY-PLAN.md) · [Glossary](../GLOSSARY.md)

**Cross-cutting principle of the domain:** the right place and scope. Always ask: is this for the team (project, in VCS) or personal (user)? Always loaded (CLAUDE.md) or on demand (skill)? Tied to a folder (CLAUDE.md) or to a file type (`.claude/rules` glob)?

## Topics
| # | Topic | One-line gist |
|---|---|---|
| [3.1](3.1-claudemd-hierarchy.md) | CLAUDE.md hierarchy | user/project/directory; user-level is NOT shared; `@import`, `/memory` |
| [3.2](3.2-slash-commands-skills.md) | Commands & skills | `.claude/commands` vs `~/.claude/commands`; `context: fork`, `allowed-tools`, `argument-hint` |
| [3.3](3.3-path-specific-rules.md) | Path-specific rules | `.claude/rules` + `paths:` globs; beats directory CLAUDE.md for cross-cutting files |
| [3.4](3.4-plan-mode-vs-direct.md) | Plan vs direct | Plan for large/architectural/multi-file; direct for small |
| [3.5](3.5-iterative-refinement.md) | Iterative refinement | I/O examples > prose; test-driven; interview pattern |
| [3.6](3.6-ci-cd-integration.md) | CI/CD integration | `-p`/`--print`; `--output-format json`; independent review > self-review |

**Scenarios:** Code Generation (2), CI/CD (5), Developer Productivity (4).
