---
name: Feedback: Using statement removal — verify all references first
description: Before removing a using statement, grep for ALL types from that namespace in the file, not just the specific type being refactored
type: feedback
originSessionId: 207636e5-c329-4e88-9378-318fe655404b
---
When removing a `using` statement after a refactor, always grep the entire file for all types from that namespace — not just the one being moved/replaced. A file may import a namespace for multiple reasons (e.g. `using Voodoo.Holeio.UI.Game` for both `StageProgressionController` and other types like `GameStateController`). Removing the using based on a single-type check caused compilation errors.

**Why:** During the `LastGameStats` refactor, `using Voodoo.Holeio.UI.Game` was removed from `PowerUpMoreTime.cs` and `HomeScreen.cs` even though those files still used other types from that namespace.

**How to apply:** Before removing a `using Namespace.Path;`, run a grep for all non-using references to that namespace's types in the file. Only remove if the grep returns zero hits.
