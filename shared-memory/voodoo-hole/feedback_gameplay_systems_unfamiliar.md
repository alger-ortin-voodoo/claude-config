---
name: feedback-gameplay-systems-unfamiliar
description: User is unfamiliar with core gameplay systems (unlike metagame/live/UI); be extra-careful planning & implementing gameplay work
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5a0e9efc-ea27-4eae-9e91-af0274dcfe35
---

Unlike the metagame, live-ops, and UI systems — where the user is an expert and reviews confidently —
the user is **unfamiliar with the core gameplay systems** (hole controller, falling-object physics,
eating/growth, bots, camera). They cannot review or validate gameplay changes with full confidence.

This surfaced during the Surge camera/physics tuning sprint (suction-acceleration planning).

**Why:** Self-review is the safety net for most of this codebase; for gameplay work that net is weak,
so correctness has to come from the change itself, not from the user catching mistakes.

**How to apply:** For gameplay-system work — prefer the smallest reversible change; reuse existing
patterns rather than inventing new gameplay architecture; default to ship-dark + behind a feature flag
so nothing changes until deliberately enabled; write explicit, concrete verification steps (what to
look at, what "correct" looks like); flag every assumption the user can't easily check; and lean harder
on `unity-code-reviewer` / `performance-guardian` / `debug-investigator` before declaring something
done. See [[project-surge-tuning]].
