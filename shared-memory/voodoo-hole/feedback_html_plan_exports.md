---
name: feedback-html-plan-exports
description: HTML exports of plan docs are personal reference files — never commit them
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 348b335d-7d3f-43e4-b8fd-a9717287f382
---

HTML exports of plan/spec docs (e.g. `*_plan.html`, `*_spec.html` under `Docs/`) are personal reference files for the user. They are always untracked and must NEVER be staged or committed.

**Why:** User keeps them locally for readability; they are not part of the project's versioned docs.

**How to apply:** When preparing commits, always exclude any `.html` files under `Docs/`. If the commit-preparer surfaces them, instruct it to skip them without asking the user.
