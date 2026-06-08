---
name: feedback-code-style
description: Coding style preferences and conventions established during Perks system development
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 916220d2-3829-4d47-aefa-9d3e912229f4
---

All rules are now codified in CLAUDE.md. Key ones established during this project that are easy to miss:

- Empty line before inline comment unless previous line is an opening brace
- Braceless `if` only when condition and action are on the same line; never split across lines
- Multi-line signatures/calls: one param per line, closing `)` on its own line
- Constants: PascalCase (`PersistentDataKey`, not `PERSISTENT_DATA_KEY`)
- GETTERS/SETTERS region only for classes with multiple simple accessors; otherwise use a descriptively named region
- Method placement by role, not visibility: init-only helpers go in INITIALIZATION/FINALIZATION; thematically cohesive groups get their own named region
- No empty lines between `#region`/`#endregion` tags and their content
- Never use `??` or `?.` on Unity objects (MonoBehaviour, Component, GameObject, etc.) — Unity overrides `==` but not the CLR null-check behind these operators, so destroyed objects may pass through. Use explicit `if (x == null)` or ternary with `!= null`. Safe on plain C# types (string, delegates, List, etc.).
- Single-line `/// <summary>text</summary>` is only acceptable for public properties. Types and methods must use the multi-line form even when the text is short.

**Why:** These were all caught during a thorough iterative review of the Perks system. The user updates CLAUDE.md in real time as rules are confirmed.
**How to apply:** Before generating any C# code, review CLAUDE.md — the user keeps it authoritative and current.
