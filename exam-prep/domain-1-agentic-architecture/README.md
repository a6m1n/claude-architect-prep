# D1 · Agentic Architecture & Orchestration — 27% 🔝

The heaviest domain on the exam. It is about how the agent loop works and how to coordinate many agents reliably.

← [Back to hub](../README.md) · [Plan](../STUDY-PLAN.md) · [Glossary](../GLOSSARY.md)

**Cross-cutting principle of the domain:** flow control — deterministic where there is a guarantee (`stop_reason`, gates, hooks), and model-driven where flexibility is needed. The most common traps: treating a symptom at the wrong layer (blaming a subagent instead of the coordinator's decomposition) and relying on a prompt where you need code.

## Topics
| # | Topic | One-line summary |
|---|---|---|
| [1.1](1.1-agentic-loops.md) | Agentic loops | The loop is driven by `stop_reason` (`tool_use`/`end_turn`), not by parsing text and not by an iteration cap |
| [1.2](1.2-coordinator-subagent.md) | Coordinator–subagent | Hub-and-spoke; subagents are isolated; narrow decomposition = missed coverage |
| [1.3](1.3-subagent-invocation-context.md) | Spawning & context | `Task` in `allowedTools`; context is passed explicitly; parallel = many `Task` calls in one response |
| [1.4](1.4-workflow-enforcement-handoff.md) | Enforcement & handoff | A prerequisite gate blocks downstream until the precondition is met; structured handoff on escalation |
| [1.5](1.5-agent-sdk-hooks.md) | Agent SDK hooks | `PostToolUse` normalizes results; intercepting the call = a deterministic guarantee |
| [1.6](1.6-task-decomposition.md) | Task decomposition | Fixed chaining for the predictable; adaptive for open-ended |
| [1.7](1.7-session-state-resume-fork.md) | Session state | `--resume`, `fork_session`; stale results → fresh session + summary |

**Scenarios:** Multi-Agent Research (3), Customer Support (1), Developer Productivity (4).
