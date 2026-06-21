# post-plan-next-steps.ps1 — PostToolUse hook scoped to ExitPlanMode.
#
# Purpose: the "Post-Plan Next-Steps" rule in the global CLAUDE.md is instruction-only
# (v7.1). On the CLI the model reliably honored it; the desktop app's plan-approval
# framing (a built-in "you can start coding" result) overrides that soft instruction,
# so the model jumps straight to implementing. This hook reasserts the rule at the exact
# moment of approval, in the same turn, so it competes directly with the built-in nudge.
#
# Fires ONLY when a plan is APPROVED: PostToolUse runs after a successful tool use, and a
# rejected/typed-over plan denies ExitPlanMode, so this never triggers on rejection.
#
# Design notes — deliberately avoids the documented v3/v4 failure modes:
#   - Matched to ExitPlanMode alone  -> no per-call overhead (v3), no Stop-hook fatigue (v4).
#   - Stateless: emits a fixed reminder, never parses the live transcript -> no flush race (v3).
#   - Does NOT invoke the next-steps Skill and creates NO interrupt marker, so it stays in the
#     proven full-output regime and cannot regress the v1-v7 silent-output bug.
#
# Mechanism: emits PostToolUse `additionalContext` (clean — leaves the tool's success intact,
# so the plan still counts as approved; it only ADDS the reminder). If a future desktop build
# is found to ignore additionalContext, the stable fallback is: write the reminder to stderr
# and `exit 2` instead (PostToolUse exit-2 feeds stderr to the model).
$ErrorActionPreference = 'Continue'

$reminder = @'
[Post-Plan Next-Steps — automatic; fires once per approved plan]
The user just APPROVED a plan via ExitPlanMode. Claude Code's built-in result may invite you to start coding — do NOT. Honor the "Post-Plan Next-Steps (automatic)" rule in your global CLAUDE.md:
1. Do NOT begin implementing.
2. Compose the next-steps recommendation directly from the inline spec in that CLAUDE.md section (the Model / Session / Agents axes, a one-line bottom line, then the self-contained continuation prompt in a fenced code block) with NO tool call before the text. Do NOT invoke the next-steps Skill and do NOT Read its command file — skill output arriving as a tool result suppresses the message body.
3. Copy the continuation prompt to the clipboard LAST, then STOP and wait for the user's explicit go-ahead.
EXCEPTION — skip all of the above and proceed normally only if the approval itself said to start immediately (e.g. "approve, go ahead") or the approved plan named its executor (e.g. a plan-implementer run).
'@

# Emit as additionalContext so it lands in the model's context for the continuation turn.
$payload = @{
    hookSpecificOutput = @{
        hookEventName     = 'PostToolUse'
        additionalContext = $reminder
    }
}

$payload | ConvertTo-Json -Depth 5 -Compress
