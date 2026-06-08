---
name: feedback-no-session-history-in-comments
description: "Don't bake \"we tried X and realized Y\" reasoning from the current session into source comments — readers don't have that context."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d01e9f5f-032c-4b5e-8dfd-817726894073
---

Comments must explain things from the perspective of a reader opening the file fresh. Do not embed iteration history from the current session — phrases like "we used X instead of Y because Y would be stale at this point", "the previous version did Z but…", or callouts about alternatives that were considered and rejected. Those make sense in chat but confuse readers who only see the final code.

**Why:** A future programmer reading the file doesn't share the session's back-and-forth. Mentioning "IAPService.IsPremium would be stale here because…" reads as cryptic in isolation — they'd have to investigate something that, from their vantage point, isn't even in the code. Confirmed 2026-05-18: I left a "use the argument instead of IsPremium because IsPremium would be stale" comment after a back-and-forth refining the callback; user flagged it as session-iteration noise. See also [[feedback-code-style]] (general: comments explain non-obvious why, not what or session history).

**How to apply:** When tempted to write "we use X instead of Y because…", ask whether a reader who has never seen Y would understand the comment. If not, drop it — or rewrite it as a positive statement about X alone. Keep comments grounded in invariants, constraints, or surprising-to-a-fresh-reader logic; not in the path we took to get there.
