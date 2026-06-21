---
name: feedback-blank-lines-declarations-blocks
description: No blank line between variable declarations and the control-flow block they directly set up
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 01529177-66cc-4200-b252-7c4ba4d74627
---

When variable declarations exist solely to set up the immediately-following control-flow block (`for`, `foreach`, `while`, `if`, etc.), do NOT insert a blank line between the last declaration and the block keyword. Treat the declarations and the block as one unit.

The blank line (and the block comment, if any) goes *before* the declarations — not between them and the block.

```csharp
// ❌ WRONG
List<Foo> items = new List<Foo>();
int[] indices = { 0, 0 };

foreach (...)   // ← blank line here is wrong

// ✅ RIGHT
// Process each item...
List<Foo> items = new List<Foo>();
int[] indices = { 0, 0 };
foreach (...)   // ← no blank line; declarations and block are a unit
```

**Why:** Blank lines imply a semantic break. Declarations that only exist for the next block are part of that block's preamble, not a separate logic section.

**How to apply:** Whenever writing setup variables + a loop/conditional, flush the declarations to the block. The blank line separates the *previous* logic section from the comment+declarations+block group as a whole. Rule is codified in `~/.claude/rules/code-style.md` Comments section.
