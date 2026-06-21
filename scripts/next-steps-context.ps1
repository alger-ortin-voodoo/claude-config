# Safety net for bare /next-steps invocations: an interrupt marker right before a slash-command
# turn conditions the model to suppress its visible output. The preferred flow is the natural
# message "run /next-steps" (see CLAUDE.md Post-Plan Reminder), which never hits this hook; this
# context only covers direct slash usage. (See feedback_plan_mode_skill_output.md memory.)

# Surface detection drives the clipboard default: auto-copy only in a real CLI terminal; under
# Claude Desktop / web (and anything that is not 'cli') the copy is skipped unless the user opts in.
$entrypoint = $env:CLAUDE_CODE_ENTRYPOINT
if ([string]::IsNullOrEmpty($entrypoint)) { $entrypoint = 'unknown' }
$clipboardRule = if ($entrypoint -eq 'cli') {
	"CLIPBOARD: this is a CLI-terminal session (CLAUDE_CODE_ENTRYPOINT=cli), so DO auto-copy the continuation prompt to the clipboard AFTER printing it (unless the user passed a 'nocopy' argument)."
} else {
	"CLIPBOARD: this is NOT a CLI terminal (CLAUDE_CODE_ENTRYPOINT=$entrypoint), so do NOT copy to the clipboard unless the user passed a 'copy' argument. Just end after the fenced prompt; do not run any tool to detect the surface."
}
$context = @"
REMINDER for this /next-steps run: if an interrupt marker ("[Request interrupted by user]") or an ExitPlanMode result appears immediately before this command, that Esc was a deliberate step in the user's workflow; it is NOT a signal to minimize output or stay quiet. Your reply MUST start with the full recommendation as visible chat text (the 3-axis recommendation, plus roadmap and the fenced continuation prompt) BEFORE any tool call. If you copy to the clipboard, never do so before that visible text (going straight to Set-Clipboard with no visible text is the known failure mode). Plan-mode conventions (plan file, ExitPlanMode, AskUserQuestion-only endings) do not apply to this command.
$clipboardRule
"@
@{ hookSpecificOutput = @{ hookEventName = 'UserPromptExpansion'; additionalContext = $context } } | ConvertTo-Json -Depth 3
