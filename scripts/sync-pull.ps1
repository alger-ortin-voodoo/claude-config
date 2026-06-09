# sync-pull.ps1 — SessionStart hook: pull latest claude-config.
# Fully SILENT: logs to sync.log and writes nothing to stdout, so it can never pollute
# the session context (an earlier version dumped an "offline" line into the chat).
# The desktop app fires SessionStart on every tab focus/resume; a pull is a cheap no-op
# when already up to date, and benefits cross-machine freshness when it isn't.
$ErrorActionPreference = 'Continue'

$repo = Join-Path $env:USERPROFILE '.claude'
$log  = Join-Path $repo 'sync.log'          # top-level file -> gitignored by /*

# Append a line to sync.log, keeping the file bounded so it can't grow without limit.
# (Duplicated in sync-push.ps1 on purpose — each hook script stays self-contained.)
$logMaxLines  = 1000   # once the log passes this many lines...
$logKeepLines = 500    # ...trim it back to this many most-recent lines.
function Write-SyncLog([string]$message) {
    Add-Content -Path $log -Value $message
    try {
        $lines = @(Get-Content $log -ErrorAction SilentlyContinue)
        if ($lines.Count -gt $logMaxLines) {
            $lines | Select-Object -Last $logKeepLines | Set-Content $log
        }
    } catch { }
}

if (-not (Test-Path (Join-Path $repo '.git'))) { return }

$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# Rebase local commits onto the remote, autostashing any uncommitted edits.
$null = git -C $repo pull --rebase --autostash origin main 2>&1

if ($LASTEXITCODE -ne 0) {
    # Conflict or offline: undo the half-applied rebase so the repo stays clean.
    $null = git -C $repo rebase --abort 2>&1
    Write-SyncLog "$stamp  start  pull FAILED (conflict/offline) -> aborted, local preserved"
} else {
    Write-SyncLog "$stamp  start  pull ok"
}
