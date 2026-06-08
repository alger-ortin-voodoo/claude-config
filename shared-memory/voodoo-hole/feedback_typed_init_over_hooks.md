---
name: feedback_typed_init_over_hooks
description: Prefer a typed virtual Init override on a generic base over OnX template-method hooks
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dbc1a852-8248-4cee-b0b0-81c0b0ad67ae
---

When a generic middle-class base (e.g. `LiveEventWidget<TInstance>`) exists to give subclasses a strongly-typed instance reference and replace a verbose multi-interface `Init`, the user prefers exposing a **typed `public virtual void Init(TInstance)`** that subclasses override directly — NOT a non-virtual `Init(TInstance)` plus empty `OnInitialized()` / `OnClearingEventReference()` template-method hooks.

**Why:** The hooks add empty virtual methods and an extra `ClearEventReference` override on the base — more members, more indirection. The user finds the direct typed-`Init` override "less confusing and adds less noise." The theoretical robustness gain of hooks (subclass can't skip `base.Init`) was judged not worth the machinery for a small, slow-growing subclass set.

**How to apply:** For this kind of typed-base refactor, default to a `virtual` typed `Init(TInstance)` that the subclass overrides and calls `base.Init(...)` from; keep any subclass cleanup as a direct `ClearEventReference` override. Don't propose `OnInitialized`/`OnClearing*` hooks unless the user asks for the template-method guard. See [[feedback_simplicity_first]].
