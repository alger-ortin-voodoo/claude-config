---
name: project-localization-settings-refactor
description: "Phase 6 localization tooling — current chunk status and what's pending"
metadata: 
  node_type: memory
  type: project
  originSessionId: 57b31aed-54e4-4d72-ab90-3994901b0879
---

Phase 6 Chunks 1, 2, 3a, 4, 5 all committed (2026-06-18). Only **Chunk 3b** remains.

**Chunk 5 added (5dd8c2fe74, 2026-06-18):** `KeyColumnNoNote` subclass suppresses inert numeric Key ID cell notes from Google Sheets sync tabs (D14 decision). `PushFields.ValueAndNote` kept so push clears existing notes. Both `ConfigureExtension` paths updated; `MigrateKeyColumnsToNoNote` one-shot menu item added; migration run + Push All confirmed.

**Why:** Project is string-keyed (`LocalizationKeyResolver` resolves by string, never by numeric ID); the stock `KeyColumn` note was pure editor noise.

**How to apply:** Next session is Chunk 3b — the only remaining Phase 6 work. Continuation prompt is in the clipboard from the last session (see `/next-steps` output).

**Chunk 3b scope:** subfolder ownership (normalize flat tables into per-collection subfolders via `AssetDatabase.MoveAsset`), cross-collection duplicate-key lint in `LocalizationValidation`, `RemoveMissingPulledKeys` false→true cutover flip menu item. Touches `LocalizationStructureSync.cs` and `LocalizationValidation.cs`. Pause after normalize for user to eyeball subfolders + Addressables in the Editor.

Plan doc: `Docs/UI/Systems/Localization/Phases/unity_localization_migration_6_tooling_and_sheet_plan.md`
