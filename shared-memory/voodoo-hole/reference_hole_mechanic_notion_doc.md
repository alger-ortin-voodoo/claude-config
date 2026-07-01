---
name: reference_hole_mechanic_notion_doc
description: "Hole Mechanic & Falling Objects Notion tech-doc — its HoleSuctionConfig table + gravity note mirror the C# defaults; keep synced"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 23ef45b1-92f2-4f7a-9a4d-cef181170d3f
---

Notion tech-doc "🕳️ Hole Mechanic & Falling Objects": https://app.notion.com/p/322a0b481db480b38828d44d0c412d26

Its **"🌀 Suction (Vacuum) Force → Remote config — HoleSuctionConfig"** table mirrors `HoleSuctionConfig` (param names + Default column), and the Falling Object section's gravity note mirrors `GamePhysicsConfig.Gravity`. Keep both synced when those C# defaults / field names change — especially while suction is being tuned (the defaults are a moving target; last synced 2026-07-01 to Strength 1000 / FalloffExponent 0 / FalloffReach 5 / DownwardBias 1 / MaxAcceleration 1000, gravity -80).

The page uses enhanced-markdown `<td>` table cells; edit via `notion-update-page` `update_content` with exact-match old_str/new_str (do not reformat the table). Pairs with the [[feedback_vt_csharp_lockstep]] discipline — treat this doc as a third sync target alongside the VT class and cohorts.
