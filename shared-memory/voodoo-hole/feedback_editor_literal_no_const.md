---
name: feedback_editor_literal_no_const
description: "Single-use editor literals (strings, numbers, colors) must NOT be extracted to constants — even when they \"feel\" semantic"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 233f7b52-d5c1-46a1-abf2-08159816ead4
---

Do NOT extract a literal to a `const` or `static readonly` in Editor-only code unless it is reused at 2+ call sites or is a meaningful shared tunable.

This applies to ALL of: strings, numbers, and `Color` values — even when they feel semantically named (e.g. per-rarity star characters, per-rarity display colors, layout sizes that happen to appear in CONSTANTS alongside reused values).

**Why:** The CLAUDE.md Editor-literal exception is explicit and broad. Violation was caught in `CollectionsItemDrawer`: star strings (`"★"`, `"★★"`, `"★★★"`) and per-rarity colors (`Color.white`, `new Color(0.35f, 0.65f, 1f)`, `new Color(1f, 0.82f, 0.25f)`) were extracted to `const`/`static readonly` fields — all single-use, editor-only, never localized. The user had to manually inline them.

**How to apply:** Before declaring any `const` or `static readonly` in an Editor file, ask: "Is this value used in 2+ places, or is it a shared tunable that multiple parts of this drawer read?" If no → leave it inline. "It's a named rarity color" or "it's a star glyph" does not qualify. Only promote when you can point to two actual usages.

[[feedback_code_style]]
