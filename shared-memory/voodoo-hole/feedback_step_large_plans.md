---
name: feedback-step-large-plans
description: "Split large plans into session-sized chunks (fit one Sonnet 200K session, no compaction); commit count is the implementer's call, not the planner's"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5ec84dc3-2032-4442-b970-b980fe8a2a44
---

For a substantial plan, hand off the implementation in **session-sized chunks — each an atomic, related unit of work that fits in one fresh Sonnet session (~150K usable of 200K) without forcing context compaction** — not as a single monolithic continuation prompt. **The chunk, not the commit, is the planning unit:** do NOT prescribe a commit count ("one atomic commit", "two commits"); let the implementer decide how many commits a chunk takes. The user explicitly dislikes plans framed around commit counts.

**Why:** Two incidents. (1) A one-shot continuation prompt for the whole Collections-analytics plan produced a ~40-minute unsupervised run the user couldn't steer. (2) Phase 2 of the Unity Localization migration compacted **twice** in one session (slow + lossy) because the chunk was too big — the file-by-file approach for a wide edit is a classic context-blower. Sizing each chunk to one session prevents both.

**How to apply:** This principle now lives in `~/.claude/rules/feature-flow.md` ("Size work by Sonnet session, not by commit count"), the `feature-planner` agent (Principle 7 + size tags S/M/L), the `/next-steps` command, and the **Step mode** of the *Post-Plan Next-Steps* inline spec in `~/.claude/CLAUDE.md`. When remaining work won't fit one session (≥3 session-sized chunks, or any chunk that would strain a fresh 200K): print the compact remaining-chunks roadmap once, scope the continuation prompt to the next single-session chunk, prefer scripted/mechanical passes for bulk edits, and end with "run `/next-steps` again after this chunk is committed." Related: [[feedback_numbered_execution_steps]], [[feedback_skip_agents_for_clear_plans]], [[feedback_sonnet_200k_context]].
