---
name: Feedback: MCP GameObject Creation Checklist
description: Things to set explicitly when creating child GameObjects via MCP (layer, scale)
type: feedback
---

When creating a GameObject via MCP tools, Unity does NOT inherit properties from the parent automatically and does NOT auto-add RectTransform to plain GameObjects. Always set these explicitly:

**RectTransform on UI roots:** When creating a UI prefab root that only gets a custom MonoBehaviour added (no Image/TMP/etc.), Unity gives it a plain `Transform` — NOT a `RectTransform`. Explicitly add `RectTransform` as the first component before adding the cell/view script. Components like `Image` and `TextMeshProUGUI` have `[RequireComponent(typeof(RectTransform))]` and auto-add it, but custom scripts do not.

**Layer:** Set the new GO's layer to match its parent. Unity defaults all new objects to layer 0 (Default), ignoring the parent's layer. Use `modify_gameobject` or `set_component_field` to set it immediately after creation.

**Scale:** Ensure the RectTransform scale is (1, 1, 1). UI GameObjects must never have non-unit scale — size is controlled via RectTransform properties only. MCP-created GOs should default to 1, but verify if anything upstream might cause distortion.

**Why:** During UITableSample_TextCell restructuring, the new Label child ended up on the wrong layer and wrong scale. During UITableSample_TeamBadgeCell creation, the prefab root got a plain Transform instead of RectTransform because the cell script has no RequireComponent attribute.

**How to apply:** For any UI GO, add `RectTransform` first (before any custom script), then set layer, then add the actual component.
