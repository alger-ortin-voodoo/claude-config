# Safety net for bare /next-steps invocations: an interrupt marker right before a slash-command
# turn conditions the model to suppress its visible output. The preferred flow is the natural
# message "run /next-steps" (see CLAUDE.md Post-Plan Reminder), which never hits this hook; this
# context only covers direct slash usage. (See feedback_plan_mode_skill_output.md memory.)
$context = @'
REMINDER for this /next-steps run: if an interrupt marker ("[Request interrupted by user]") or an ExitPlanMode result appears immediately before this command, that Esc was a deliberate step in the user's workflow — it is NOT a signal to minimize output or stay quiet. Your reply MUST start with the full recommendation as visible chat text — the 3-axis recommendation, plus roadmap and the fenced continuation prompt — BEFORE any tool call. Going straight to Set-Clipboard with no visible text is the known failure mode; do not repeat it. Plan-mode conventions (plan file, ExitPlanMode, AskUserQuestion-only endings) do not apply to this command.
'@
@{ hookSpecificOutput = @{ hookEventName = 'UserPromptExpansion'; additionalContext = $context } } | ConvertTo-Json -Depth 3
