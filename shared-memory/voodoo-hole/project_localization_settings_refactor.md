---
name: project-localization-settings-refactor
description: "Phase 6 localization tooling — current chunk status and what's pending"
metadata: 
  node_type: memory
  type: project
  originSessionId: 57b31aed-54e4-4d72-ab90-3994901b0879
---

Phase 6 Chunk 4 committed (424364ca8e, 2026-06-18): `LocalizationToolingSettings` SO created, all four Editor tools (`LocalizationSheetBootstrap`, `LocalizationStructureSync`, `LocalizationValidation`, `LeanToUnityImporter`) retrofitted to read from it, `LocalizationEditorConstants` deleted.

**Why:** D13 decision — centralize all duplicated hardcoded config (spreadsheet ID, tables root path, reports folder, excluded collection name) into a single Editor-only SO found by type.

**How to apply:** Next session is Chunk 3b (subfolder ownership + normalize flat tables into per-collection subfolders + cross-collection dup-key lint + `RemoveMissingPulledKeys` cutover flip). Depends on Chunk 4 being committed (done).

**Validations confirmed (2026-06-18):** Import Lean Dry Run (EN diffs = 0), Sync Structure (zero structural changes), Validate Missing Keys — all passed. `LocalizationToolingSettings.asset` populated and in the project. Chunk 4 fully done.

**Next:** Chunk 3b — subfolder ownership, normalize flat tables into per-collection subfolders, cross-collection dup-key lint, `RemoveMissingPulledKeys` false→true cutover flip.

Plan doc: `Docs/UI/Systems/Localization/Phases/unity_localization_migration_6_tooling_and_sheet_plan.md`
