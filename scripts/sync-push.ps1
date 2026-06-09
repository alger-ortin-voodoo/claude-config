# sync-push.ps1 — SessionEnd hook: commit & push pending claude-config changes.
#
# The desktop app fires SessionEnd on tab-switch / resume cycles, NOT just at a real
# session end (both report reason=other — indistinguishable). To avoid a burst of
# "Auto-sync" commits while switching between parallel sessions, this DEBOUNCES: it skips
# when any commit landed within $debounceMinutes. It logs each invocation to sync.log.
# Same-machine sessions share the files on disk and don't need git to see each other; the
# push only matters for cross-machine sync, so a short delay is free.
#
# The repo's .gitignore re-includes only portable config, so `git add -A` can only ever
# stage CLAUDE.md / settings / rules / scripts / shared-memory — never runtime files,
# caches, credentials, or this sync.log.
$ErrorActionPreference = 'Continue'

$repo = Join-Path $env:USERPROFILE '.claude'
$log  = Join-Path $repo 'sync.log'          # top-level file -> gitignored by /*
$debounceMinutes = 15

# Append a line to sync.log, keeping the file bounded so it can't grow without limit.
# (Duplicated in sync-pull.ps1 on purpose — each hook script stays self-contained.)
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

# Capture the SessionEnd reason from stdin (best-effort). Guard with IsInputRedirected so
# we ONLY read when stdin is actually piped (as in a real hook) — otherwise ReadToEnd()
# would block forever waiting on console input and pile up a zombie process per tab switch.
$reason = 'unknown'
if ([Console]::IsInputRedirected) {
    try {
        $raw = [Console]::In.ReadToEnd()
        if ($raw) {
            $j = $raw | ConvertFrom-Json
            if ($j.reason) { $reason = [string]$j.reason }
        }
    } catch { }
}

$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# Nothing to sync if the working tree is clean.
$status = git -C $repo status --porcelain 2>&1
if (-not $status) {
    Write-SyncLog "$stamp  end(reason=$reason)  clean -> skip"
    return
}

# Debounce: if any commit landed within the window, skip to avoid tab-switch spam.
$lastCommit = (git -C $repo log -1 --format=%ct 2>&1) -join ''
if ($lastCommit -match '^\d+$') {
    $ageMin = ([DateTimeOffset]::UtcNow.ToUnixTimeSeconds() - [int64]$lastCommit) / 60
    if ($ageMin -lt $debounceMinutes) {
        Write-SyncLog ("$stamp  end(reason=$reason)  dirty, debounced ({0:N1}min < $debounceMinutes) -> skip" -f $ageMin)
        return
    }
}

# Commit + push the leftover changes as a catch-all (substantive changes get semantic
# commits during the session; this only sweeps up whatever is left).
$null = git -C $repo add -A 2>&1
$null = git -C $repo commit -m "Auto-sync: $stamp ($env:COMPUTERNAME) [reason=$reason]" 2>&1
$null = git -C $repo push origin main 2>&1
Write-SyncLog "$stamp  end(reason=$reason)  committed + pushed"
