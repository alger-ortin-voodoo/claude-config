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

---

# Session Naming Convention (phased-plan work)

Phased plans are organized as phases → substeps, with **one ~200K Sonnet session per substep**. Name
those sessions consistently so the Desktop sidebar groups them cleanly:

- **Implementation:** `{feature} | {phase}.{substep} {substep-name}`
- **Planning / refinement:** `{feature} | {phase}.{substep} {substep-name} | Plan`

Examples: `Fallout | 0.2 Firebase Project`, `Fallout | 1.3 Character Stats | Plan`. `{feature}` is
usually constant for the project; `{phase}.{substep}` and the name track the current step.

**Renaming is manual.** There is no rename API/MCP tool, and the title lives in a Desktop-managed file
the app rewrites live. So the workflow is *generate the exact name → Ctrl+R (Desktop) / `/rename`
(CLI) → paste*.

**Automation that works reliably:**
- `/next-steps` puts a `Session name: …` line at the top of its continuation prompt (impl or `| Plan`
  variant as appropriate).
- When a submitted prompt contains a `Session name:` line, **surface it first** — lead your reply with
  a `🏷️ Rename this session: <name>` line — so the rename is one paste.
- `/name-session [feature | phase.substep name]` generates both canonical strings on demand (infers the
  parts from the active plan doc + context when args are omitted).
