---
description: Generate the canonical session name for phased-plan work, ready to paste into the rename dialog (Ctrl+R / /rename).
---

Produce the **canonical session name** for phased-plan work, following the convention in
`~/.claude/rules/feature-flow.md`. The title is `{feature} | {scope}` plus a trailing
**session-type** segment for every type *except* Implementation (which omits it to stay short):

- **Implementation** (default — no suffix): `{feature} | {scope}` — e.g. `Fallout | 0.2 Firebase Project`
- **Any other type** (`Plan`, `Review`, `Fix`, …): `{feature} | {scope} | {Type}` — e.g.
  `Fallout | 1.3 Character Stats | Plan`, `Fallout | Phase 0 | Review`

`{scope}` is what the session covers — a substep (`1.3 Character Stats`) or, for phase-wide work like
an end-of-phase review, the whole phase (`Phase 0`).

**Resolve the parts:**
1. If the user passed arguments, parse them as `{feature} | {scope}` with an optional trailing
   `| {Type}` (or a loose form like `fallout 1.3 character stats plan`).
2. Otherwise infer from context: the active plan doc (`Glob` `docs/**/*plan*.md` or the project's
   master plan), the branch name, and what this session is actually doing. `{feature}` is usually
   constant for the project (e.g. `Fallout`); `{scope}` is the current substep or phase; `{Type}` is
   the session's nature — **Implementation → no suffix**, otherwise `Plan` / `Review` / `Fix` / etc.
3. Only ask the user if a part is genuinely ambiguous and can't be inferred.

**Output:** print the canonical name for the resolved type in a **fenced code block** (so it renders
with a copy button — one click to copy). If the type is genuinely ambiguous, print the 2–3 most
likely variants, each labelled, each in its own fenced block. Then one line: *Apply with Ctrl+R
(Desktop) or `/rename` (CLI), then paste.*

**Clipboard:** off by default (the Desktop UI one-click-copies a fenced block). Copy the name to the
clipboard ONLY if the user passed `copy` / `--copy` — then use `Set-Clipboard -Value @'…'@`
(single-quoted here-string) and confirm with `📋 Copied.`

$ARGUMENTS
