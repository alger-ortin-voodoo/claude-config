---
name: feedback-desktop-auto-mode
description: Desktop app gained native Auto mode (2026-06-10); rely on it — do NOT re-add a blanket PowerShell(*)/Bash(*) allow rule.
metadata:
  type: feedback
---

The Claude Desktop app added a native **Auto** permission mode on 2026-06-10 (the day after we built a workaround for its absence). Auto mode runs safe actions without prompting and uses background safety classifiers to gate risky ones.

**Why this matters:** yesterday's stopgap was a blanket `PowerShell(*)` rule in `~/.claude/settings.json` (see [[feedback-claude-config-autosync]]) to silence desktop PowerShell prompts. That rule was **removed** in favor of Auto mode, because an explicit `permissions.allow` entry *short-circuits* Auto's classifier (PowerShell would skip the safety check), and a blanket allow is a synced security liability.

**How to apply:** Do NOT re-add `PowerShell(*)` / `Bash(*)` / similar blanket allow rules to silence desktop prompts — enable **Auto mode** in the desktop UI instead. The CLI is unaffected either way (it runs `bypassPermissions`, so allow-rules are moot there). Only re-add a narrow rule if Auto mode proves to nag on a specific routine command, and prefer the narrowest exact-command form.

**Narrow rule added (2026-06-10):** Auto mode prompted on the next-steps clipboard copy, so `PowerShell(Set-Clipboard *)` is allow-listed in `settings.json` — it's the workflow's most-used cmdlet (the post-plan continuation-prompt copy) and benign. This is the intended pattern: narrow exact-cmdlet allow, NOT a blanket bypass.
