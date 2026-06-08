---
name: feedback-skip-agents-for-clear-plans
description: "Implementation work is driven by the main thread — no domain-specific implementer agents exist. Delegate only for planning, review, or debugging."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d47f2706-2547-48a7-bfda-72327cbb1dc8
---

Implementation work for Hole.io is always driven by the main thread. There are no `metagame-engineer` / `ui-engineer` / `editor-tools-engineer` agents — they were created on 2026-05-19, tested, and removed the same day because the user's workflow is consistently spec → plan → implementation → review, and the main thread (with rules from CLAUDE.md + memory) executes plans as cleanly as a delegated agent would.

**Why:** Agents add overhead — context handoff, re-reading routed `Docs/Claude/*.md`, re-orienting on rules already established in the main thread's plan session. The user confirmed on 2026-05-19 that for pre-baked plans the main thread should just execute.

**How to apply:** Never propose delegating implementation work for this project. Delegate only for:
- New feature design with open decisions → `feature-planner`
- Pre-commit style audit → `unity-code-reviewer`
- Pre-commit perf audit (hot paths / rendering changes) → `performance-guardian`
- Bug repro and root-cause investigation → `debug-investigator`

Reviewers + planner + debugger are the only agents in [[agent-routing]] worth firing.
