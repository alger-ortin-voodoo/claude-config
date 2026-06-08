---
name: project-paginated-pages-base-cache
description: "In-progress (Sonnet session 2026-06-03) — pulling the paginated-screen Pages cache up to the base via abstract CollectPages(). If the code already reflects this, the work is done — delete this memory."
metadata: 
  node_type: memory
  type: project
  originSessionId: 2f538725-8491-49e3-b13f-1705539d99c8
---

The user wants to stop replicating the `Pages` caching boilerplate in every `UIPaginatedScreen<TParams>` subclass. Deferred (raised 2026-06-03 while leaving); to be done as its own small refactor, naturally alongside the broader UI-animation/paginated cleanup ([[project-uianimator-preview-refactor]]).

**Current state (after the just-applied bug fix):** each concrete screen overrides `protected abstract IReadOnlyList<IUIPaginatedPage> Pages` with a block-bodied getter that rebuilds in editor / caches at runtime (`if (m_pages == null || !Application.isPlaying) m_pages = new[]{ ... }`). The three screens: `SamplePaginatedScreen`, `ContinueOfferScreen` (Assets/Scripts/UI/Game/Screens/), `CollectionsContainerOpeningScreen` (Assets/Scripts/LiveOps/Collections/UI/Screens/OpenFlow/). The original `??=`-snapshot bug returned 3 nulls in the editor because the cache captured field values before they were assigned in the inspector.

**Target design (user's idea, refined):** make `Pages` a CONCRETE `protected` property on the base that owns the cache + editor-rebuild guard, and add `protected abstract IUIPaginatedPage[] CollectPages();` (or `GeneratePagesList()`) that heirs implement to just return `new IUIPaginatedPage[]{ m_fieldA, m_fieldB, ... }`. Base:
```
protected IReadOnlyList<IUIPaginatedPage> Pages
{
    get
    {
        if (m_pages == null || !Application.isPlaying) m_pages = CollectPages();
        return m_pages;
    }
}
```
Heirs lose the cache field, the `Application.isPlaying` check, and the `ReadOnlyCollection`/`using System.Collections.ObjectModel`. The explicit `IUIPaginatedScreen.Pages => Pages` bridge stays. File: `Assets/Scripts/Systems/UI/UIService/AuxTypes/PaginatedScreen/UIPaginatedScreen.cs`.

**Why:** removes duplicated, easy-to-get-wrong caching logic from every subclass (the snapshot bug proved it's a footgun) — aligns with the project's "Reuse over Duplication" principle.

**How to apply:** small, self-contained — can be its own commit or folded into the tomorrow's preview-refactor planning session.
