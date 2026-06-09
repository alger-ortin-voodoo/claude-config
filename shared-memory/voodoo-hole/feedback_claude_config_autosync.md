---
name: feedback-claude-config-autosync
description: The ~/.claude (claude-config) repo is EXEMPT from the no-commit gate — commit & push config/memory changes freely.
metadata:
  type: feedback
---

The personal config/memory repo at `~/.claude` (remote: `alger-ortin-voodoo/claude-config`) is **exempt from the "never commit/push without explicit per-turn approval" safety gate**.

**Why:** That gate protects *project* code and team branches. `claude-config` is a personal sync repo shared across the user's desktop + laptop; the whole point is that changes (memory files, settings, rules) propagate automatically. Asking for approval each time defeats the purpose, and the user explicitly asked to exclude it.

**How to apply:** When you make a meaningful change under `~/.claude` (memory, settings.json, rules), commit it with a semantic `Scope: Type - Description` message and push to `origin/main` without waiting for separate approval. The project-code commit gate (per [[user-project-copies]]) still applies in full to the Hole.io repos. Manual semantic commits for substantive changes are still preferred over generic auto-sync messages.

**Automated hooks (active, 2026-06-09):** `SessionStart` → `scripts/sync-pull.ps1` (rebase-pull, fully silent, logs to `~/.claude/sync.log`); `SessionEnd` → `scripts/sync-push.ps1` (commit + push pending changes). **Desktop quirk:** the Claude Desktop app fires `SessionEnd`/`SessionStart` on tab-switch / resume cycles, NOT just real session end (the user runs 2-3 parallel sessions and switches constantly). So `sync-push.ps1` **debounces** — skips if any commit landed within 15 min — to avoid a burst of `Auto-sync` commits, and reads the SessionEnd `reason` from stdin (guarded by `[Console]::IsInputRedirected` so it never hangs) for logging. Same-machine sessions share files on disk and don't need git; the push only matters cross-machine, so the delay is free. `sync.log` records every fire's reason → use it to refine to precise reason-filtering later (and maybe drop the debounce). Bootstrapping a new clone needs one manual `git -C "$env:USERPROFILE\.claude" pull` to receive the scripts before the hooks self-sustain.
