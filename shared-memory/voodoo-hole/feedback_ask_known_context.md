---
name: feedback_ask_known_context
description: "When the user likely already knows an answer, ask instead of spending tool calls reconstructing it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: efbf605a-615c-4881-8b0f-f0fab0f50e56
---

When verifying something the user has direct knowledge of — whether a serialized field got assigned, whether a scene/file change was intentional, where an object lives — ask them rather than reconstructing the answer through a chain of greps/diffs.

**Why:** During the HOL-5677 localization commit prep I spent several tool calls (git diff, grepping for the asset guid, locating the installer prefab) to determine that `Preload.unity` was unrelated drift and that the settings SO was assigned on the installer prefab. The user already knew both and noted we'd have finished much sooner if I'd just asked.

**How to apply:** When commit-prep or investigation hits a question the user can answer from their own recent actions ("did you intend this change?", "did you assign X?", "is this file always noisy?"), ask a one-line question before launching an investigation. Reserve tool-call reconstruction for things the user can't readily answer or when they're away. Complements [[feedback_agent_usage]] (direct tools over agents) and [[feedback_ask_for_structural_decisions]].
