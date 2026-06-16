---
name: feedback-claude-config-autosync
description: The ~/.claude (claude-config) repo is EXEMPT from the no-commit gate — commit & push config/memory changes freely.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfdcc2c0-ee1f-49f6-b72b-328530197bcc
---

The personal config/memory repo at `~/.claude` (remote: `alger-ortin-voodoo/claude-config`) is **exempt from the "never commit/push without explicit per-turn approval" safety gate**.

**Why:** That gate protects *project* code and team branches. `claude-config` is a personal sync repo shared across the user's desktop + laptop; the whole point is that changes (memory files, settings, rules) propagate automatically. Asking for approval each time defeats the purpose, and the user explicitly asked to exclude it.

**How to apply:** When you make a meaningful change under `~/.claude` (memory, settings.json, rules), commit it with a semantic `Scope: Type - Description` message and push to `origin/main` without waiting for separate approval. The project-code commit gate (per [[user-project-copies]]) still applies in full to the Hole.io repos. Manual semantic commits for substantive changes are still preferred over generic auto-sync messages.

**Mid-work race — diagnostic shortcut (learned 2026-06-16):** a `SessionEnd` fire (tab-switch) mid-edit can auto-commit your *in-progress* config edits. Symptom: a file you just edited shows **no** `git status`/`git diff` change even though the text is on disk. Don't chase symlink/junction/skip-worktree theories — it's almost always that the auto-sync already committed it; confirm with `git show HEAD:<file> | grep <your-text>`. It can also leave a partial snapshot (some edits committed, later ones pending) and can unstage a manual `git add` if the hook fires between separate shell calls. So when committing config manually, **chain `git add … && git commit … && git push` in a single shell invocation** to close the race window.

**Automated hooks (active, 2026-06-09):** `SessionStart` → `scripts/sync-pull.ps1` (rebase-pull, fully silent, logs to `~/.claude/sync.log`); `SessionEnd` → `scripts/sync-push.ps1` (commit + push pending changes). **Desktop quirk:** the Claude Desktop app fires `SessionEnd`/`SessionStart` on tab-switch / resume cycles, NOT just real session end (the user runs 2-3 parallel sessions and switches constantly). So `sync-push.ps1` **debounces** — skips if any commit landed within 15 min — to avoid a burst of `Auto-sync` commits, and reads the SessionEnd `reason` from stdin (guarded by `[Console]::IsInputRedirected` so it never hangs) for logging. Same-machine sessions share files on disk and don't need git; the push only matters cross-machine, so the delay is free. Bootstrapping a new clone needs one manual `git -C "$env:USERPROFILE\.claude" pull` to receive the scripts before the hooks self-sustain.

**Reason-filtering is NOT viable (confirmed 2026-06-09):** both tab-switches AND a genuine app quit fire `SessionEnd` with `reason=other` — indistinguishable. So a "force-flush only on real quit" can't be done without also force-flushing on every tab switch (= spam). The time-debounce is therefore the permanent mechanism, not a stopgap. Verified across ~20 switch cycles: zero spam commits (every fire logged `clean -> skip`, since changes are committed semantically as work happens, leaving the tree clean at switch-time). Residual edge case (uncommitted changes present at a true quit → up to 15 min before cross-machine propagation) is accepted as not worth solving. Concurrent SessionStart pulls can race on the git lock during a multi-session restart burst — harmless, they abort safely and a later pull succeeds.
