# Choosing plan mode for large-scale, multi-file architectural work

> **Domain:** D3 · Claude Code Configuration & Workflows (20%) — Task 3.4 (plan mode vs direct execution)
> **Scenario:** Code Generation with Claude Code · **Study area:** Plan mode vs direct execution
> **Trap level:** 🟡 Medium — three distractors all dress up direct execution as the pragmatic choice
> **Trap archetype:** Plan-then-confirm vs. direct execution
> **Source:** Official Claude Certified Architect exam guide — Sample Question 5.

## 1. Topic — what this really tests

When to reach for **plan mode** instead of **direct execution** in Claude Code. The deciding signal is task shape, not task difficulty: plan mode fits work that is large-scale, spans many files, has multiple valid approaches, or hinges on architectural decisions — because it lets Claude explore the codebase and design an approach *before* any edit touches disk, preventing costly rework. Direct execution fits small, well-scoped changes. The trap is treating mode choice as something to defer until problems appear, when the complexity is already evident in the requirements.

## 2. Question

> You've been assigned to restructure the team's monolithic application into microservices. This will involve changes across dozens of files and requires decisions about service boundaries and module dependencies. Which approach should you take?
>
> **A)** Enter plan mode to explore the codebase, understand dependencies, and design an implementation approach before making changes
> **B)** Start with direct execution and make changes incrementally, letting the implementation reveal the natural service boundaries
> **C)** Use direct execution with comprehensive upfront instructions detailing exactly how each service should be structured
> **D)** Begin in direct execution mode and only switch to plan mode if you encounter unexpected complexity during implementation

## 3. Answer options

- **A.** Enter plan mode to explore, understand dependencies, and design before changing — ✅ **Correct**
- **B.** Direct execution, let implementation reveal boundaries / **C.** Direct execution with full upfront instructions / **D.** Direct execution, switch to plan only if complexity emerges — ⚠️ **Most common wrong answer**

## 4. Correct answer — A

A monolith→microservices split is the canonical plan-mode case: it is large-scale, multi-file, and dominated by architectural decisions (service boundaries, module dependencies). Plan mode reads files and produces a reviewable plan while making **no edits**, so design and dependency analysis happen safely before commitment. Generalize: when a change spans multiple files, the approach is uncertain, or you are unfamiliar with the code, plan first; if you could describe the diff in one sentence, execute directly.

## 5. Common mistake — the trap most people fall for

The most-picked wrong answer is **D — "start in direct execution and switch to plan mode only if unexpected complexity shows up."** It is seductive because it sounds like lean, pragmatic engineering: don't over-plan, react to complexity if and when it actually arrives. The tell that exposes it: the complexity here is not a contingency that *might* emerge — it is already stated in the requirements (dozens of files, service-boundary and dependency decisions). Deferring the mode decision means edits start hitting disk before the architecture is understood, so the costly rework plan mode exists to prevent has already begun by the time anyone "switches." The correct move reads task shape up front and plans first whenever a change is multi-file, architectural, or uncertain — this is the plan-then-confirm-vs.-direct-execution archetype: act on complexity that is already known, not complexity that might appear.

## 6. Distractor analysis — look-alikes to watch for

- **A.** Correct — matches plan mode's intended use (explore → plan → implement).
- **B.** "Let boundaries emerge" sounds agile, but defers architecture and risks costly rework when dependencies surface late mid-edit.
- **C.** Detailed upfront instructions feel rigorous, but assume the right structure is already known — it skips the exploration the decision actually requires.
- **D.** "Switch later if needed" seems pragmatic, but the complexity is already stated in the requirements, not a contingency that might emerge.

## 7. Key takeaways

- Pick mode by task **shape**: multi-file / multiple approaches / architectural / unfamiliar code → plan mode.
- Plan mode = safe exploration + a reviewable plan, **zero edits** until you approve (`claude --permission-mode plan`, or `Shift+Tab` to toggle).
- Direct execution = single-file fixes, one validation check, typo, log line — anything describable as a one-sentence diff.
- Don't defer the mode decision: act on complexity that is *already known*, not complexity that *might* appear.
- Pair plan mode with subagents to keep verbose discovery output out of the main context.

## 8. Official documentation

- Best practices — "Explore first, then plan, then code": <https://code.claude.com/docs/en/best-practices>
- Common workflows — "Plan before editing": <https://code.claude.com/docs/en/common-workflows>
