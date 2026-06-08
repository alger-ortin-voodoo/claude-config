---
name: feedback-clickup-task-creation
description: "Rules for creating ClickUp tasks — naming, tagging, status, and assignees"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e42c5aed-b772-4d67-bf00-64eadf531be2
---

Rules for ClickUp task creation:

**No feature prefix on subtask names.**
When creating subtasks under a feature parent (e.g. HOL-7356 Collections), do NOT prefix task names with the feature name. It's redundant noise since the parent already provides context. Good: "Data Model & Persistence". Bad: "Collections — Data Model & Persistence".

**Why:** The parent task already scopes the subtasks; the prefix only adds clutter.

**How to apply:** Always strip the feature/epic name prefix when creating subtasks.

---

**Names: simple human one-liners, not jargon or composites.**
Task names are read by humans on a board. Avoid implementation jargon ("public read API", "DI plumbing"), and avoid composite "X + Y + Z" names. Name the task by its outcome in plain language (e.g. "Expose Collections progress and rewards to the UI", not "Add CollectionsEventInstance public read API + ResolveRewards refactor"). Push the detailed breakdown — class names, multi-part scope, sub-steps — into the **description** field, as a bullet list or checklist when the task bundles several pieces.

**Why:** A scannable board needs human-readable titles; technical detail belongs in the body.

**How to apply:** Draft a plain-language outcome title; move every "and"/"+" clause and code identifier into the description.

---

**Default tag: "dev".** Add the "dev" tag to all tasks unless the task clearly belongs to another discipline. Available tags:
- `dev` — development / code
- `art` — art / visual assets
- `gd` — game design
- `analytics` — analytics / data
- `qa` — quality assurance

**Why:** Most tasks Alger creates are dev tasks; the tag helps filter the board.

**How to apply:** Decide the tag from the task scope. If a task is not clearly dev, pick the right tag. See [[feedback-clickup-tags]] for the workaround (use `tags` param in `create_task`, not `add_tag_to_task`).

---

**Default status: PRIORITIZED.**
Always set newly created tasks to status `PRIORITIZED` unless the user specifies otherwise.

**Why:** That is where ready-to-pick-up tasks live on the team's board.

**How to apply:** Pass `status: "PRIORITIZED"` on every `create_task` call.

---

**Assignee: ask if not clearly a dev task.**
Assign dev tasks to Alger (87664576) by default. If a task scope suggests art, GD, analytics, or QA work, ask the user who should own it before creating.

**Why:** Mis-assigning tasks causes board confusion and missed notifications.

**How to apply:** Evaluate scope before creating; pause and ask for non-dev tasks.
