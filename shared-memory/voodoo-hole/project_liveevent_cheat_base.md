---
name: project-liveevent-cheat-base
description: All live-event cheat panels now share CheatDebugPanelFoldout_LiveEvent for scheduling cheats
metadata: 
  node_type: memory
  type: project
  originSessionId: 41223457-40b1-4522-992c-6bf903319050
---

A reusable cheat-panel base `CheatDebugPanelFoldout_LiveEvent<TConfig, TData>` lives at
`Assets/Voodoo/Optimization/Others/Scripts/CheatDebugPanel/Foldouts/CheatDebugPanelFoldout_LiveEvent.cs`.
It provides `protected DrawSchedulingSubFoldout(screen, LiveEventInstance<TConfig,TData>)` (a "Scheduling"
subfoldout: live timers, lifecycle action buttons, read-only config/override diagnostics) plus shared
`FormatTimer`/`FormatDate`.

**All three live-event cheat panels now extend it and call `DrawSchedulingSubFoldout`:** Collections,
HoleEscape, and DailyMissions. Each keeps only its event-specific content; the scheduling cheats are no
longer copy-pasted. When adding a NEW live-event cheat panel, extend this base instead of rebuilding the
scheduling section.

Base created 2026-06-15 on `samba/release/2.45` (commits 27f539f9fb, 41a58fcca2, de1fad3c83); HoleEscape &
DailyMissions migrated on `samba/develop` (commits 66e0925336, a472274cd1) after release/2.45 was merged in.

**Why:** the scheduling cheats were copy-pasted per event; the base removes the duplication and gives every
event the same richer scheduling diagnostics.

Related: [[feedback-reuse-over-duplication]]
