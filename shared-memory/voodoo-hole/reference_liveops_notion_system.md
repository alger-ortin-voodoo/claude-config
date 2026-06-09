---
name: reference_liveops_notion_system
description: Live Ops generic-system Notion page — tech doc with the LiveEventConfig parameter table to keep in sync
metadata: 
  node_type: memory
  type: reference
  originSessionId: fb6b71be-f48d-4e9c-9ea9-cb7385c09948
---

The generic Live Ops system tech doc lives at https://app.notion.com/p/voodoo/Live-Ops-generic-system-210a0b481db48012942bd335ac617247 (page id `210a0b481db48012942bd335ac617247`). It documents the live-event FSM lifecycle (states + flowchart) and a **Config parameter table** mirroring base `LiveEventConfig` fields.

Keep that parameter table in sync when base `LiveEventConfig` fields change — e.g. `AcknowledgeEventFinished` gained an `Auto` value (no end-of-event ack + auto-advances the milestone each cycle, for cyclic popup-less events like Collections). The per-feature Collections GDD has its own copy of the same row — see [[reference_collections_notion_gdd]].
