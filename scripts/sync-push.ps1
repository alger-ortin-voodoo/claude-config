# sync-push.ps1 — Commit & push pending claude-config changes at session end.
# Fail-safe: swallow errors so a sync hiccup never disrupts shutdown. The repo's
# .gitignore re-includes only portable config, so `git add -A` can only ever
# stage CLAUDE.md / settings / rules / scripts / shared-memory — never runtime
# files, caches, or credentials.
$ErrorActionPreference = 'Continue'

$repo = Join-Path $env:USERPROFILE '.claude'

if (-not (Test-Path (Join-Path $repo '.git'))) { return }

# Nothing to do when the working tree is clean.
$status = git -C $repo status --porcelain 2>&1
if (-not $status) { return }

# Catch-all auto-sync commit. Substantive changes are committed semantically
# during the session; this only sweeps up whatever is left over.
$null  = git -C $repo add -A 2>&1
$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
$null  = git -C $repo commit -m "Auto-sync: $stamp ($env:COMPUTERNAME)" 2>&1
$null  = git -C $repo push origin main 2>&1
