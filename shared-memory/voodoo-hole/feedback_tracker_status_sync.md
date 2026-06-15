---
name: tracker-status-sync
description: "Keep ClickUp task status synced with plan-phase progress (in-progress on start, done on commit) without being asked"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7dc8eee3-b25c-4cf4-bc2e-a1074819d942
---

When a plan's phases are clearly linked to tracker items (each phase ↔ its own ClickUp subtask, task ID recorded in the phase-doc header), keep their status in sync **without being asked**: move a task to the in-progress status when its phase implementation starts, and to done/complete when the phase's commits land — and flip the plan/indexer **Status** to match.

**Why:** the linkage is explicit, so the user shouldn't have to hand-maintain two places; a stale tracker status misleads "where are we."

**How to apply:** Encoded in `~/.claude/rules/feature-flow.md` ("Keep tracker statuses synced with plan phases"). Resolve actual status names from the list (ClickUp `expand_statuses`); **never mark done before the work is committed** (commit gate). It's a behavioral rule, not a `settings.json` hook (the mapping needs judgment + an MCP call), so the plan records the phase↔task mapping. Established alongside the HOL-5677 localization plan, whose phase docs carry their HOL-80xx task IDs. Relates to [[feedback_multiphase_plan_depth]] and [[feedback_clickup_task_creation]].
