---
name: Feedback: Simplicity First
description: Always lead with the simplest approach — avoid over-engineering or adding unnecessary layers
type: feedback
---

Lead with the simplest, most idiomatic solution. Do not propose complex patterns (factory tuples, delegate injection, forwarding properties) when a straightforward one exists (constructor parameter, direct property access).

**Why:** The user had to repeatedly simplify my proposals during the PerkConfig design session — removing forwarding properties, suggesting constructor injection over factory tuples, removing unnecessary abstraction layers. These were all obvious simplifications I should have reached first.

**How to apply:** Before proposing any design, ask "is there a simpler way?" Start from the minimum viable approach and only add complexity when there's a concrete, present-day need — not hypothetical future requirements.
