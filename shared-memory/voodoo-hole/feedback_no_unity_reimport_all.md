---
name: feedback-no-unity-reimport-all
description: "NEVER trigger Assets/Reimport All or similar expensive Unity Editor operations. Wait for Unity's auto-detect or use the soft refresh_assets MCP tool. Never escalate on timeout."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d47f2706-2547-48a7-bfda-72327cbb1dc8
---

NEVER trigger expensive Unity Editor operations via Unity MCP without explicit user approval in this turn. Specifically:

- **`Assets/Reimport All`** — DO NOT CALL EVER. It nukes the import cache for every asset and reimports every texture, model, audio file, prefab, and scene from scratch. On Hole.io this is a **30-60 minute** hit that the user cannot abort. There is virtually no scenario where this is the right move from an agent.
- **`Assets/Reserialize Assets`** — slow, risky on interruption. Never call.
- Any "Reimport" / "Reserialize" / "Rebuild Library" menu path. Never call.
- Full builds (`Build/Build And Run`, etc.) — never call without explicit user request.

**Why:** Unity auto-detects `.cs` file changes via filesystem watcher and recompiles in seconds when the Editor regains focus. If a refresh seems stuck, that's usually Unity processing — not a problem to fix.

**How to apply:**
- For script changes: just wait. Unity picks them up on focus.
- If you genuinely need to force a refresh: use the `refresh_assets` MCP tool (equivalent to ctrl+R — soft script recompile only).
- **If `refresh_assets` times out: STOP and report to the user.** Never escalate to a heavier operation. A timeout means "Unity is busy", not "I should bring a bigger hammer".
- Treat anything that could take longer than ~30 seconds as a "needs user approval" gate. If you don't know how long a Unity menu item takes — DO NOT CALL IT without asking.

Incident: on 2026-05-19, an agent's `refresh_assets` call timed out. The agent escalated to `execute_menu_item("Assets/Reimport All")`, triggering a 30-60 minute full project reimport. First time it happened. Codifying so it doesn't happen again.
