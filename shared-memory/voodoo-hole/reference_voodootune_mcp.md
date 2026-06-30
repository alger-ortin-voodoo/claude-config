---
name: reference-voodootune-mcp
description: "VoodooTune MCP — Hole.io app_id, auth model, and remote-config class/AB-test conventions for creating configs via MCP"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 5a0e9efc-ea27-4eae-9e91-af0274dcfe35
---

The VoodooTune MCP (`mcp__voodootune__*`) exposes the full read+write VoodooTune API: classes
(remote configs), AB tests, cohorts, segments, layers, versions, publish, IAPs/offers/shops, etc.

- **Auth:** `whoami` shows the login (OAuth token, alger.ortin-castellvi@voodoo.io). The login token
  authorizes the API — `list_apps` and writes work without a per-app key (`list_configured_apps`
  returns empty `keys`). `add_api_key` is only needed for per-app QA keys.
- **Hole.io app_id:** `9a9671df-7c75-482f-abe9-6f7cf57fb2b4` (iosBundleId `com.nguyenvh.holeio`,
  androidBundleId `io.voodoo.holeio`; 3 subAppIds for variants/envs). Resolve others via `list_apps`
  or `get_app_id(bundle_id, platform)`.
- **Versions:** every write targets the **`wip`** version. **NEVER call `publish_version` via MCP** —
  the team always validates and fine-tunes in `wip` first, then promotes to `live` manually via the
  dashboard. Reads can target `live` or `wip`.
- **Remote-config class convention** (verified against the live `GamePhysicsConfig` class): VT class
  `technicalName` == the C# `[RemoteConfig]` class name exactly; `displayName` carries a ` [Samba]`
  suffix (Samba = the studio); each C# field is one attribute with `bool→boolean`, `float→float`,
  JSON-string→`json`; a single-instance class (`multiInstance:false`) holds one instance with the
  default `values` map and `enabled:true`. The VT class `description` should be sourced from the C#
  class's XML `<summary>` (keep them in sync). Create via `create_class`; fetch with
  `get_class(appId, version, classTechnicalName)`.
- **AB test:** `create_ab_test` (needs name, priority, segments[]) → `create_cohort`/`add_cohort`
  (control with `isControl:true`; variants carry `overrideValues:[{class, instances}]`) →
  `set_ab_test_state` to start → `publish_version`. Segments/layers via `list_segments`/`list_layers`.
- **Unity-side caveat:** publishing to VoodooTune isn't enough for the Editor/build — they read a
  prebuilt cached asset, so run the **"Cache Production Data"** menu after publishing. See
  [[reference-voodootune-cache-refresh]]. Inspect served values with `get_simulated_config` /
  `get_player_config`.

First used to plan the Suction Acceleration remote config + A/B test ([[project-surge-tuning]]).
