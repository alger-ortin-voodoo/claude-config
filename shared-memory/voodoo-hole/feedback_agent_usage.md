---
name: Feedback: Agent usage — direct tools first
description: Never spawn Explore agents when file paths are already known; use Read/Grep/Glob directly
type: feedback
originSessionId: 45ed54ea-0a6e-424d-b4b2-14ebcd3ac06f
---
Never spawn an Explore (or any) agent to read files whose paths are already known. Use Read, Grep, or Glob directly — in parallel if needed. Agents are dramatically heavier (80–100k+ tokens vs a few hundred).

**Why:** This has happened multiple times despite repeated corrections. Even in plan mode where exploring "feels" appropriate, if the user provided file paths or they are derivable from the plan/context, direct tools are always the right call. In one session, the user pointed directly to two files and two Explore agents were launched anyway — burning ~200k tokens on work that 5-6 Read/Grep calls would have done. In another (2026-04-17), two Explore agents (~240k tokens) were launched during a Phase 2 design review even though all key files were already known from Phase 1 implementation — the user's questions were design decisions that needed a Glob + a couple of Greps at most, plus asking the user directly.

**How to apply:**
- If the user mentions a file path, Read it directly. Full stop.
- In plan mode: Read known files in parallel, Grep for patterns (e.g. implementors of an interface), Glob for folder structure. No agents.
- Only spawn Explore when the scope is genuinely uncertain AND you cannot derive the paths from context — e.g. "find all callers of X across the whole codebase" with no known starting point.
- Rule of thumb: if you could write the file paths in the agent prompt, you should be using Read instead. If you're writing a search query into an agent prompt that Grep could answer, use Grep.
- When in doubt about scope: ask the user before spawning any agent. A one-line question costs nothing; a wasted Explore agent costs ~100k tokens.
