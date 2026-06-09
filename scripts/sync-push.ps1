# sync-push.ps1 — SessionEnd hook: commit & push pending claude-config changes.
#
# The desktop app fires SessionEnd on tab-switch / resume cycles, NOT just at a real
# session end. To avoid a burst of "Auto-sync" commits while switching between parallel
# sessions, this DEBOUNCES: it skips when any commit landed within $debounceMinutes.
# It also logs each invocation's `reason` (from the hook's stdin JSON) to sync.log, so we
# can later see which reasons correspond to tab-switches vs. a genuine quit and refine to
# precise reason-filtering. Same-machine sessions share the files on disk and don't need
# git to see each other; the push only matters cross-machine, so a short delay is free.
#
# The repo's .gitignore re-includes only portable config, so `git add -A` can only ever
# stage CLAUDE.md / settings / rules / scripts / shared-memory — never runtime files,
# caches, credentials, or this sync.log.
$ErrorActionPreference = 'Continue'

$repo = Join-Path $env:USERPROFILE '.claude'
$log  = Join-Path $repo 'sync.log'          # top-level file -> gitignored by /*
$debounceMinutes = 15

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
    Add-Content $log "$stamp  end(reason=$reason)  clean -> skip"
    return
}

# Debounce: if any commit landed within the window, skip to avoid tab-switch spam.
$lastCommit = (git -C $repo log -1 --format=%ct 2>&1) -join ''
if ($lastCommit -match '^\d+$') {
    $ageMin = ([DateTimeOffset]::UtcNow.ToUnixTimeSeconds() - [int64]$lastCommit) / 60
    if ($ageMin -lt $debounceMinutes) {
        Add-Content $log ("$stamp  end(reason=$reason)  dirty, debounced ({0:N1}min < $debounceMinutes) -> skip" -f $ageMin)
        return
    }
}

# Commit + push the leftover changes as a catch-all (substantive changes get semantic
# commits during the session; this only sweeps up whatever is left).
$null = git -C $repo add -A 2>&1
$null = git -C $repo commit -m "Auto-sync: $stamp ($env:COMPUTERNAME) [reason=$reason]" 2>&1
$null = git -C $repo push origin main 2>&1
Add-Content $log "$stamp  end(reason=$reason)  committed + pushed"
