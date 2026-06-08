---
name: project-uianimator-preview-refactor
description: "UIAnimator editor-preview refactor IMPLEMENTED (2026-06-04, 5 commits); manual editor verification pass still pending"
metadata: 
  node_type: memory
  type: project
  originSessionId: 2f538725-8491-49e3-b13f-1705539d99c8
---

The clean refactor of the `UIAnimator` editor-preview system is **implemented and committed** (2026-06-04, branch `samba/feature/live/HOL-7356_collections`, commits `23791f4d73`, `851054f031`, `a5f20d7a8f`, `d961651b7e`, `9f7f0341bc`). Plan doc: `Docs/UI/Systems/ui_animator_preview_refactor_plan.md` (all steps `[DONE]`).

**What shipped:**
- Canonical `UIAnimator.GetSelfAndNestedAnimators()` (self + nested `AnimatorsToTrigger` tree, deduped, cycle-guarded) consumed by all set-semantics callers; fixed two 1-level-depth latent bugs (`StopAllAnimations`, `IsPreviewAnimationPlaying`).
- Runtime `InternalShow/HideAsync` **deliberately kept recursive** (stateful subtree pruning + transitive `IsAwaitedWhenTriggered` awaiting — flattening would change game-wide timing). Documented in code; full unification = separate future ticket.
- Private `PreviewSession` replaced the 3 static fields; single-animator and transition previews are one path (cross-root dedup fixed a double-add bug). Static facade signatures unchanged — callers untouched.
- Session-owned save-once/restore-once original values + editor-only gate in `SaveOriginalValues` blocking edit-mode re-saves mid-preview (kills the historical prefab-corruption class structurally).

**Still pending — manual verification pass** (plan's Verification section): prefab corruption regression (spam preview + `git diff` prefab = clean), nested-animator preview Show/Hide/Stop/deselect, paginated-screen double consecutive transition + Hide All, `UIAnimationSample` test-all, StarResults preview, Play Mode smoke (interrupt a transition — covers `CompleteCurrentAnimation` + deeper Stop/IsPlaying runtime deltas).

Related: [[project-paginated-screen-transition-preview]].
