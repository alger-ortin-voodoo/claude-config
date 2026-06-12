---
name: feedback-step-large-plans
description: "Split large multi-subtask plans into stepped ~1-commit continuation prompts, not one monolith"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5ec84dc3-2032-4442-b970-b980fe8a2a44
---

For a substantial plan with clearly differentiated subtasks, hand off the implementation in **stepped ~1-commit chunks**, not as a single monolithic continuation prompt.

**Why:** A one-shot continuation prompt for the whole Collections-analytics plan (Foundations → Phase-1 detection → UI → gameplay) produced a ~40-minute unsupervised run that the user couldn't steer. The subtasks were obviously separable and should have been scoped per step.

**How to apply:** This is exactly what the **Step mode** in the next-steps inline spec (`~/.claude/CLAUDE.md`) is for. When a plan has ≥3 commits / clearly separable subtasks, print the compact remaining-steps roadmap once, scope the continuation prompt to the next ≈1-commit chunk, and end it with "run `/next-steps` again after this step is committed." Don't collapse a multi-phase plan into one prompt just because the plan doc is self-contained. Related: [[feedback_numbered_execution_steps]], [[feedback_skip_agents_for_clear_plans]].
