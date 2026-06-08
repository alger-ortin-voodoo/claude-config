---
name: Project: Perks System
description: Current state of the Perks feature (HOL-7086), committed and ready for testing
type: project
originSessionId: fac87a49-8465-4563-a44f-248bdf5a75a5
---
Perks system is fully implemented and committed on branch `samba/feature/live/HOL-7086_time-limited-no-ads`, merged up to date with `samba/develop` as of 2026-03-27.

**Why:** HOL-7086 — time-limited no-ads perk delivered via inventory (`ResourceType.PerkTimedNoAds`, amount = seconds).

**Folder:** `Assets/Scripts/Metagame/Perks/`
```
Perks/
├── AuxTypes/            → ActivationMode, PerkType
├── Data/                → PerkData, PerksPersistentData
├── Perks/               → IPerk, Perk, PerkFactory, TimedNoAdsPerk
├── PerksService.cs
└── PerksAnalyticsService.cs
```

**Key design decisions:**
- Inventory as delivery channel: rewards grant `ResourceType.PerkTimedNoAds` (amount = seconds); service immediately consumes and converts to UTC expiry timestamp
- `PerksService` registered in `GlobalServicesInstaller` after `BoostersService`
- `PerksConfig` (remote config) controls per-perk enabled flags
- `TimedNoAdsPerk.Activate/Deactivate` are stubs — TODO: integrate with `VoodooPremium.SetPremiumPeriod()`
- Debug API: `DEBUG_AddTime`, `DEBUG_ExpirePerk`, `DEBUG_ResetAllPerks`
- `ConsumeResourceFromInventory(perk, grantData)` propagates the grant's placement/subPlacement/placementId so analytics attributes the removal to the same source as the grant
- Each `Perk` subclass declares a `string PerkId` (snake_case, e.g. `"timed_no_ads"`) — used as part of the analytics event name `tl_{perkId}_game_activity`

**Analytics (added 2026-04-10):** `PerksAnalyticsService` fires `tl_{perkId}_game_activity` on perk expiry.
- Params: `levels_played` (JSON), `duration` (int seconds), `sessions_played` (int)
- Tracking state persisted in `PerkData` (3 new fields: `ActivationTimestampUtc`, `ActivationSessionCount`, `LevelsPlayed`)
- `PerksService` exposes `internal PersistentData` accessor
- Level ID = `StageProgressionController.Instance.CurrentStageName`; session delta = `GameData.SessionCount`
- Listens to `GameFinishedSignal` (not `GameSessionService.OnGameEnded`, which is scene-scoped)

**Current step:** Analytics implementation done. Ready for integration testing.
- Foldout placed in "New features" section of `CheatDebugPanel.cs`
- File: `Assets/Voodoo/Optimization/Others/Scripts/CheatDebugPanel/Foldouts/CheatDebugPanelFoldout_Perks.cs`

**How to apply:** Reference `Docs/Metagame/Perks/perks-system-plan.md` for full API and verification steps.
