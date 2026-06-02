# D2 · Tool Design & MCP Integration — 18%

About tool design, structured errors, tool distribution, and MCP integration.

← [Back to hub](../README.md) · [Plan](../STUDY-PLAN.md) · [Glossary](../GLOSSARY.md)

**Domain-wide principle:** the tool interface is the "prompt" for selection. Fix the tool contract (description, name, scope, error structure), not the system prompt. Least privilege: fewer tools per role → more reliable selection.

## Topics
| # | Topic | One-line summary |
|---|---|---|
| [2.1](2.1-tool-interfaces.md) | Tool interfaces | Description is the primary selection signal; expanding the description is a cheap first step |
| [2.2](2.2-mcp-structured-errors.md) | Structured errors | `isError` + `errorCategory` + `isRetryable`; access-failure ≠ valid-empty; local recovery |
| [2.3](2.3-tool-distribution-tool-choice.md) | Tool distribution | Least privilege; scoped cross-role tools; `tool_choice` auto/any/forced |
| [2.4](2.4-mcp-server-integration.md) | MCP server integration | `.mcp.json` (project) vs `~/.claude.json` (user); `${ENV}`; resources as catalogs |
| [2.5](2.5-builtin-tools.md) | Built-in tools | Grep=content, Glob=paths, Edit=unique match (Read+Write fallback) |

**Scenarios:** Multi-Agent Research (3), Customer Support (1), Developer Productivity (4).
