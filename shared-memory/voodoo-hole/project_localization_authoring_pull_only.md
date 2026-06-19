---
name: project-localization-authoring-pull-only
description: Post-cutover localization authoring is Pull-only — Google Sheets is the single source of truth; nothing pushes to Sheets; Push / Sync-Structure tools were transitional and will be removed.
metadata: 
  node_type: memory
  type: project
  originSessionId: e2251fdc-7cfc-4484-9c9e-3e1967be2752
---

Post-cutover (Unity Localization migration, HOL-5677), the **Google Sheets spreadsheet is the single source of truth** for localization. Authoring is **Pull-only**: add keys + EN + translations directly in the per-domain Sheet tabs, then run `Samba/Localization/Sync/Pull All from Sheets` in Unity. **Nothing should push to Sheets.** The Push-All and Sync-Structure+Content tools were transitional (born from the pre-cutover "tables own the keys" model) and are expected to be removed soon.

**Why:** During the migration the Unity tables temporarily owned keys/EN, so Push existed as a transitional bridge. The end-state design is Sheet-as-source-of-truth, Pull-only. The local authoring guide (`Docs/UI/Systems/Localization/localization_authoring_guide.md`, Pull-vs-Push table) still lists Push as a routine op — that's stale vs. the intended model.

**How to apply:** When advising on the loca workflow or drafting team comms, present Pull as the only routine sync; treat Push / Sync-Structure+Content as admin/transitional, not team-facing. Never recommend Push.

Related: [[reference_localization_notion_docs]], [[project_localization_system_agnostic]].
