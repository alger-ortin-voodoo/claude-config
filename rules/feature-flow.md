# Feature Implementation Flow (STANDARD)

> Read this when planning a new feature (or sub-phase).

**Behavioral expectation:** Whenever I plan a new feature (or sub-phase), I MUST present a summary table mapping each implementation phase of *that* feature to the model, driver, and steps to follow. The table below is the generic template — tailor it to the feature's actual phases/sub-phases each time (e.g. one row per sub-phase, with its own model/driver/review needs). This is not an optional nicety; producing the table is part of finishing a plan.

Generic phase flow (adapt per feature):

| Phase | Model | Driver | Steps to follow |
|---|---|---|---|
| **Plan** — new feature, spec/ticket, or any design decisions left | Opus | `feature-planner` | Produce the plan doc. Skip if a detailed plan already exists. |
| **Build** — plan ready, no decisions left | Sonnet | main thread (`/implement`) | No implementation agents exist; main thread drives. Pause for manual prefab/asset authoring. |
| **Pre-commit review** | (current) | `unity-code-reviewer` (+ `performance-guardian` if hot paths / rendering / instantiation changed) — run in parallel | Report a punch-list, then **stop and tell the user**. |
| **Commit** | (current) | `commit-preparer` (or main-thread direct when session context is fresh) | Never commit without explicit approval. |

- Model switches follow the **Model Switching Reminders** (Opus→plan, Sonnet→implement).
- This complements **Agent Routing** (which answers *"which agent for this trigger?"*); this answers *"what's the order of operations for the whole feature?"*.
- For a fully-planned, mechanical step the main thread may drive end-to-end; reserve `plan-implementer` for executing a complete multi-step feature-planner plan.

## Multiphase features — plan shallow, flag deep (STANDARD)

When a feature is **multiphase**, keep the master/initial planning session at the **outline level for the individual phases** — do NOT deep-dive each phase there. Produce the master plan + per-phase skeletons (goal, atomic-commit outline, files, done-criteria, risks), and then **CLEARLY classify each phase as either "ready to implement as-is" or "needs a deeper planning pass before implementation"** (with a one-line why). That classification is a **required output** of the master plan, not optional.

- **Why:** deep-planning every phase upfront wastes effort and drifts — earlier phases routinely produce the inputs that should shape later ones (e.g. a key/prefix histogram → table split; a validation spike → migration approach; an on-device test → asset config). Just-in-time per-phase planning stays accurate and focused.
- **The deeper pass is itself a planning step** (Opus, `feature-planner`) and **expands that phase's own doc in place** — it must not bloat the master plan.
- **`next-steps` enforces the gate:** before handing off implementation of a phase flagged "needs deeper planning," both the `/next-steps` skill and the *Post-Plan Next-Steps* inline spec in `CLAUDE.md` MUST prompt the user to run that deeper planning pass first (Opus) and emit a **planning** continuation prompt, not an implementation one. Phases marked ready-as-is proceed straight to build.
