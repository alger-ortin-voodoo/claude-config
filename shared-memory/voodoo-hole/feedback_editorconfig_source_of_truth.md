---
name: feedback-editorconfig-source-of-truth
description: .editorconfig is the single source of truth for formatting/naming; public fields are PascalCase
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ace01621-d844-4664-84e1-539304573753
---

The project's `.editorconfig` (at the repo root) is the ONLY source of truth for formatting and naming styles. Judge style against it — never infer conventions from surrounding code, which may be non-conforming legacy.

**Why:** I once flagged a PascalCase public-field rename as "misformatting" by inferring camelCase from neighboring classes (`BaseEventMilestone.id`, `HoleEscapeMilestone.playerCountPerStage`). Those are legacy non-conformers — `.editorconfig` actually mandates **PascalCase** for public fields. I reached a confidently wrong conclusion by trusting neighbors over the config.

**How to apply:** Read `.editorconfig` before judging any naming/formatting question. Confirmed rules: public fields → **PascalCase**; properties → PascalCase; private/protected fields → `m_` + camelCase; private static → `s_` + camelCase; parameters → camelCase; interfaces → `I` + PascalCase; const & `static readonly` → PascalCase. Gotcha: the public-field rule is misleadingly *named* `public_fields_should_be_camel_case` but its `.style` is `pascal_case_style` — the `.style`/`.capitalization` line wins, not the rule name. For JSON-serialized data classes, keep the C# field PascalCase and use `[JsonProperty("camelCaseKey")]` to define the wire key. Deviate from `.editorconfig` only to reinforce a rule or define a deliberate exception. Related: [[feedback_code_style]].
