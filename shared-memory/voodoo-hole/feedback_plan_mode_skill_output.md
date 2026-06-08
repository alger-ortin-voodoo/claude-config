---
name: plan-mode-suppresses-skill-output
description: Interrupt marker + executing the next-steps skill suppresses visible output (any invocation route); fixed by removing the interrupt — auto-run /next-steps after plan approval per CLAUDE.md
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 22da2930-2344-4cfd-a41b-f9a2a20a468c
---

**Root cause (final, 7+ controlled data points, 2026-06-04):** when an `[Request interrupted by
user]` marker immediately precedes a turn that **executes the /next-steps skill**, the model goes
do-mode: composes everything in thinking, performs the skill's one tool action (`Set-Clipboard`),
emits only a 23-char confirmation. Discriminator matrix:
- Interrupt + skill executed → silent 6/6 (bare `/next-steps` ×5 AND `run /next-steps` via the
  Skill tool ×1 — invocation route irrelevant; approval vs rejection irrelevant; plan mode
  irrelevant; model irrelevant — Opus failed and succeeded in other regimes).
- Normal turn + skill executed → talks 2/2 (clipboard call included).
- Interrupt + freestyle answer (no skill) → talks. Post-silent "show me the output" → talks 5/5.

Mechanism: the post-interrupt framing ("What should Claude do instead?") demands an action; the
skill supplies exactly one executable action; the model does it and treats the procedure as
complete, displacing the prose into thinking.

**Failed countermeasures (lesson archive):** v1 in-skill HARD RULE; v2 `UserPromptExpansion`
`additionalContext` hook (still registered, harmless dead weight — removable cleanup) + first-line
anchor; v3 `PreToolUse` deny-gate on Set-Clipboard (REVERTED: per-call overhead + mid-turn
transcript flush race); v4 Stop-hook (rejected — hook fatigue); v5 natural-language invocation
("run /next-steps") — also silent; v6 print-only skill — rejected by user (degraded UX).

**v7 (final, active):** remove the interrupt from the workflow. CLAUDE.md *Post-Plan Next-Steps*
rule: after `ExitPlanMode` approval, do NOT implement — produce the full /next-steps
recommendation (clipboard included) as the approval turn's natural continuation, then stop and
wait. Runs in the proven-good normal-turn regime; zero extra user keystrokes; fires once per
approved plan only (skip when the approval says "go ahead" or the plan names plan-implementer).

**v7 outcome (2026-06-05, ACCEPTED):** with a plain "Yes" approval it works acceptably: intro
line + clipboard + a bottom-line one-liner carrying the actual verdict ("fresh Sonnet session").
The full 3-axis body is still swallowed — final pattern: skill content arriving as a Skill-tool
RESULT suppresses the body in all observed runs (3/3), while slash-expansion in clean context
gives full output (2/2). **v7.1 (2026-06-05, active):** the compact next-steps
spec is now inlined in the CLAUDE.md *Post-Plan Next-Steps* section — post-approval the
recommendation is composed with NO tool call before the text (never invoke the Skill or Read the
command file there; the skill stays for manual mid-session use). This targets the freestyle
regime, the only one that produced a full body after a plan.

**Gotcha (2026-06-05):** the plan dialog's "type something" option is recorded as a REJECTION of
`ExitPlanMode` ("The user doesn't want to proceed with this tool use") with the typed text as
feedback — even if the text says "plan approved". It poisons context exactly like Esc. v7 only
works via the plain "Yes" approval; the first supposed v7 failure was actually this, not v7.

**How to apply:** Honor the Post-Plan Next-Steps rule. Generally: when context conditioning beats
prompt rules, redesign the workflow so the poisoned context never occurs — don't fight it with
hooks/gates; and never build PreToolUse gates that parse the live transcript mid-turn. A feature
request for native "accept plan without implementing" was filed via /feedback (2026-06-04,
v2.1.162).
