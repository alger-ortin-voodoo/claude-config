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

**Also refresh A/B-test cohorts that override the class.** A cohort override is a **full snapshot**, not a partial diff — VT rejects a partial `values` object (HTTP 422 `InvalidOverrideValues`, lists the omitted fields as "missing"), so a cohort that flips one field (e.g. `Enabled: true`) still pins ALL the tuning values and will NOT inherit new class defaults. Cohorts therefore drift on every default change and must be re-written with the new full value set via `update_cohort` (preserve each cohort's other-class overrides untouched). There is no "inherit from default" option for an overriding cohort. Find affected cohorts via `list_ab_tests(wip)` (grep the saved result for the class name — the response is large).
