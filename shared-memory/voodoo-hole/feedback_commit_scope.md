---
name: Feedback: Commit Scope Discipline
description: Don't include unrelated changes in feature commits, even trivial ones
type: feedback
originSessionId: a7aeaf5b-6b77-4baa-9c12-b1c4d4bc86b8
---
Never include a change in a feature commit just because it's a small, nearby cleanup. If a file was touched as a side-effect and the change isn't actually necessary, revert it rather than committing it.

**Why:** A trailing comma was left in `InventoryTransactionPlacement.cs` as a side-effect of adding/removing enum values. It was committed as a separate "Cleanup" commit, but the user pointed out: (1) the comma wasn't needed, and (2) it had nothing to do with the feature.

**How to apply:** Before proposing commits, audit every modified file. Ask: "Is this change required for the feature?" If no — revert it, don't commit it. This applies even to one-character edits.

**Extended:** During review fix passes, do NOT touch code that is outside the scope of what was implemented. Debug logs, pre-existing patterns, and code in areas outside the PR scope must not be altered — even if a reviewer flags them. Only fix issues in code that was actually introduced in this session.
