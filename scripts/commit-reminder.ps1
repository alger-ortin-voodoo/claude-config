# commit-reminder.ps1
# Stop hook: when Claude tries to end its turn with a dirty working tree, block once and
# remind it to PROPOSE commits (approval is still required separately). The goal is to stop
# sessions from ending — or jumping to /next-steps — with committable work left uncommitted.
#
# Safety: this hook must NEVER break the Stop event. Any error path falls through to `exit 0`
# (allow the stop).
#
# Loop prevention: debounced by a signature of (HEAD + porcelain status) per session, so Claude
# is reminded at most once per distinct dirty state. If the user declines to commit (tree
# unchanged), the next stop is allowed silently. `stop_hook_active` is also honoured defensively
# if the harness provides it.

try {
	# Read the hook payload (JSON) from stdin. Guard against a non-redirected console so the
	# script can never hang waiting for interactive input.
	$raw = ''
	if ([Console]::IsInputRedirected) {
		$raw = [Console]::In.ReadToEnd()
	}

	# Parse the payload; tolerate an empty or malformed body.
	$data = $null
	if ($raw -and $raw.Trim()) {
		try {
			$data = $raw | ConvertFrom-Json
		} catch {
			$data = $null
		}
	}

	# If we are already continuing because of a previous stop-hook block, allow the stop.
	if ($data -and $data.stop_hook_active) {
		exit 0
	}

	# Resolve the repository directory: prefer the payload cwd, else the current location.
	$repoDir = $null
	if ($data -and $data.cwd) {
		$repoDir = $data.cwd
	}
	if (-not $repoDir) {
		$repoDir = (Get-Location).Path
	}

	# Bail out quietly if git is unavailable or this is not a work tree.
	$null = git -C $repoDir rev-parse --is-inside-work-tree 2>$null
	if ($LASTEXITCODE -ne 0) {
		exit 0
	}

	# Collect the porcelain status. An empty result means a clean tree -> allow the stop.
	$statusLines = git -C $repoDir status --porcelain 2>$null
	$statusText = ($statusLines | Out-String).Trim()
	if (-not $statusText) {
		exit 0
	}

	# Count the changed paths for the reminder message.
	$count = @($statusLines | Where-Object { $_ -and $_.Trim() }).Count

	# Build a signature of the current dirty state so we remind only once per state.
	$head = (git -C $repoDir rev-parse HEAD 2>$null | Out-String).Trim()
	$sigInput = "$head`n$statusText"
	$sha1 = [System.Security.Cryptography.SHA1]::Create()
	$sig = [BitConverter]::ToString($sha1.ComputeHash([Text.Encoding]::UTF8.GetBytes($sigInput))) -replace '-', ''

	# Per-session marker used for debouncing.
	$sessionKey = if ($data -and $data.session_id) { $data.session_id } else { 'default' }
	$gateDir = Join-Path $env:TEMP 'claude-commit-gate'
	if (-not (Test-Path $gateDir)) {
		New-Item -ItemType Directory -Path $gateDir -Force | Out-Null
	}
	$marker = Join-Path $gateDir ("$sessionKey.sig")

	# If we already reminded for this exact dirty state, allow the stop.
	if (Test-Path $marker) {
		$prev = Get-Content $marker -Raw -ErrorAction SilentlyContinue
		if ($prev -and $prev.Trim() -eq $sig) {
			exit 0
		}
	}

	# Record this state, then block once with the reminder.
	Set-Content -Path $marker -Value $sig -Encoding ASCII

	$reason = @"
Uncommitted changes detected in $repoDir ($count path(s)) as you end this turn.

Before stopping, follow the commit workflow:
- Review the diff and PROPOSE grouped, atomic commit(s) using the ``Scope: Change Type - Description`` format.
- Draft them directly if you already have this session's context; otherwise hand off to the commit-preparer agent.
- Do NOT run ``git commit`` without the user's explicit approval in this turn.

If the user already declined to commit, or these changes are intentionally WIP / unrelated to what you were asked to do, say so in one line and then stop — you will not be reminded again for this same set of changes.
"@

	# Emit the blocking decision as JSON on stdout.
	$out = @{ decision = 'block'; reason = $reason } | ConvertTo-Json -Compress
	[Console]::Out.Write($out)
	exit 0
}
catch {
	# Never let this hook break the Stop event.
	exit 0
}
