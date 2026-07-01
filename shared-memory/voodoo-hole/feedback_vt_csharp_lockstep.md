---
name: feedback_vt_csharp_lockstep
description: "Always keep the VoodooTune remote config class in sync with its C# [RemoteConfig] script — proactively, not only when asked"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 23ef45b1-92f2-4f7a-9a4d-cef181170d3f
---

Whenever a C# `[RemoteConfig]` class changes, keep the matching VoodooTune class in lockstep in the same effort — don't wait to be asked. This covers **default values AND schema**: added/removed/renamed fields and type changes, not just value edits. Update the `wip` instance/attributes via `update_class` (never publish).

**Why:** the C# property initializers are only the fallback; live/QA builds read VT. If they drift, the game behaves differently from what the code implies and tuning done in the Physics window (which seeds from the live config) won't match production.

**How to apply:** after editing a `[RemoteConfig]` class, `get_class(wip)`, diff against the C# fields/defaults, and propose the reconciling `update_class` write (preview + explicit confirmation per VT rules). Confirmed on the Hole Suction tuning (2026-07-01). See [[reference_voodootune_mcp]] and Docs/Claude/VT_MCP.md.
