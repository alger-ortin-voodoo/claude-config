# sync-pull.ps1 — Pull latest claude-config at session start.
# Fail-safe: must never block or error the session. Stays silent on success;
# only emits a line when something needs the user's attention.
$ErrorActionPreference = 'Continue'

$repo = Join-Path $env:USERPROFILE '.claude'

# Only act when this really is the synced config repo.
if (-not (Test-Path (Join-Path $repo '.git'))) { return }

# Rebase local commits onto the remote, autostashing any uncommitted edits so
# the pull can never be blocked by a dirty working tree.
$null = git -C $repo pull --rebase --autostash origin main 2>&1

# A non-zero exit means a conflict (or we're offline). Abort the half-applied
# rebase so the repo is left clean and usable, and surface it once.
if ($LASTEXITCODE -ne 0) {
    $null = git -C $repo rebase --abort 2>&1
    Write-Output "claude-config: auto-pull skipped (conflict or offline). Local state preserved; sync manually when convenient."
}
