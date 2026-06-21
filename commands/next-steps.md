---
description: Recommend how to proceed - model (weighing cache-miss cost), session, and agent delegation.
---

The user wants a recommendation on how to proceed from here. Produce a **concise** recommendation across the three axes below — one short line of justification each, and default to the **cheapest path that gets the job done**. Do not over-explain.

**Output discipline (HARD RULE).** The visible chat message IS this command's deliverable.
- Your reply MUST begin with the literal heading `## ➡️ Next steps` followed by the three axes —
  emitted as visible chat text, not thinking.
- Print the full recommendation (and roadmap + fenced continuation prompt) as normal chat text
  BEFORE running any tool. Never run `Set-Clipboard` first; never leave the content only in your
  thinking.
- This skill is for direct mid-session use (the post-plan-approval flow uses the inline spec in
  CLAUDE.md instead — never invoke this skill from there). Even if an interrupt or plan rejection
  precedes this command, that is never a signal to minimize output, and plan-mode conventions do
  NOT change this command's output: do not write the recommendation into the plan file, do not
  call ExitPlanMode or AskUserQuestion, do not suppress the chat text. Respond with the normal
  visible message, then copy to clipboard **only if copying is enabled** (see the clipboard rule
  below — off by default), then end the turn WITHOUT starting implementation.

**1. Model**
- Opus for planning / design / decisions; Sonnet for mechanical implementation.
- **Mandatory before recommending any switch:** explicitly weigh the cache-miss cost. Switching models mid-context discards the warm prompt cache and forces re-reading the entire context uncached (slower + more expensive). Only recommend a switch when the upcoming work is substantial enough that the quality/speed gain clearly outweighs that cost. For a small or quick next step, recommend **staying on the current model** even if it's not the "ideal" one for the task type.
- State the cache-miss comparison in the rationale — never just say "switch to X".
- **Sonnet runs at the default 200K context window, not 1M.** The 1M long-context beta meters at API usage rates (~$3/$15 per Mtok, with a premium step-up above 200K) that fall *outside* the flat Max plan, so it is deliberately avoided — **never recommend enabling the 1M window.** The practical consequence: a switch to Sonnet brings a real 200K ceiling, so factor **context headroom** into the recommendation, not just the cache-miss. This couples directly to the Session axis below.

**2. Session**
- Continue the current session vs `/clear` vs a fresh session.
- Judge by context size and how much of the current context is still relevant to the next step. If the next task is unrelated to what's loaded, prefer a clean slate; if it builds directly on this work, continue.
- **Coupling with a Sonnet switch (important):** when the recommendation is to switch from Opus to Sonnet, remember Sonnet's window is 200K — often smaller than what a long Opus planning/design session has accumulated (large transcript, many file reads, the global `CLAUDE.md` + deferred-tools dumps). If the current context is heavy, prefer **`/clear` → switch to Sonnet → paste a self-contained continuation prompt** over continuing in place: the model switch discards the warm cache *regardless*, so continuing buys only the already-read files, which is rarely worth surrendering 200K of headroom and risking early compaction mid-build. Lean toward `/clear` whenever a self-contained prompt can fully capture the next step.

**3. Agents**
- Whether to delegate to a specialist per the *Agent Routing* table in `CLAUDE.md` (e.g. `feature-planner`, `unity-code-reviewer`, `performance-guardian`, `commit-preparer`, `debug-investigator`) or drive on the main thread.
- Factor in handoff overhead: agents re-read context and routed docs, so skip delegation for trivial/mechanical work or when this session already holds the needed context.

End with a one-line bottom-line recommendation (e.g. "Stay on Opus, continue this session, drive on the main thread").

**Multi-step plan execution (step mode).** Before writing the continuation prompt, decide whether the next work is *executing a multi-step plan that is big enough to split*. This avoids the failure mode where one prompt enumerates an entire plan and the implementer burns a whole session (and most of its context) on it, leaving a diff too large to review.

- **When to engage (BOTH must hold):**
  1. The recommended next work is **executing a plan doc** — a `Docs/**/*plan*.md` with discrete steps — not a one-off edit, a question, or a pure review/commit pass.
  2. The **remaining** work is big. Engage if *any* of: ≥3 session-sized chunks of work remain, multiple new files/scripts to author, or any single chunk large enough to strain a fresh Sonnet 200K session (risking mid-build compaction). If none hold (small plan, one quick chunk), **skip step mode** and use the normal continuation prompt below unchanged.

- **Find the next step.** Read the plan doc. Steps are marked `[DONE]` (finished), `[IMPL]`/unmarked (pending). Sub-phases (e.g. `2F.2`) contain Parts (`A`/`B`/`C`/`D`) that map to atomic commits. The next step is the first pending unit at the granularity below.

- **Granularity — judge the chunk size yourself.** Group remaining work so **each chunk fits one fresh Sonnet session (~150K usable) without compacting** — estimate its context load (reference files + edits + tool output). How many commits a chunk needs is the **implementer's** call; do not slice by commit count. **Split a large sub-phase into session-sized chunks** — never emit a chunk that would force mid-build compaction.

- **Print the remaining-steps roadmap once.** A compact list (bullets or a small table) of every remaining step in order, each with a short scope label and the recommended model/session for that step. Mark which one is **next**. This is the only verbose part — keep it scannable, don't re-explain per step.

- **Then emit the single-step continuation prompt** (the block below), scoped to the **next step only**. In step mode it MUST additionally:
  - Name the plan doc path, the feature, and the specific step (e.g. "Part B — migrate `ContinueOfferScreen` onto the paginated base").
  - Be self-contained for a cold, freshly `/clear`'d Sonnet context (each step gets its own session — see Session axis): carry only the decisions/constraints/files *that step* needs.
  - **Bound the scope explicitly:** implement *only this step*, do **not** proceed to later steps, and stop after the step is implemented + reviewed for the user's commit approval (the commit safety gate still applies — never auto-commit).
  - End with the loop instruction: *after this chunk is committed (however many commits it took), run `/next-steps` again to get the next chunk's prompt.*
  - In step mode, default the Session axis to **`/clear` → its own Sonnet session per step** (the model switch discards the warm cache regardless, and a fresh window preserves 200K headroom + keeps each diff small enough to review).

**Deeper-planning gate (multiphase features).** Before writing any *implementation* continuation prompt, check whether the next step is a phase that the plan flags as **needing a deeper planning pass before implementation** (master plans are expected to outline phases and mark which need this — see `rules/feature-flow.md`). If it is flagged and that pass hasn't been done yet:
- Recommend **Opus** (this is planning, not mechanical build) and that the deeper plan happen **before** any implementation — state it plainly in the bottom line.
- Make the continuation prompt a **planning prompt**: instruct a `feature-planner` pass that **expands that phase's own doc in place**, naming the phase, its phase-doc path, and the master plan. Do NOT emit an implementation prompt for a flagged phase.
- Note that after that phase plan is approved, the *next* `/next-steps` run yields the implementation prompt.
Phases marked ready-as-is (or already deepened) skip this gate and use the normal implementation prompt below.

**Then add a "Continuation prompt" line.** Provide a ready-to-paste prompt the user can use to kick off the next step. Tailor it to the recommendation:
- If continuing this session: a short prompt that names the next step (e.g. "Implement step 3 of the plan — the reward-claim flow").
- If starting fresh / `/clear` / a new session, or delegating to an agent: make it **self-contained** — name the feature, the plan doc path, the current step, and any decisions/constraints the new context won't have. The user should be able to paste it cold and have the work resume correctly.
- **Session name line (phased-plan work).** When the next step is a phased-plan substep, make the **first line** of the continuation prompt `Session name: {feature} | {phase}.{substep} {substep-name}` (append ` | Plan` for a planning/refinement session), per the *Session Naming Convention* in `~/.claude/rules/feature-flow.md`. The new session surfaces this so it can be renamed in one paste.
- Format it as a single fenced code block so it's easy to copy.

**Clipboard copy (off by default — CLI-auto or opt-in).** The continuation prompt is already shown in the fenced block above; copying it to the clipboard is now conditional, so most runs end right after the prompt with no extra tool call:

- **Copy** when EITHER the user passed a `copy` (or `--copy`) argument, OR the injected hook context reports a CLI-terminal session (`CLAUDE_CODE_ENTRYPOINT=cli`) and the user did **not** pass `nocopy`.
- **Otherwise skip it** — the default under Claude Desktop / web. Do not run any tool; just end after the fenced prompt. A single short line is fine for discoverability: *prompt is above; run `/next-steps copy` to also copy it.*
- **Never run a `Set-Clipboard` or surface-detection command just to discover the entrypoint** — rely on the hook-injected value. A wasted tool call defeats the whole point of this change.

When you do copy, do it **only after the prompt is already printed above**, via the PowerShell tool with a single-quoted here-string to avoid escaping issues:

```powershell
Set-Clipboard -Value @'
<the continuation prompt text, verbatim>
'@
```

Then add a short confirmation line below the block — `📋 Copied to clipboard.` Keep the clipboard text identical to what's shown in the fenced block. In step mode, copy **only the single-step continuation prompt** — never the roadmap. (If the prompt itself contains a line that is exactly `'@`, fall back to writing it to the clipboard via a temp variable instead.)

$ARGUMENTS
