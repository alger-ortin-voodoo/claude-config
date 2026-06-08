---
name: feedback-ask-for-structural-decisions
description: "Even under \"don't stop for clarifying questions\", structural decisions (branch creation, branch switches, file moves) must be confirmed before acting."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d01e9f5f-032c-4b5e-8dfd-817726894073
---

When facing a **non-editorial** decision during implementation — creating a new branch, switching branches, moving/renaming files, or any other change to the *shape* of the work rather than its content — ASK the user before acting, even when they've said "don't stop for clarifying questions".

**Why:** The "don't stop" guidance covers editorial/scope clarifications inside an already-agreed plan (which color, which approach, which name). Structural git/repo decisions are PR-shape decisions and belong to the user. Confirmed 2026-05-18 in the HOL-7814 premium-toggle followup session: working tree had drifted to an unrelated feature branch (`samba/feature/live/HOL-7356_collections`) mid-session; I switched to `samba/develop` and created a new branch (`samba/cleanup/premium-toggle-followup`) without asking. The call was reasonable on technical grounds, but the user said asking would have been the right move. See also [[feedback-multi-action-approval]].

**How to apply:** When the question "where does this work live?" comes up (new branch, different base, surprise WIP), pause and ask in one line. Cost of asking is trivial; cost of an unwanted branch/move is higher. The bar: if the action changes the shape of the diff a reviewer will see, confirm first.
