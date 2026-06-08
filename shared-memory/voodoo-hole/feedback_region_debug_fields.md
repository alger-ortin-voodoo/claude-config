---
name: feedback-region-debug-fields
description: The Debug sub-category inside FIELDS AND PROPERTIES is accepted project style — do not flag it as a violation
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aa0f74d0-3663-4b9e-aea3-5ea9aed9b1ed
---

The `// Debug` inline comment grouping private debug fields (e.g. `m_debugModule`) alongside their related public property overrides (`EventDebugModule`, `EnableLogs`, `LogChannel`) inside the `FIELDS AND PROPERTIES` region is intentional project style.

**Why:** The user explicitly accepted this pattern when it was flagged as a blocker during the Daily Missions Phase 2 review. The canonical sub-category list (Serialized Fields, Public Properties, Events, External Dependencies, Internal Collections, Internal Vars) is a guide, not an exhaustive list — `// Debug` is a valid additional group.

**How to apply:** Do not report the presence of a `// Debug` group inside `FIELDS AND PROPERTIES` as a region ordering or sub-category violation. The rule still applies to the ordering of the standard groups relative to each other.
