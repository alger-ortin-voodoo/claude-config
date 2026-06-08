---
name: project-mobile-only-targets
description: "Hole.io only ships iOS/Android — Editor errors under a Standalone build target are invalid QA reports, not bugs to fix"
metadata: 
  node_type: memory
  type: project
  originSessionId: 05caf49a-28fe-41fa-a1f9-3e81f5b775f1
---

The project is only meant to run with the Editor build target set to iOS or Android. Running
under Standalone (e.g. Windows) is an unsupported misconfiguration.

**Why:** QA (Jan) reported a NullReferenceException from
`GameNotificationsUtils.ScheduleNotification` (2026-06-05) that only reproduces when the
Editor's active build target is Standalone — `GameNotificationsManager.Initialize()` only
creates a `Platform` under `#if UNITY_ANDROID` / `#elif UNITY_IOS`, so `CreateNotification()`
returns null. Alger declined fixing it: wrong build target was an accidental overlook, not a
supported scenario.

**How to apply:** When an Editor-only exception involves platform-conditional code
(`#if UNITY_ANDROID/UNITY_IOS`), first check the reporter's build target before investing in
a fix. Guard-clause fixes for Standalone-only failures are not wanted unless explicitly asked.
