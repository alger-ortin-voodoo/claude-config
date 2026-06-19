---
name: project-localization-system-agnostic
description: The Localization system is deliberately game-agnostic and per-project configurable; informs namespace + no-hardcoded-path decisions
metadata: 
  node_type: memory
  type: project
  originSessionId: 3b717a83-3e3e-48e4-812e-6e350a1138d3
---

The whole Localization system (HOL-5677, Unity Localization migration) is **intentionally designed game-agnostic and configurable for every Voodoo project**, not just Hole.io. That intent is the *why* behind two recurring patterns the user insists on:

- **Everything routes through ScriptableObjects, no hardcoded project paths** — e.g. `LocalizationToolingSettings` (spreadsheet id, provider, Tables/Reports folders, font-atlas configs, picker alphabets), the service/font settings SOs. Tools locate config by type (`FindAssets("t:…")`), not by path.
- **Permanent code lives under the agnostic `Voodoo.Localization` namespace**, never `Voodoo.Holeio.*`. The only game-specific code is the transient Lean→Unity migration glue, which is deleted at the Phase 9 cutover — so it also stays `Voodoo.Localization` (no churn to rename dying code).

**How to apply:** when organizing/namespacing localization code, treat the permanent surface as reusable Voodoo infrastructure: base ns `Voodoo.Localization`, `.UI` for runtime display components, `.Editor` for custom inspectors/property drawers; standalone tools stay in the base ns (editor-ness comes from the folder/assembly, not the namespace). Keep new config in SOs; never hardcode a project-specific path. Related: [[project-localization-settings-refactor]].
