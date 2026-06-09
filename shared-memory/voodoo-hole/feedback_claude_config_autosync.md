---
name: feedback-claude-config-autosync
description: The ~/.claude (claude-config) repo is EXEMPT from the no-commit gate — commit & push config/memory changes freely.
metadata:
  type: feedback
---

The personal config/memory repo at `~/.claude` (remote: `alger-ortin-voodoo/claude-config`) is **exempt from the "never commit/push without explicit per-turn approval" safety gate**.

**Why:** That gate protects *project* code and team branches. `claude-config` is a personal sync repo shared across the user's desktop + laptop; the whole point is that changes (memory files, settings, rules) propagate automatically. Asking for approval each time defeats the purpose, and the user explicitly asked to exclude it.

**How to apply:** When you make a meaningful change under `~/.claude` (memory, settings.json, rules), commit it with a semantic `Scope: Type - Description` message and push to `origin/main` without waiting for separate approval. The project-code commit gate (per [[user-project-copies]]) still applies in full to the Hole.io repos. A SessionStart pull + SessionEnd commit/push hook may be wired to automate this; manual semantic commits for substantive changes still preferred over generic auto-sync messages.
