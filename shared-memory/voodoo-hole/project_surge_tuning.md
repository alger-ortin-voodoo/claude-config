---
name: project-surge-tuning
description: "Surge = camera/physics/movement tuning sprint; physics deck built around Etienne's 9 params"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6572310d-bd6f-48f1-8e59-48e2e7c12d60
---

"Surge" is a multi-day sprint (started 2026-06-29) tweaking the game's camera and physics/feel. Branch: `samba/surge/cf/camera-and-physics-tweaking`. Deliverables live in `G:\La meva unitat\Tech Docs\Surge` (note: on this machine the Drive root is `G:\La meva unitat\...`, NOT the `G:\Voodoo\La meva unitat\...` written in the brand-style rule / [[project-agentic-deck-voodoo]] — the mapping varies per machine; Voodoo logo PNGs are at `G:\La meva unitat\Tech Docs\Claude Agents Showcase\assets`).

Deliverables built with `surge-physics-deck-build.js` (in the Surge folder, pptxgenjs, Voodoo brand style, run with `NODE_PATH` → scratchpad node_modules since pptxgenjs isn't installed in-repo). Three decks: `surge-physics-parameters.pptx` (9 slides, Etienne's 9-param wishlist), `surge-camera-parameters.pptx` (7 slides, 4-layer camera reference), `surge-tuning-summary.pptx` (2-slide merged exec summary). Designer-facing, effect-first. No headless renderer on this machine (no LibreOffice / PowerPoint COM) → content-QA via text extraction only; user eyeballs the render. Two Notion tech-docs reviewed: Camera (`112a0b481db48058835fc39a94998d78`) and Hole Mechanic & Falling Objects (`322a0b481db480b38828d44d0c412d26`) — broadly match code; Hole doc cites gravity −100 vs code default −80 (confirm live remote value).

Camera = 4 layers: remote dials (GameplayCameraConfig: rig variant + per-level spring/lookahead arrays + shake toggle/factor + transition) are 🟢 remote; progression curves (CameraSettings SO), feel systems (VirtualCameraFraming prefab), shake profiles (CameraShakeConfig SO) are 🟡 authored.

Key finding (validated with Iván, lead gameplay dev): **8 of 9 params are tweakable today; only "suction acceleration" needs a new system.** Mapping of Etienne's terms → code:
- Gravity → `GamePhysicsConfig.Gravity` (−80, remote)
- Mass / Air resistance / Angular momentum → per-size `FallingObjectsOverrides` table (mass 3→250, drag, angularDrag; remote JSON)
- Friction & Bounciness → ride on each falling object's **physics material**, which has **3 sources**: (1) **Default material** = `Assets/Physics/DefaultMaterial.physicMaterial` (the Physics-settings default; material-less objects fall back to it) — its FRICTION is remote via `GamePlayConfig.defaultMaterialDynamicFriction`/`StaticFriction` (0.6, fetched via `VoodooSauce.GetItemOrDefault<GamePlayConfig>()`, applied in GameManager.Awake), its bounciness is authored on the asset; (2) **prefab-baked** materials (e.g. buildings use `Assets/Physics/BouncyObjects.physicMaterial`, friction 0.6/bounce 0.6) — authored; (3) **movables** (cars/people) get `HolePhysicsRevampConfig.MovablesPhysicMaterial` at spawn via `MovableAnimation.AttachPhysicsMaterialIfNeeded()` — authored. Felt value = object material COMBINED with the surface hit (hole Inner/Floor materials, remote). **Net: Friction = Live (default-material remote lever covers most objects); Bounciness = Needs-a-build (no remote object-bounce field; only the hole's bounce is remote).** Deck has a dedicated "Where grip & bounce come from" slide (physics deck slide 6, now 10 slides).
- **Bug found & fixed + committed (c1974112e8, GameManager.cs:115):** both friction assignment lines wrote `.dynamicFriction`; static-friction line now correctly sets `.staticFriction`.

Live GamePhysicsConfig (confirmed by user) **matches the script defaults exactly** — dashboard isn't overriding anything yet (Gravity −80, EatDelay −5, both hole materials, the full 20-row mass/drag/angular table). So Gravity live = −80 (the Notion Hole doc's −100 is stale). One orphan: the live config carries `HolePhysicsV236Enabled: true`, a field the current `GamePhysicsConfig` class no longer declares (V236 now only exists on local SOs like `HolePhysicsRevampConfigV236`) → silently ignored on deserialize; harmless, cleanable from dashboard.

Decks now state the exact config/SO/field ("Set in:" lines) for every parameter on all three decks; suction slide carries a **~1 day implementation-only estimate** (tuning excluded — user can't sell more than a day; feel-tuning would realistically be days-to-weeks gated on Etienne review, but is deliberately kept off the deck); camera deck recommends building NEW rig prefab(s) rather than editing existing ones (TBD in planning). Summary deck cards: group label top-left + status top-right, title, one-line description, mono "set in" ref at bottom (no legend strip — status text is on each card).
- Internal friction → `InnerHole`/`FloorHole` material friction (0.45/0.6, remote)
- Influence radius → hole trigger CapsuleCollider radius (scales w/ size; authored) + `QualityProfileConfig.ObjectSafetyRadiusRelativeMultiplier` (remote)
- **Suction acceleration → does NOT exist.** Objects fall in by gravity only. Needs a new inward-pull force system AND disabling `HoleUnblocker` (its bounce/spit forces would fight suction).

Status labels used in the deck (4 states): 🟢 Live·remote (VoodooTune) / 🔵 Live + build (live for the common case, build for the rest — Friction uses this: remote for default-material objects, authored for own-material ones) / 🟡 Needs a build (SO/prefab) / 🔴 New system. Friction = Live+build; Bounciness = Needs-a-build (no object-bounce is ever remote). Audience = designers/PM, effect-first. Camera + movement systems were explored but dropped from scope once Etienne's list landed.
