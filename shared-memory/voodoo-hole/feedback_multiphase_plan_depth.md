---
name: multiphase-plan-depth
description: Master plans outline phases shallowly and flag which need deeper per-phase planning; next-steps gates implementation of flagged phases
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7dc8eee3-b25c-4cf4-bc2e-a1074819d942
---

When planning a new **multiphase** feature, keep the master/initial planning session at the OUTLINE level for the individual phases — don't deep-dive each phase there. Produce the master plan + per-phase skeletons and CLEARLY classify each phase as "ready to implement as-is" or "needs a deeper planning pass before implementation." That classification is a required master-plan output.

**Why:** deep-planning every phase upfront wastes effort and drifts — earlier phases produce the inputs that shape later ones (e.g. a key/prefix histogram → table split; a validation spike → migration approach; an on-device test → asset config). Just-in-time per-phase planning stays accurate and focused.

**How to apply:** The real enforcement is in the ruleset — `~/.claude/rules/feature-flow.md` ("Multiphase features — plan shallow, flag deep") produces the per-phase flag, and a "deeper-planning gate" in both `~/.claude/commands/next-steps.md` and the *Post-Plan Next-Steps* inline spec in `~/.claude/CLAUDE.md` consumes it: before handing off implementation of a flagged phase, next-steps recommends Opus and emits a `feature-planner` *planning* prompt that expands that phase's own doc in place — never an implementation prompt for a flagged phase. Established on the Unity Localization migration (HOL-5677), whose per-phase docs already carry the ready/needs-deeper classification. Relates to [[feedback_step_large_plans]] and [[feedback_skip_agents_for_clear_plans]].
