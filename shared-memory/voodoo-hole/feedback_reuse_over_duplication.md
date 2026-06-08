---
name: feedback_reuse_over_duplication
description: "Before creating a new class/component/view/helper, search for an existing one and reuse/compose it instead of duplicating"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: db873872-7060-40b8-b8f6-1447c41cab43
---

Before writing a new class, component, view, or helper, grep for an existing implementation
that already does the job (or most of it) and **reuse or compose it** rather than writing a
parallel version. A "stub" is not an exemption — a stub still picks the architecture; only its
prefab/asset wiring may be deferred, never the reuse decision.

**Why:** This is a repeat occurrence, not a one-off. In the Collections opening flow,
`CollectionsSummaryItemView` was drafted as a "stub" that re-declared its own `Image` and rendered
only the sprite — bypassing `CollectionsItemView`, the context-free display view Phase 2D had
deliberately extracted for exactly this, and which `CollectionsItemSlot` /
`CollectionsItemShowcasePopup` already compose. The duplication's cost (no rarity/name, re-added
art-binding) stayed invisible until the rarity requirement surfaced. Project `CLAUDE.md` §1 now
carries a "Reuse over Duplication" bullet codifying this team-wide.

**How to apply:** When about to author a new display/view/service/util for a domain entity, first
`Grep` for an existing `*ItemView` / display view / service / helper for that entity. If one exists,
compose it (like `CollectionsItemSlot` composes `CollectionsItemView`) and add only the new
responsibility — never re-declare its fields (`Image`, rarity toggle, name text). Extend or compose
when it doesn't quite fit; create new only when nothing suitable exists.

Related: [[feedback_simplicity_first]], [[feedback_review_on_edit]].
