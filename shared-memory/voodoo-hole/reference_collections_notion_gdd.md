---
name: reference-collections-notion-gdd
description: "Notion GDD page for the Collections feature mirrors two C# defaults in code blocks — keep them in sync whenever the corresponding defaults change."
metadata: 
  node_type: memory
  type: reference
  originSessionId: f337fc54-906f-473e-b0b4-e228938b0150
---

The Collections GDD page on Notion has two code blocks that mirror C# defaults from this repo. Whenever those defaults change in code, the matching Notion code block must be updated in the same workflow.

**Notion page:** `https://www.notion.so/voodoo/Collections-35da0b481db480bd98e7c6ba19deb0d1` (page ID `35da0b481db480bd98e7c6ba19deb0d1`).

**Synced code blocks (both inside `<details>` toggles on the page):**

1. **`EconomyConfig.CollectionsRewards` full JSON catalog**
   - Toggle summary: *"Full Json example of the EconomyConfig.CollectionsRewards field"*
   - Mirrors the default string literal of `CollectionsRewards` in `Assets/Scripts/RemoteConfigs/Economy/EconomyConfig.cs` (just unescaped + pretty-printed).
   - User-supplied anchor: `#360a0b481db4809dba28c7c4337feef3`.

2. **`CollectionsLiveEventConfig.MilestonesData` "Full example"**
   - Toggle summary: *"Full example — one milestone with two 9-item sets"*
   - Mirrors the per-cohort `MilestonesData` value (see Appendix B in `Docs/Metagame/Collections/collections-plan.md`). The Notion block is a structural reference example, so it doesn't need every cohort's variants — keep it as a single representative milestone.
   - User-supplied anchor: `#35fa0b481db480c6aeb9d165aca5cf39`.

**How to apply:** Use `mcp__claude_ai_Notion__notion-update-page` with `command: "update_content"` and a `content_updates` array of `{ old_str, new_str }` pairs. Fetch the page first via `mcp__claude_ai_Notion__notion-fetch` to get the exact current content. Code-block content has no special escaping inside the fenced block — write JSON literally.

**Why:** User explicitly asked (2026-05-14) to keep these two Notion blocks in sync with code changes — the GDD is read by LiveOps and Game Design, so stale defaults there create real friction.

**Related:** [[user_profile]], [[feedback_review_on_edit]].
