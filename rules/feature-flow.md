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

## Size work by Sonnet session, not by commit count (STANDARD)

The unit of a plan step / sub-phase is an **atomic, related chunk of work that fits in a single Sonnet implementation session without forcing context compaction.** Sonnet runs at 200K (never the 1M beta); after the plan, `CLAUDE.md`, memory, reference files, tool overhead, and an output budget, realistic working room is ~150K. Mid-implementation compaction is slow and lossy — sizing to the session is what prevents it.

- **Plan in chunks, not commits.** Do NOT prescribe a commit count ("one atomic commit", "two commits"). Frame each step as a session-sized chunk that ends at a **committable** state (compiles + works); **how many commits it takes is the implementer's call** at execution time.
- **Estimate each chunk's context load** — reference files to read + files to edit + expected tool output — and split anything that would risk compaction. A single large file (e.g. a 500+ line class) gets its own chunk.
- **List the reference files each chunk needs**, so the executor can pre-budget context. Avoid chunks that vaguely require "understanding the whole subsystem".
- **Use a scripted/mechanical pass for bulk edits** (e.g. a token-rename across dozens of files) instead of file-by-file `Read`/`Edit` — the file-by-file approach is a classic context-blower.
- Master/per-phase skeletons outline **work chunks**, not commit lists. `next-steps` hands off **one chunk per session** (see the *Post-Plan Next-Steps* spec in `CLAUDE.md` and the `/next-steps` command).

## Multiphase features — plan shallow, flag deep (STANDARD)

When a feature is **multiphase**, keep the master/initial planning session at the **outline level for the individual phases** — do NOT deep-dive each phase there. Produce the master plan + per-phase skeletons (goal, session-sized work-chunk outline, files, done-criteria, risks), and then **CLEARLY classify each phase as either "ready to implement as-is" or "needs a deeper planning pass before implementation"** (with a one-line why). That classification is a **required output** of the master plan, not optional.

- **Why:** deep-planning every phase upfront wastes effort and drifts — earlier phases routinely produce the inputs that should shape later ones (e.g. a key/prefix histogram → table split; a validation spike → migration approach; an on-device test → asset config). Just-in-time per-phase planning stays accurate and focused.
- **The deeper pass is itself a planning step** (Opus, `feature-planner`) and **expands that phase's own doc in place** — it must not bloat the master plan.
- **`next-steps` enforces the gate:** before handing off implementation of a phase flagged "needs deeper planning," both the `/next-steps` skill and the *Post-Plan Next-Steps* inline spec in `CLAUDE.md` MUST prompt the user to run that deeper planning pass first (Opus) and emit a **planning** continuation prompt, not an implementation one. Phases marked ready-as-is proceed straight to build.

## Keep tracker statuses synced with plan phases (STANDARD)

When a plan's phases are clearly linked to tracker items (e.g. each phase has its own ClickUp subtask, with the task ID recorded in the phase-doc header), keep their status in sync **without being asked**:

- **Start of a phase's implementation** → move its task to the list's in-progress status.
- **Phase commits land** (after the user's commit approval) → move its task to the done/complete status, and flip that phase's **Status** in the indexer + phase doc to match.
- Resolve the actual status names from the list (e.g. ClickUp `expand_statuses`) rather than assuming; **never mark a task done before its work is committed** (the commit safety gate still applies).

This is a behavioral standing rule for the session driving the work — it can't be a `settings.json` hook (the phase→task mapping needs judgment + an MCP call), so record the phase↔task mapping in the plan (phase-doc headers carry their task ID) and keep both sides current as you go.

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
- When a submitted prompt contains a `Session name:` line, **surface it first** — a short
  `🏷️ Rename this session (Ctrl+R → paste):` label immediately followed by the **bare name alone in a
  fenced code block** (it renders with a copy button → click-to-copy, then Ctrl+R + paste). Put only
  the name string inside the block, nothing else.
- `/name-session [feature | phase.substep name]` generates both canonical strings on demand (infers the
  parts from the active plan doc + context when args are omitted).
