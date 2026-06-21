---
description: Generate the canonical session name for phased-plan work, ready to paste into the rename dialog (Ctrl+R / /rename).
---

Produce the **canonical session name** for phased-plan work. The naming format, the meaning of each
part, the scope / phase-agnostic rules, and the resolve logic are defined in the single source of
truth — apply it exactly:

@~/.claude/rules/session-naming.md

**This skill's specifics (on top of the convention above):**

- **Args** (`$ARGUMENTS`): if present, parse per the convention's resolve step 1; otherwise infer
  from context.
- **Output:** print the resolved canonical name in a **fenced code block** (so it renders with a
  copy button — one click to copy). If the session **type** is genuinely ambiguous, print the 2–3
  most likely variants instead, each labelled, each in its own fenced block. Then one line: *Apply
  with Ctrl+R (Desktop) or `/rename` (CLI), then paste.*
- **Clipboard — off by default** (the Desktop UI one-click-copies a fenced block). Copy the name to
  the clipboard ONLY if the user passed `copy` / `--copy` — then use `Set-Clipboard -Value @'…'@`
  (single-quoted here-string) and confirm with `📋 Copied.`

$ARGUMENTS
