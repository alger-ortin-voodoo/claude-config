---
name: user-project-copies
description: User maintains three local clones of the same Hole.io project and shares Claude memory across all of them via NTFS junctions
metadata:
  type: user
---

The user keeps three local copies of the same Unity project so they can do parallel work without branch-switching:

- `D:\Voodoo\Hole.io` — primary dev environment, used for the active feature
- `D:\Voodoo\Hole.io_Release` — side fixes while a feature is in progress in the main copy
- `D:\Voodoo\Hole.io_Live` — third copy (purpose not fully clarified; likely live/release-branch work)

All three are the same project — rules, skills, and memory apply equally to all of them.

**Memory is shared across all three** via NTFS junctions:

- Canonical: `C:\Users\Alger Voodoo\.claude\projects\D--Voodoo-Hole-io\memory\` (real directory)
- `D--Voodoo-Hole-io-Release\memory` — junction → canonical
- `D--Voodoo-Hole-io-Live\memory` — junction → canonical

A leftover `memory.bak` may exist in the Release folder from when the junction was first set up — that's old state, not active memory.

**How to apply:** Treat any of the three folders as the same project. When writing memory from a Release or Live session, no special handling is needed — the junction transparently routes the write to the canonical folder, so it'll be visible in the other two next session. Sessions (`.jsonl` files) are NOT shared; only memory is.

**⚠ Project source files are NOT junctioned — they are three separate clones on disk.** Only the Claude memory folder is junctioned. Editing a `.cs` / prefab / asset in one copy does NOT propagate to the others. Before creating or moving files, confirm which copy the user is working in — the `Primary working directory` in the harness Environment may not match the project the loaded `CLAUDE.md` came from. When in doubt, ask.

**VS Code gotcha — sibling clone auto-discovery.** Because all three clones share the same GitHub remote (`VoodooStudios/Hole.io-Remaster`), some path in VS Code's git extension (or an extension we couldn't pinpoint despite log analysis) auto-opens sibling clones in the Source Control panel a few seconds after workspace activation. Workaround: `git.ignoredRepositories` in each project's `.vscode/settings.json` (which is `.gitignore`d, so it's local-only) listing the OTHER two clones' absolute paths — that blocks `openRepository()` at the git API boundary regardless of caller. Don't remove the setting; don't try to make it global (it would also disable git when one of the named paths is opened as the workspace).
