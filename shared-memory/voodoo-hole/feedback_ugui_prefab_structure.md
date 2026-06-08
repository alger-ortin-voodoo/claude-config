---
name: Feedback: UGUI Prefab Single Responsibility
description: Prefab root should only hold the cell script; visual components (TMP_Text, Image) go on dedicated child GameObjects
type: feedback
---

Each GameObject in a UGUI prefab should have one responsibility. The prefab root carries only the main script and RectTransform. Visual components (TMP_Text, Image, etc.) must live on dedicated child GameObjects — never on the same object as the prefab root.

**Hierarchy visual order:** Order child GameObjects to match their visual layout — top to bottom, left to right. Exception: when Unity's draw/render order requires otherwise.

**Why:** Personal preference — the user dislikes GameObjects having more than one responsibility (e.g. being both the prefab root and a text field holder).

**How to apply:** When creating or proposing any UGUI cell prefab (or any prefab in general), always put TMP_Text, Image, and similar UI components on named child GameObjects (e.g. "Label", "Icon"), not on the root. The root holds only the MonoBehaviour script + RectTransform. Rule added to personal CLAUDE.md.
