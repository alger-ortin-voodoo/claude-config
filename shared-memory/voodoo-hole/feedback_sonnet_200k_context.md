---
name: feedback-sonnet-200k-context
description: User runs Sonnet at the default 200K window (not 1M); bias Opus→Sonnet switches toward /clear + self-contained prompt
metadata: 
  node_type: memory
  type: feedback
  originSessionId: eccc47b6-2b2f-40dd-849c-7f399e083753
---

The user deliberately uses Sonnet at its **default 200K context window**, never the 1M long-context beta. On their Max plan the 1M window meters at API usage rates (~$3/$15 per Mtok, with a premium step-up above 200K) that fall *outside* the flat subscription, so enabling it risks invoice surprises.

**Why:** Avoiding out-of-plan usage-credit billing. The "draws from usage credits" wording in-app is the signal that 1M is API-rate metered, not plan-covered.

**How to apply:**
- **Never recommend enabling the 1M context window.** Assume Sonnet = 200K.
- When recommending an Opus→Sonnet switch, factor **context headroom**, not just cache-miss. A long Opus planning session (big transcript, many file reads, global `CLAUDE.md` + deferred-tools dumps) often exceeds what fits comfortably in 200K.
- If the current context is heavy, prefer **`/clear` → switch to Sonnet → paste a self-contained continuation prompt** over continuing in place. The switch discards the warm cache regardless, so continuing only buys the already-read files — rarely worth surrendering 200K of headroom and risking early compaction mid-build.

Reflected in the `/next-steps` command (`~/.claude/commands/next-steps.md`). Relates to the model-switch cache-miss weighting in [[feedback-code-style]] / global CLAUDE.md Model Switching Reminders.
