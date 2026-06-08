---
name: feedback-ui-development-prereq
description: "Must read UI_DEVELOPMENT.md before any UI/Canvas work; localization rule lives there, not in code-style.md"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 189f86c4-3f37-47ad-a22b-4e9ca7db0504
---

Always read `Docs/Claude/UI_DEVELOPMENT.md` BEFORE writing any UI code (popups, screens, views, widgets). The CLAUDE.md §3 context-routing rule is a hard prerequisite — not optional.

**Why:** Key rules that are NOT in `code-style.md` live there:
- §4 Localization: use `LeanLocalizationTMPText` (not `TMP_Text`) for any translatable field; set `.PhraseName = key` dynamically (never call `LeanLocalization.GetTranslationText` directly).
- §1 Listener wiring: `RemoveListener` + `AddListener` (never `RemoveAllListeners`).
- §2 Serialized references: Mandatory vs Optional header grouping.

**How to apply:** Before writing the first `[SerializeField]` in any UI class, open `UI_DEVELOPMENT.md`. Also pass these rules explicitly to the `unity-code-reviewer` briefing — the reviewer won't load domain docs unless told to.

**Incident:** `CollectionsAlbumUnlockedPopup` was implemented with `TMP_Text` + `LeanLocalization.GetTranslationText()` instead of `LeanLocalizationTMPText` + `.PhraseName`. Neither the author nor the reviewer caught it because `UI_DEVELOPMENT.md` was never read.
