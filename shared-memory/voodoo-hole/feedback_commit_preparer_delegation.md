---
name: feedback-commit-preparer-delegation
description: When to draft commit groupings on the main thread vs delegate to commit-preparer; and how to handle parallel-session staged changes
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f92a9c9b-a50c-4306-9ac5-6d6d5ad2387b
---

When the main thread already has full session context (knows what changed and why), draft the commit grouping and messages directly — do NOT spawn a first analysis agent to figure it out. The commit-preparer is for execution and preview, not for analysis that the main thread can do in seconds.

**The correct flow when I have session context:**
1. Draft groupings + messages on the main thread.
2. Present to the user as a preview table.
3. On approval, pass the ready-to-execute plan to commit-preparer in ONE agent call.

Spawning two sequential commit-preparer agents (one to analyse, one to execute) is always wrong when the session context already contains the answer. It cost 95k tokens and 14 minutes for 3 simple commits.

**Why:** The user was right to be frustrated — the analysis work (grouping, message drafting) was trivial given the session context. Delegating it to an agent that has to re-read the whole diff from scratch is pure waste.

**Parallel-session staged changes:** When the user warns at the start of a session that they're working on unrelated changes in parallel (e.g. "don't panic if you see unrelated changes to future phases"), treat any staged files from those parallel sessions as OUT OF SCOPE for the current session's commits. Explicitly identify them when drafting the grouping and exclude them. Failing to do this caused the Phase 5 plan doc to be committed silently as part of Phase 3's docs commit — exactly what the user warned about.

**How to apply:** Before drafting commit groupings, cross-check staged/unstaged files against the session's stated scope. Any file the user flagged as belonging to a parallel session must be excluded and called out explicitly.
