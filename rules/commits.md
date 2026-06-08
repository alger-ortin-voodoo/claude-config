# Commit & Fix-Application Rules (detail)

> Read this before drafting commit messages or applying reviewer findings.
> The slim core in `CLAUDE.md` keeps only the safety gate; this file carries the full discipline + format.

## Commit & Fix-Application Discipline (HARD RULES)

These apply to the main thread AND every agent. No exceptions.

### Never commit without explicit user approval

- **NEVER run `git commit`, `git push`, `git tag`, or any history-mutating git command without the user's explicit go-ahead in this turn.** A prior session's approval does not roll over.
- Commits are routed through `commit-preparer` which previews and waits for "yes" — use it. Direct `git commit` from the main thread is forbidden.
- "I just applied review fixes, let me commit" → NO. Pause, summarize what changed, hand off to `commit-preparer`. The user often wants to compile-check in the Editor before approving.
- This applies *during* `plan-implementer` runs too (it doesn't commit; you don't either).

### Fixes are scoped to the finding — nothing else

When applying findings from `unity-code-reviewer`, `performance-guardian`, or any other reviewer:
- **Fix ONLY what the finding called out.** Same file, same lines, same concern.
- **Do NOT bundle unrelated cleanups.** No removing logs, no tweaking comments, no renaming variables, no "while I'm here" refactors. Even if it looks like trivial improvement.
- **Existing functionality stays.** Logs, comments, defensive checks, fallbacks — these were put there for a reason. The reviewer did NOT flag them; leave them alone.
- If you spot something else worth fixing, **mention it to the user separately** — don't include it in the fix pass.
- If a fix requires touching code outside the flagged area, **pause and explain** before doing it.

### Review fixes don't auto-skip the commit gate

Sequence is: implement → review → fix findings → **stop and tell the user** → user verifies (e.g. compiles in Editor) → user approves → `commit-preparer` runs. The step that's most often skipped is "stop and tell the user". Do not skip it.

---

## Commit Messages

> Overrides the project's Section 5.

* **Default format:** _`Scope: Change Type - Description`_
  * Prompt to the user if any of the parts is not obvious.
  * Scope: _What has been changed?_
    * Feature name, target file or script if it's just one, etc.
    * You may be able to extract it from the branch name.
    * Keep it short (1-4 words).
    * Usually it will be the same throughougt the same chat session.
  * Change Type: _What type of change has been done? (1 word)_
    * Examples: Development, Fix, Setup, Refactor, Assets, Content, Documentation, Polishing, Optimization, Cleanup, Debug, etc.
    * Use **Debug** for changes related to cheats, debug panels, or debug-only functionality.
    * Use **Documentation** for changes to comments, XML docs, region structure, spec/plan/design markdown files.
    * Use **Polishing** for visual/UX tweaks (spacing, colors, animations, feel).
    * Use **Content** for game content and data (remote config values, localization strings, asset references).
    * Use **Setup** for environment/tooling configuration (`.gitignore`, project settings, CI, package manifests) — not Cleanup.
    * Use **Cleanup** for removing dead code, unused files, or stale `.meta` files — not Setup.
    * Quick guide: "configuring the project?" → Setup. "removing something that shouldn't be there?" → Cleanup. "improving docs or code comments?" → Documentation. "tweaking visuals?" → Polishing.
  * Description: _What has been done? (1 sentence preferred; 2 only if the **why** genuinely needs it)_
    * Focus on the **purpose and intention** of the change — what it achieves and why — not the technical implementation details, which are already visible in the diff.
    * **Never enumerate components, files, or sub-changes** ("service, event instance, configs, persisted data, ..."). If you're listing pieces, you're describing the diff. Cut the list.
  * Examples:
    * *Continue Offer: Development - Created screen logic and connected to the service.*
    * *Magnet Booster: Fix - Movable objects were not being attracted.*
    * *Missions Screen: Polishing - Adjusted spacing and colors.*
    * *Mars Map: Optimization - Adjusted physics parameters.*
* **Ticket Reference (Only for fixes):** Prefix commit messages with the ClickUp ticket ID in the format `[HOL-XXXX]`. If no ticket has been provided, ask the user for the ticket link before committing. This only applies to commits that are fix targeting a reported bug with its own ticket.
  * Example: `[HOL-7096] Ad or Pay Screen: Fix - Null reference exception fired by the glow UI Particle effect.`
* **WIP commits:** If a commit intentionally leaves the project in a non-compiling state (e.g. mid-refactor on a feature branch), prefix the message with `[WIP]`. This is acceptable on feature/debug branches but never on main/develop.
  * WIP example: `[WIP] UITable: Refactor - Extracted helper classes (UITable.cs not yet updated).`

---

## Commit Rules
* Try to group changes into small, atomic commits when possible.
