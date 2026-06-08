---
name: feedback-uistatetoggle-states
description: "UIStateToggle state IDs go in a static const-string class, never raw literals — even for enum-backed toggles"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f40754bd-c702-41db-bfcc-6bb08920c200
---

`UIStateToggle.SetState(string)` matches a state by raw string ID, and a typo silently no-ops (no compile error). So never pass raw string literals. Define the state IDs as `const string` in a nested `private static class` (mirrors `HomeScreenWidget.BaseStates`), e.g. `States`, `OwnedStates`, `RarityStates`.

**Why:** const strings are typo-safe at the call site, allocation-free (unlike `enum.ToString()`), and usable in `switch` case labels.

**How to apply:** **One const class per toggle**, named after that toggle (e.g. `CompletionStates`, `NavigationStates`, `OwnedStates`, `RarityStates`) — never lump multiple toggles' states into one shared `States` class, it's confusing about which IDs belong to which toggle. For purely-presentational states (InProgress/Completed, SingleSet/MultiSet, Owned/Empty) the const class is the whole story. For states backed by a domain enum (e.g. `CollectionsItemRarity`), still route through the const class **for consistency** — put a `public static string From(TEnum)` conversion helper inside that same const class rather than calling `enum.ToString()` directly. The user explicitly prefers this consistency even though `enum.ToString()` would feel less redundant. Place the const classes in the `AUX TYPES` region. See [[feedback-code-style]].
