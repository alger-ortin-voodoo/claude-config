---
name: feedback-reviewer-null-safety-nuance
description: "The `?.` / `??` rule applies ONLY to Unity Object types. Verify the type before flagging — plain C# objects are fine with these operators."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d47f2706-2547-48a7-bfda-72327cbb1dc8
---

The "no `?.` or `??`" rule applies **only** to Unity Object types (`MonoBehaviour`, `ScriptableObject`, `Component`, `GameObject`, `UnityEngine.Object`, and their subclasses). It does NOT apply to plain C# objects, POCOs, DTOs, services, interfaces that don't extend Unity types, structs, or primitives — those use `?.` / `??` normally.

**Why:** Unity overrides `==` on its Object types to return true for destroyed-but-not-garbage-collected objects, but `?.` / `??` bypass that check. Plain C# objects don't have this problem; their null check works correctly with the operators.

**How to apply:** When reviewing or writing code involving `?.` / `??`:
- If the LHS type is Unity-derived → use explicit `if (obj != null)` check.
- If the LHS type is anything else → `?.` / `??` are correct.
- If the type can't be determined from the current file (declared elsewhere) → do NOT flag as a violation. At most note it as P2: "verify `<var>` is not Unity-derived". Never assume.

This came from a real incident on 2026-05-19: `unity-code-reviewer` flagged `?.` on a plain C# object and the fix introduced a regression. Reviewer was overzealous — the rule is narrow, not blanket.
