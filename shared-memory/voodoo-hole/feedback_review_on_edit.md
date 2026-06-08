---
name: Feedback: Review files for rule violations on edit
description: When editing any UITable (or other project) file, take the opportunity to review it for rule violations and fix them in the same pass.
type: feedback
---

When editing any existing file in the project, review the whole file for rule violations (braces, Unity null safety, comments, etc.) and fix any found — don't just make the targeted change and leave known violations behind.

**Why:** Keeps the codebase clean without needing dedicated cleanup passes. The user explicitly asked for this after catching violations in UITableEditor.cs during a focused edit session.

**How to apply:** After making the intended change to a file, do a full rule-compliance pass on the file before considering the task done.
