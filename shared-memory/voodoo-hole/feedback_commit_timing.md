---
name: Feedback: Commit Timing
description: Never commit without explicit user instruction — not even when it seems like the obvious next step
type: feedback
originSessionId: a7aeaf5b-6b77-4baa-9c12-b1c4d4bc86b8
---
Never commit unless the user explicitly asks to commit. Do not infer that a commit is the next step from context, summaries, or "natural conclusion" reasoning.

**"Prepare commits" ≠ execute commits.** When the user says "prepare the commits", respond with a proposed grouping and draft messages for review — do not run `git commit`. Only execute after the user approves the plan.

**Finishing a task ≠ permission to commit.** Even when the user says "do X and commit" for a different task, that does not grant permission to commit anything else that happens to be ready. Each commit needs its own explicit instruction.

**Why:** User was surprised by unrequested commits — once at the end of a session, once after an inline refactor, and once after a code review fix pass. "I'll apply the fixes" does NOT imply "and then commit." Review fixes are not a separate task that earns its own commit.

**How to apply:** After finishing any set of changes — including review fixes — stop and wait. Only run `git commit` when the user gives explicit go-ahead. This applies even in auto mode. Always propose a commit plan (message + files) and wait for approval before executing.
