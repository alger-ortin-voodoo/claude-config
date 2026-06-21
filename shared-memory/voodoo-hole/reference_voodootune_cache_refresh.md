---
name: reference-voodootune-cache-refresh
description: VoodooTune dashboard edits only reach the Editor/build after publishing to live AND re-caching the prebuilt data asset
metadata: 
  node_type: memory
  type: reference
  originSessionId: e2d0a1aa-e9dc-403e-949a-cc02336197a9
---

The Editor and builds do NOT read VoodooTune live — they load a prebuilt `VoodooTunePrebuiltData`
ScriptableObject from `Resources` (`VoodooTuneConfigurationLoader` / `VoodooTuneAssignationLoader`
call `VoodooTunePrebuiltData.GetAsAsset()`). After editing a config in the VoodooTune dashboard,
**two gates** must both pass before the change is visible at runtime:

1. **Publish** the change to live — the cacher fetches `GetLive`, not drafts/sandbox.
2. Run **VoodooSauce ▸ VoodooTune ▸ Cache Production Data** (or **Cache Staging Data**, matching the
   build's target env) — `VoodooTunePrebuiltDataCacher.CacheDefaultData` — to regenerate the asset.

Symptom of skipping this: the build silently runs the OLD config. First diagnosed on the Collections
probability-set change (HOL-7356): base sets with newly-added `LevelTags.Any` weren't cached, so the
build still had empty `TargetLevelTags`, which under the new fail-safe resolver logic went inert →
`ResolveForLevel: no matching set for level N`. Clearing the cache / re-caching resolved it.
