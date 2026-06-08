---
name: Feedback: Commit Message Types
description: Guidelines for choosing the correct Change Type in commit messages
type: feedback
originSessionId: ce511119-ab3a-4f00-afaa-b52995e00d37
---
**Personal CLAUDE.md overrides project CLAUDE.md commit rules (Section 5).** The personal format is `Scope: Change Type - Description` with no mandatory ClickUp ticket prefix — tickets are only needed for fixes that have an actual ClickUp ticket. Do not apply the project's `[HOL-XXXX]` prefix rule when the user's personal rules apply.

**Change type decision guide:**
- **Development** — new intentional logic or features.
- **Refactor** — restructuring existing code without changing behaviour.
- **Fix** — correcting something broken (use `[HOL-XXXX]` prefix when a ticket exists). **This is the ONLY type that gets a ticket prefix — Development, Refactor, and all other types never get one, even when working on a ticketed feature branch.**
- **Setup** — configuring the environment or tooling: `.gitignore`, `.editorconfig`, project settings, CI config, package manifests.
- **Cleanup** — removing dead code, unused files, stale `.meta` files, or tidying existing logic with no behaviour change.
- **Documentation** — changes to comments, XML docs, region structure, spec/plan/design markdown files. Applies to both code-level docs (XML headers, comments, regions) AND standalone doc files (specs, plans, READMEs).
- **Polishing** — visual/UX tweaks (spacing, colors, animations, feel). NOT for code documentation improvements.
- **Content** — game content and data (remote config values, localization strings, asset references). NOT for developer-facing documentation.
- **Assets / Optimization / Debug** — as described by the names.

**Why:** The types were previously underspecified, leading to Setup changes (e.g. `.gitignore` edits) being miscategorised as Cleanup.

**How to apply:** Ask "is this configuring the project, or removing something that shouldn't be there?" — the former is Setup, the latter is Cleanup.

**Description style:** Focus on the purpose and intention of the change — what it achieves and why — not the technical implementation ("renamed field X", "changed loop bound from 0 to 1"). The diff already shows what changed; the message should explain what the user gains or what problem it solves.

**Why:** A message like "ShuffleWithSeed now keeps index 0 fixed" describes the mechanism; "The default skin is now always kept at the first slot" describes the outcome. The latter is what belongs in the commit.

**How to apply:** Before finalising a description, ask "does this explain what the user/player/developer gains, or does it just describe the code change?" If the latter, rewrite.

**Concision — keep it short.** Prefer **1 sentence** for the description; reach for a second only when the *why* genuinely needs it. Hard cap: 2 sentences (matches the personal CLAUDE.md rule).

**Specifically: never enumerate components / files / sub-changes.** If you're tempted to write "X, Y, and Z" or list service/config/persisted-data/etc., you're describing the diff, not the purpose. Cut the list. The reader can see the file list and diff in `git show`.

**Why:** User explicitly flagged 2025-05-13 that the prepare-commits drafts went too deep. Example feedback: "in 5 could just be 'Added the Collections cheat foldout'."

**How to apply (before-and-after examples for the same Collections-core commit):**
- ❌ Too verbose: *"Phase 1 business logic for the Collections live event: service, event instance, multi-instance configs, persisted data, item catalog SO, and service registration. UI (Phase 2) and in-level spawn (Phase 3) deferred."*
- ✅ Better: *"Phase 1 business logic for the Collections live event. UI (Phase 2) and in-level spawn (Phase 3) deferred."*
- ✅ Or even tighter when the scope already implies the content: *"Added the Collections cheat foldout."*

**[WIP] prefix:** Use when a commit intentionally leaves the project in a non-compiling state (e.g. mid-refactor on a feature branch). Acceptable on feature/debug branches, never on main/develop.

**Why:** Agreed convention to make intentional broken-state commits obvious in git history.

**How to apply:** Prepend `[WIP]` before the scope. Example: `[WIP] UITable: Refactor - Extracted helper classes (UITable.cs not yet updated).`
