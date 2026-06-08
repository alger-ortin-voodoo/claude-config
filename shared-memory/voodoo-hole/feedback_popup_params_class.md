---
name: feedback-popup-params-class
description: "Popups get their own dedicated Params class, not a reused service-level params that includes unneeded fields"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95318041-9886-46a7-8ed9-311f5b3fae60
---

Each popup/screen should own a dedicated, minimal `Params : IUIScreenParams` nested class containing only the fields it actually needs.

**Why:** Reusing a service-level params class (e.g. `CollectionsService.UIInstanceScreenParams`) forces unrelated data (event instance, set ID) into a popup that only needs one item, making the dependency contract confusing and polluting the shared type with popup-specific concerns.

**How to apply:** When writing a new popup, define a nested `Params` class inside the popup type itself. At the call site, construct `new MyPopup.Params(...)` with only what the popup needs. If a set ID, event instance, or other context isn't consumed by the popup body, don't pass it.

**Corollary — avoid duplicating toggle logic:** When a rarity/state toggle uses enum values that already match state IDs 1:1, prefer `enum.ToString()` over duplicating a `RarityStates` const-string class from another view. The const-string class pattern exists to prevent raw magic strings — `ToString()` on a well-named enum is not a magic string.
