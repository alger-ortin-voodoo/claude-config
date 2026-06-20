---
name: project-localization-authoring-pull-only
description: Post-cutover localization authoring is Pull-only — Google Sheets is the single source of truth; nothing pushes to Sheets; Push / Sync-Structure tools were transitional and will be removed.
metadata: 
  node_type: memory
  type: project
  originSessionId: e2251fdc-7cfc-4484-9c9e-3e1967be2752
---

Post-cutover (Unity Localization migration, HOL-5677), the **Google Sheets spreadsheet is the single source of truth** for localization. Authoring is **Pull-only**: add keys + EN + translations directly in the per-domain Sheet tabs, then run `Samba/Localization/Sync/Pull All from Sheets` in Unity. **Nothing pushes to Sheets.**

The transitional/one-shot/push tooling was **removed 2026-06-20** (this session): `Push All to Sheets`, the `One-Shot (run once)` group (Migrate Key Columns to NoNote, Normalize Table Subfolders, Flip RemoveMissingPulledKeys), the `OneShot`/`Legacy` menu constants, and the dead `ClientSecret` settings field. `Sync Structure + Content` is now pull-only (reconcile + Pull). The permanent menu surface is **Pull All · Sync Structure · Sync Structure + Content · Validate\* · Fonts**.

**Why:** During the migration the Unity tables temporarily owned keys/EN, so Push existed as a transitional bridge. The end-state design is Sheet-as-source-of-truth, Pull-only.

**How to apply:** When advising on the loca workflow or drafting team comms, present Pull as the only sync direction. Never recommend or re-add Push. `Sync Structure` / `Sync Structure + Content` are admin tools (can prune tables), not routine team-facing ones.

Note: `ExcludeFirstTabAsLeanSource` (in `LocalizationToolingSettings`) still guards the retired Lean tab by **position (index 0)** — it must stay the first tab. Deleting that tab safely requires flipping the setting to `false` first (see [[reference-localization-notion-docs]] / the migration caveats).

Related: [[reference_localization_notion_docs]], [[project_localization_system_agnostic]].
