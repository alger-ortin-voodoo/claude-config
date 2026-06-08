---
name: Feedback: Prefab Restructuring Checklist
description: Two rules to follow when restructuring a prefab's component hierarchy via MCP
type: feedback
---

**Rule 1 — Read before restructuring:** Before moving a component to a child GameObject, call `get_component_values` on the source object to capture all non-default settings (color, font size, style, etc.). Never assume default values are correct — carry over the exact existing values to the new location.

**Why:** During UITableSample_TextCell restructuring, the original TMP label had a non-white text color set in the prefab. I recreated the Label child from scratch using code defaults, resulting in white text invisible against the white row background.

**How to apply:** Any time a prefab restructure involves creating a new child to host an existing component, first read the original component values, then set all non-default properties on the new child explicitly.

---

**Rule 2 — Recompile before prefab changes:** After editing any C# script, trigger an asset refresh/recompile (`manage_asset_database` or `refresh_assets`) and confirm compilation is complete before opening or modifying any prefab that uses those scripts.

**Why:** Unity only recompiles scripts when it regains focus. During UITableSample_TextCell restructuring, the `[RequireComponent(typeof(TMP_Text))]` removal hadn't compiled yet, causing Unity to still enforce the requirement when I tried to remove TMP from the root.

**How to apply:** Whenever the workflow is "edit script → modify prefab", insert a refresh/recompile step between the two and verify no compile errors before proceeding.
