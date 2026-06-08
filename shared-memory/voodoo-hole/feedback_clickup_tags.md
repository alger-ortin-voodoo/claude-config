---
name: ClickUp tag API workaround
description: add_tag_to_task API fails with "Team not authorized" — use tags param in create_task instead
type: feedback
originSessionId: a2ba5c51-526c-490e-8da4-0155e8946229
---
The `clickup_add_tag_to_task` MCP tool fails with "Team not authorized" for this workspace. For new tasks, set tags via the `tags` parameter in `clickup_create_task` instead. For existing tasks, inform the user they need to add tags manually.

**Why:** Discovered during Skip Ads task restructuring — all 5 add_tag calls failed.
**How to apply:** Always use the `tags` param at creation time; don't plan a separate tag-adding step for existing tasks.
