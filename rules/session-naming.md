# Session Naming Convention (phased-plan work)

> **Single source of truth for session names.** `CLAUDE.md` imports this file (so it's always in
> context) and the `/name-session` command imports it too; `feature-flow.md` points here. Edit the
> convention HERE — nowhere else restates it.

Phased plans are organized as phases → substeps, with **one ~200K Sonnet session per substep**.
Consistent names keep the Desktop sidebar grouped cleanly.

## Format

The title is `{feature} | {scope}` with a trailing **session-type** segment for every type **except
Implementation** (which omits it to keep the common case short). When a session isn't tied to any
phase/substep, **drop `{scope}` entirely**:

- **Implementation** (default — no suffix): `{feature} | {scope}`
  — e.g. `Fallout | 0.2 Firebase Project`
- **Phased non-implementation** (`Plan`, `Review`, `Fix`, …): `{feature} | {scope} | {Type}`
  — e.g. `Fallout | 1.3 Character Stats | Plan`, `Fallout | Phase 0 | Review`
- **Phase-agnostic non-implementation** — a session not tied to any phase/substep (a general
  briefing, Q&A, repo-wide chore, tooling/config tweak): drop `{scope}` → `{feature} | {Type}`
  — e.g. `Fallout | Briefing`. Do **NOT** pad the name with a phase number the session doesn't
  belong to.

The parts:
- **`{feature}`** — usually constant for the project (e.g. `Fallout`).
- **`{scope}`** — what the session covers: a substep (`1.3 Character Stats`) or, for phase-wide work
  like an end-of-phase review, the whole phase (`Phase 0`). **Omit it** when the work spans no
  particular phase (phase-agnostic form above). Implementation always has a scope, so it never
  drops it.
- **`{Type}`** — the session's nature; an **open set** (Plan, Review, Fix, Briefing, …).
  **Implementation is the one type left unmarked.**

## Resolving the parts

1. **If args were passed**, parse them as `{feature} | {scope}` with an optional trailing `| {Type}`
   (or a loose form like `fallout 1.3 character stats plan`).
2. **Otherwise infer from context:** the active plan doc (`Glob` `docs/**/*plan*.md` or the project's
   master plan), the branch name, and what the session is actually doing.
3. **If the session isn't tied to any phase/substep**, use the phase-agnostic form `{feature} |
   {Type}` — don't force an unrelated phase number into the name.
4. Only ask the user if a part is genuinely ambiguous and can't be inferred.

## Applying & surfacing a name

Renaming is **manual** — there's no rename API/MCP tool; the title lives in a Desktop-managed file
the app rewrites live. Workflow: *generate the exact name → Ctrl+R (Desktop) / `/rename` (CLI) →
paste*. Always present a generated name **in a fenced code block** (it renders with a copy button →
one click to copy, then paste).

**Proactively surface the name.** When a submitted/pasted prompt carries a `Session name:` line (the
`/next-steps` continuation prompt emits one), **surface it first** in your reply: a short
`🏷️ Rename this session (Ctrl+R → paste):` label immediately followed by the **bare name alone in a
fenced code block** — only the name string inside, nothing else. Also surface a name when
feature/phase/substep are clearly inferable from the plan doc, even without a `Session name:` line.
On-demand generator: `/name-session`.
