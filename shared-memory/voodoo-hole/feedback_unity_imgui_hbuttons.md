---
name: Feedback: Unity IMGUI horizontal button alignment
description: IMGUI BeginHorizontal does not distribute buttons evenly — a known Unity limitation
type: feedback
---

Do not attempt to "fix" uneven horizontal button spacing in Unity IMGUI custom inspectors. This is a known platform limitation: `BeginHorizontal` with multiple `GUILayout.Button` calls cannot be made to distribute buttons perfectly evenly across the row. Investigated extensively (stretchWidth, ExpandWidth, moving code to caller context, changing label styles) — none of it helps.

**Why:** Unity's GUILayout flex model doesn't offer true equal-width distribution like CSS flexbox. The user has confirmed this and accepted it as a known limitation.
**How to apply:** If a similar cosmetic misalignment appears in a future inspector, acknowledge it immediately as a Unity IMGUI constraint rather than spending time debugging.
