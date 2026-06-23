---
name: project-skins-legacy-system
description: "Both skin managers (SkinManager + SkinsManager) and SpecialOfferV2 are legacy, pending a full refactor; don't treat them as the convention"
metadata: 
  node_type: memory
  type: project
  originSessionId: c71d4757-ce0c-4ef9-b903-3226a318a699
---

The skin feature runs on **two parallel managers**, both old and not following current project conventions:

- `SkinManager` — legacy **int-index** system (`skinIndex`, `PlayerPrefs`-backed unlocks, `UnlockSkinWithIAP`).
- `SkinsManager` (`Assets/Scripts/Metagame/Skins/SkinsManager.cs`) — newer **string-id** system (`PlayerData.Character`), but still legacy in style (public mutable fields like `currentSkinIndex`, direct `PlayerData` access, no SO-driven config).

The two are not unified: e.g. `SpecialOfferV2Controller` (also legacy) equips skins via the int-index system only and never touches `PlayerData.Character`. A full refactor/unification is pending.

**Why:** Future skin work should not mirror these patterns or assume they represent the house style — model newer systems (e.g. Collections) instead.

**How to apply:** When touching skins, prefer the string-id `SkinsManager.SelectSkin` path and the `SkinSelected` event as the single notification channel; scope changes tightly and flag bigger cleanups (e.g. encapsulating the public `currentSkinIndex` field, merging the two managers) as separate refactors rather than doing them inline. See [[feedback-reuse-over-duplication]].
