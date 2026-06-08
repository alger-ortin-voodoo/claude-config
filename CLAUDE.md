# Personal Overrides & Extensions

These rules apply to all my projects and override any conflicting rules in the project's `CLAUDE.md`.

## On-demand rule files (read before the matching work)

Detailed rules live in `~/.claude/rules/` and are loaded on demand to keep this file small. The
imperative one-liners below are always in effect; read the matching file for full detail + examples
**before** doing that kind of work:

| Before you… | Read |
|---|---|
| Write or edit any C# | `~/.claude/rules/code-style.md` |
| Draft a commit message or apply reviewer findings | `~/.claude/rules/commits.md` |
| Plan a new feature or sub-phase | `~/.claude/rules/feature-flow.md` |

---

## Code Style — essentials checklist

> Overrides the project's Section 4. These are the non-negotiables; full detail + examples in
> `~/.claude/rules/code-style.md` — read it before writing/editing C#.

* **Tabs** for indentation. Column 100 is a **soft** limit — never break a line that runs just a few chars over.
* **Braces (ZERO TOLERANCE):** any control-flow body on the **next line** MUST have braces. Brace-free only when condition + action fit on the **same line** (early-return style). In an `if/else if/else` chain, braces are **all-or-nothing**.
* **Multi-line signatures/calls:** one parameter per line, closing `)` on its own line. Never split params arbitrarily.
* **Naming:** descriptive names; no `Base` suffix on abstract classes (use `Perk`, not `PerkBase`); `Async` suffix on async methods (event handlers exempt); PascalCase for `const`/`static readonly`. Public fields are PascalCase (per `.editorconfig`).
* **`var`:** minimize — prefer explicit type, except when the type is very long or already shown on the line (e.g. `var x = ServiceLocator.Global.Get<T>()`).
* Explicit `private` keyword always. Braces in multi-line `case` blocks.
* **`=>`** is for properties and lambdas, **not methods** — methods use a block body with explicit `return`.
* **Comments:** verbose — a brief line before each logic block. Blank line **before** an inline comment (unless prev line is `{`). Category labels (`// Public Properties`, etc.) sit **flush** against the member below them.
* **XML headers** on all types and methods (summary only, multi-line form); single-line `<summary>` only for public properties. Use `cref`/`inheritdoc`.
* **Regions** in standard order: CONSTANTS, AUX TYPES, FIELDS AND PROPERTIES, INITIALIZATION/FINALIZATION, UNITY EVENTS, GETTERS/SETTERS, *custom*, INTERNAL METHODS, CALLBACKS, DEBUG. FULL CAPS, dashes to col 100, no blank line inside the region tags.
* **Editor scope pairs** (`BeginChangeCheck`/`EndChangeCheck`, `BeginHorizontal`/`EndHorizontal`, etc.) wrap their content in braces, treated as a block.
* **UGUI prefab SRP:** prefab root holds only the main script + `RectTransform`; visual components live on dedicated child GameObjects.
* `using` only for namespaces actually required; wrap code in the project's namespace.

---

## Agent Routing

Routing is evaluated **before** mode considerations. Even under `/implement` or `/plan`, if the task
matches a trigger, **propose the delegation first** (building/planning happens inside the agent).

| Trigger | Agent |
|---|---|
| New feature with a spec/ticket, or any task that warrants design before code | `feature-planner` |
| About to commit a non-trivial diff, or finished an edit and want a style audit | `unity-code-reviewer` |
| About to commit code touching `Update`, hot paths, instantiation, or rendering | `performance-guardian` |
| Bug repro / root-cause investigation / "why is X broken" | `debug-investigator` |
| Preparing/creating git commits **without session context** (fresh session, external changes) | `commit-preparer` |
| Executing a feature-planner plan end-to-end (autonomous, halts on issues) | `plan-implementer` |

* **Commit prep — context-first exception:** when you already understand the changes from this session, you need not delegate. Small change set → draft commits on the main thread. Larger set → delegate but pass a session-context summary (files, purpose, suggested grouping + messages). Delegate for full from-scratch analysis only when there's no context to reuse.
* **Skip delegation for:** one-line edits/typos/renames/comment tweaks; continuing a task this session already handed to you; pure exploration/questions; anything the user explicitly asked **you** to do; executing a clear pre-agreed plan with no design decisions left (main thread drives mechanical work).
* **Default:** propose delegation in one short line rather than auto-spawning. Auto-spawn only when the user approved delegation this session, or a `feature-planner` plan names the implementer.
* **Parallel reviews:** before any non-trivial commit, run `unity-code-reviewer` and (if hot paths/rendering changed) `performance-guardian` in parallel; report a punch list, then ask before applying fixes.

Implementation work (one-off edits, mid-session iterations) is driven by the main thread — rule
enforcement lives here and in memory. There are no implementation agents.

---

## Commit safety gate (HARD RULE)

* **NEVER run `git commit`, `git push`, `git tag`, or any history-mutating git command without the user's explicit go-ahead *in this turn*.** A prior session's (or prior turn's) approval does not roll over.
* Applies to the main thread AND every agent, **including** during `plan-implementer` runs.
* After applying review fixes: **stop and tell the user** — don't auto-commit. The user often wants to compile-check in the Editor first.
* **Message format:** `Scope: Change Type - Description` — Scope is 1-4 words (often the branch/feature); Change Type is one word (Development, Fix, Setup, Cleanup, Documentation, Polishing, Content, Refactor, Optimization…); Description states purpose/intent, never enumerates files. Ticketed bug fixes get a `[HOL-XXXX]` prefix; intentionally non-compiling WIP gets `[WIP]`.
* Change-Type vocabulary nuances, examples + full fix-application discipline → `~/.claude/rules/commits.md`.

---

## Plan Doc Maintenance (ZERO TOLERANCE)

Whenever `Edit`/`Write` touches a project file — in the **same response**, before the next step:

1. **Feature plan doc** — find the relevant `.md` in `Docs/` (infer from feature/branch/context; else `Glob` `Docs/**/*plan*.md`). Mark completed steps `[DONE]`. For any on-the-fly decision that diverges from / simplifies / extends the plan, add a `> **Note:**` callout inline at that step.
2. **Notion spec / GDD** — can't be updated mid-implementation; append a `⚠️ Notion sync needed: [what & why]` line to the plan doc and tell the user.
3. **Inline comments / XML docs** — update in the same `Edit` pass. Never defer.

Discussion-only turns (no project-file `Edit`/`Write`) are exempt.

---

## Model Switching Reminders

* **Entering plan mode** (or asked to plan/design/architect): if not on Opus, halt and prompt `/model opus`.
* **Exiting plan mode** (or asked to implement/build/code): if not on Sonnet, halt and prompt `/model sonnet`.
* **Skip the switch for trivial changes** (a one-liner / few-line edit) where the cache-miss cost outweighs the benefit — stay on the current model and proceed.
* **When recommending next steps:** ALWAYS weigh the model-switch cache-miss cost *explicitly* before suggesting a switch. Switching mid-context discards the warm cache and re-reads everything uncached; only worth it for substantial upcoming work. For a small step, recommend staying. (`/next-steps` bakes this in.)
* Keep the reminder short — one strong, clear line at the top of the response; especially if planning/implementation was halted for the wrong active model.

---

## Post-Plan Next-Steps (automatic)

* When `ExitPlanMode` is **approved**, do NOT start implementing. First print the next-steps
  recommendation composed **directly from the inline spec below**, then **stop and wait** for the
  user's explicit go-ahead — e.g. "go" / "implement" here, or they take the continuation prompt
  to another session.
* **Never invoke the `next-steps` Skill (or Read its command file) in this flow.** Skill content
  arriving as a tool result reliably suppresses the message body (verified 2026-06-04/05); the
  inline spec exists precisely so NO tool runs before the text. The skill remains for manual
  mid-session `/next-steps` use only.

**Inline spec — print, in this order:**

1. `## ➡️ Next steps` heading, then one short justified line per axis:
   * **Model** — Opus for planning/design, Sonnet for mechanical implementation; ALWAYS weigh the
     cache-miss cost of switching mid-context and recommend staying for small steps. Sonnet runs
     at 200K (never suggest the 1M beta), so factor context headroom.
   * **Session** — continue vs `/clear` vs fresh, judged by how much loaded context the next step
     needs. Opus→Sonnet switches usually favor `/clear` + self-contained prompt (the switch
     discards the warm cache anyway; fresh 200K headroom beats inherited bloat).
   * **Agents** — delegate per the *Agent Routing* table only when handoff overhead pays off.
2. A one-line bottom line (e.g. "`/clear` → Sonnet, main thread").
3. **Step mode** — only when the next work executes a plan doc with ≥3 commits remaining: print a
   compact remaining-steps roadmap once (one line per step, model/session, next step marked) and
   scope the prompt below to the next ≈1-commit chunk, ending with "run `/next-steps` again after
   this step is committed".
4. The continuation prompt in a fenced code block — self-contained (feature, plan doc path, step,
   key constraints, never-auto-commit reminder) whenever the recommendation is a fresh or cleared
   session.
5. ONLY after the prompt is printed: copy it to the clipboard via PowerShell
   `Set-Clipboard -Value @'…'@` (single-quoted here-string), then end with `📋 Copied to clipboard.`

* **Scope guard:** fires once per **approved** plan only. Never produce recommendations before or
  during plan refinement iterations, and keep pre-approval `ExitPlanMode` messages free of them.
* **Skip it** when the user's approval already says to start immediately (e.g. "approve, go
  ahead"), or when the approved plan explicitly names its executor (e.g. a `plan-implementer`
  run) — then proceed as instructed.
