---
name: project-localization-settings-refactor
description: Hardcoded paths/IDs in the Phase 6 localization tools need a settings SO — refactor pending on Chunk 2 design
metadata: 
  node_type: memory
  type: project
  originSessionId: c2fe4b14-dabb-4db0-82b7-08eee0ba2448
---

The Phase 6 localization Editor tools duplicate several hardcoded values across files:

- `SpreadsheetId = "1nbHhaCw8E0NmfhaxJcKwF4SEjRvFo7jH7VBaB8hZRow"` — in `LocalizationSheetBootstrap.cs` AND `LocalizationStructureSync.cs`
- `ProviderAssetPath = "Assets/ScriptableObjects/ServiceSettings/Localization/LocalizationSheetsServiceProvider.asset"` — in `LocalizationSheetBootstrap.cs` AND `LocalizationStructureSync.cs`
- `TablesDir = "Assets/ScriptableObjects/ServiceSettings/Localization/Tables"` — in `LocalizationStructureSync.cs` (and implicitly in Bootstrap's collection paths)
- Report directory path — repeated across multiple tools

**Why:** User flagged this as a frustrating pattern after Chunk 3a landed. A settings ScriptableObject should centralize all of these.

**How to apply:** Wait for the Chunk 2 session (`LocalizationValidation.cs`) to land on a settings object design, then do a single refactor pass across `LocalizationSheetBootstrap`, `LocalizationSheetSync`, and `LocalizationStructureSync` to consume it. Do NOT design a parallel settings shape — coordinate with whatever Chunk 2 decides.

**Status as of 2026-06-18:** Under discussion in the Chunk 2 implementation session. Refactor deferred until that design is confirmed.
