---
name: feedback-clickup-comment-formatting
description: "ClickUp comments via MCP don't render markdown bold/headers; inline code backticks do work"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f40754bd-c702-41db-bfcc-6bb08920c200
---

ClickUp task comments created through the MCP (`clickup_create_task_comment`) render almost NO markdown structure. Inline `code` (backtick) is the only thing that survives. `**bold**`, `#`/`##` headers, AND markdown bullet lists (`- ` / `* `) all leak through as raw characters or collapse into unreadable runs — the user had to redo both bold and bullet lists by hand.

**Why:** two handover comments needed manual cleanup — first the `**bold**`, then the bullet lists.

**How to apply:** Write ClickUp comments as plain prose with blank-line-separated short paragraphs. Only inline `` `code` `` for field/type names and state IDs is safe. Do NOT use `**bold**`, `#` headers, or `-`/`*`/`•` bullet lists. If you need a list, use separate short lines or fold items into a sentence. Keep it readable with zero markdown styling. See [[feedback-clickup-task-creation]].
