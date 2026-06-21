---
description: Generate the canonical session name(s) for phased-plan work, ready to paste into the rename dialog (Ctrl+R / /rename).
---

Produce the **canonical session name** for phased-plan work, following the convention in
`~/.claude/rules/feature-flow.md`:

- **Implementation:** `{feature} | {phase}.{substep} {substep-name}`
- **Planning / refinement:** `{feature} | {phase}.{substep} {substep-name} | Plan`

**Resolve the parts:**
1. If the user passed arguments, parse them as `{feature} | {phase}.{substep} {substep-name}`, or a
   loose form like `fallout 1.3 character stats`.
2. Otherwise infer from context: the active plan doc (`Glob` `docs/**/*plan*.md` or the project's
   master plan), the branch name, and what this session is actually doing. `{feature}` is usually
   constant for the project (e.g. `Fallout`); pick the `{phase}.{substep}` + name for the current/next
   step.
3. Only ask the user if a part is genuinely ambiguous and can't be inferred.

**Output:** print BOTH canonical strings — labelled **Implementation** and **Plan** — each in its own
fenced code block so they're one-click copyable. Then one line: *Apply with Ctrl+R (Desktop) or
`/rename` (CLI), then paste.*

**Clipboard:** off by default (the Desktop UI one-click-copies a fenced block). Copy the implementation
name to the clipboard ONLY if the user passed `copy` / `--copy` — then use
`Set-Clipboard -Value @'…'@` (single-quoted here-string) and confirm with `📋 Copied.`

$ARGUMENTS
