---
name: project-liveevent-cheat-base
description: Reusable live-event scheduling cheat base exists; HoleEscape & DailyMissions panels still need migrating to it
metadata: 
  node_type: memory
  type: project
  originSessionId: 41223457-40b1-4522-992c-6bf903319050
---

A reusable cheat-panel base `CheatDebugPanelFoldout_LiveEvent<TConfig, TData>` now exists at
`Assets/Voodoo/Optimization/Others/Scripts/CheatDebugPanel/Foldouts/CheatDebugPanelFoldout_LiveEvent.cs`.
It provides `protected DrawSchedulingSubFoldout(screen, LiveEventInstance<TConfig,TData>)` (a "Scheduling"
subfoldout: live timers, lifecycle action buttons, read-only config/override diagnostics) plus shared
`FormatTimer`/`FormatDate`. `CheatDebugPanelFoldout_Collections` already adopts it.

Created 2026-06-15 on branch `samba/release/2.45` (commits 27f539f9fb, 41a58fcca2, de1fad3c83) — NOT yet
on `samba/develop`; must be merged/cherry-picked there before the migration below.

**Planned follow-up (user requested):** migrate the remaining live-event cheat panels —
`CheatDebugPanelFoldout_HoleEscape` (has its own `FormatTimer`) and `CheatDebugPanelFoldout_DailyMissions` —
to extend this base: re-parent, replace inline scheduling code with `DrawSchedulingSubFoldout(...)`, delete
their duplicated formatters/labels/buttons.

**Why:** the scheduling cheats were copy-pasted per event; the base removes the duplication and gives every
event the same richer scheduling diagnostics.

Related: [[feedback-reuse-over-duplication]]
