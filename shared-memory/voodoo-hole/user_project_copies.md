---
name: user-project-copies
description: User maintains three local clones of the same Hole.io project sharing Claude memory via NTFS junctions; canonical store lives in the private claude-config sync repo (desktop+laptop)
metadata:
  type: user
---

The user keeps three local copies of the same Unity project so they can do parallel work without branch-switching:

- `D:\Voodoo\Hole.io` — primary dev environment, used for the active feature
- `D:\Voodoo\Hole.io_Release` — side fixes while a feature is in progress in the main copy
- `D:\Voodoo\Hole.io_Live` — third copy (purpose not fully clarified; likely live/release-branch work)

All three are the same project — rules, skills, and memory apply equally to all of them.

**Memory is shared across all three** via NTFS junctions, and the canonical store is now under the synced config repo (relocated 2026-06-08):

- Canonical (real directory): `C:\Users\Alger Voodoo\.claude\shared-memory\voodoo-hole\`
- `D--Voodoo-Hole-io\memory` — junction → canonical
- `D--Voodoo-Hole-io-Release\memory` — junction → canonical
- `D--Voodoo-Hole-io-Live\memory` — junction → canonical

A leftover `memory.bak` may exist in the Release folder from when the junction was first set up — that's old state, not active memory.

**Config sync repo:** `~/.claude` is a git repo (private, `alger-ortin-voodoo/claude-config`) tracking only portable config via an ignore-everything-then-allowlist `.gitignore` (`CLAUDE.md`, `settings.json`, `keybindings.json`, `commands/`, `skills/`, `agents/`, `rules/`, `scripts/`, `shared-memory/`). It syncs this desktop with a laptop. On the laptop the canonical store lives at `C:\Users\Alger\.claude\shared-memory\voodoo-hole` (note: laptop user profile is `Alger`, not the desktop's `Alger Voodoo` — junction *targets* are per-machine absolute paths and are NOT synced; only the tracked files under `shared-memory/` are). The laptop has two clones, both junctioned to that store:
- `C:\Voodoo\Hole` → slug `C--Voodoo-Hole`
- `C:\Voodoo\Hole_Release` → slug `C--Voodoo-Hole-Release`

Secrets (`.credentials.json`), `settings.local.json`, `projects/`, `sessions/`, etc. are ignored.

**How to apply:** Treat any of the three folders as the same project. When writing memory from any copy, no special handling is needed — the junction routes the write to the canonical folder. **But memory now lives inside the git repo: to sync a memory change to the laptop it must be committed and pushed** (the user does this; never auto-commit). Sessions are NOT shared *through this git repo* — CLI `.jsonl` transcripts under `projects/` and the Desktop session store in AppData are both untracked. **However, Claude Desktop itself cloud-syncs its sessions across machines via the signed-in account** (verified 2026-06-21: desktop sessions appeared on the laptop with no git involvement). Only memory + portable config travel through the git repo. Desktop session/grouping storage details: [[claude-desktop-session-storage]].

**⚠ Project source files are NOT junctioned — they are three separate clones on disk.** Only the Claude memory folder is junctioned. Editing a `.cs` / prefab / asset in one copy does NOT propagate to the others. Before creating or moving files, confirm which copy the user is working in — the `Primary working directory` in the harness Environment may not match the project the loaded `CLAUDE.md` came from. When in doubt, ask.

**VS Code gotcha — sibling clone auto-discovery.** Because all three clones share the same GitHub remote (`VoodooStudios/Hole.io-Remaster`), some path in VS Code's git extension (or an extension we couldn't pinpoint despite log analysis) auto-opens sibling clones in the Source Control panel a few seconds after workspace activation. Workaround: `git.ignoredRepositories` in each project's `.vscode/settings.json` (which is `.gitignore`d, so it's local-only) listing the OTHER two clones' absolute paths — that blocks `openRepository()` at the git API boundary regardless of caller. Don't remove the setting; don't try to make it global (it would also disable git when one of the named paths is opened as the workspace).
