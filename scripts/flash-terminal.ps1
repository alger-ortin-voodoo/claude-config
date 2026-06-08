# Signals Claude Code activity to the user by:
#   1. Playing a Windows system sound.
#   2. Showing a Windows toast notification (popup + persists in Action Center).
#   3. Emitting an OSC 9;4 sequence to color the Windows Terminal taskbar button
#      (when supported; harmless no-op otherwise).
#   4. Flashing the terminal's taskbar button (FlashWindowEx).
#
# Intended usage from settings.json hooks:
#   Stop              -> -Sound Asterisk    -ToastIcon Info    -ProgressState Warning -Title 'Claude Code' -Message 'Task completed'
#   Notification      -> -Sound Exclamation -ToastIcon Warning -ProgressState Error   -Title 'Claude Code' -Message 'Needs your attention'
#   UserPromptSubmit  -> -Sound None        -ToastIcon None    -ProgressState Clear

param(
    [ValidateSet('None','Asterisk','Beep','Exclamation','Hand','Question')]
    [string]$Sound = 'Asterisk',

    [ValidateSet('None','Info','Warning','Error')]
    [string]$ToastIcon = 'Info',

    [ValidateSet('Clear','Default','Error','Indeterminate','Warning')]
    [string]$ProgressState = 'Warning',

    [string]$Title = 'Claude Code',
    [string]$Message = 'Task completed'
)

# ------------------------------------------------------------------------------
# 1) Play system sound (non-blocking).
# ------------------------------------------------------------------------------
if ($Sound -and $Sound -ne 'None') {
    try { [System.Media.SystemSounds]::$Sound.Play() } catch { }
}

# ------------------------------------------------------------------------------
# 2) Show Windows toast notification. On Windows 10/11 balloon tips are
#    redirected to modern toasts (popup + Action Center entry).
# ------------------------------------------------------------------------------
if ($ToastIcon -ne 'None') {
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        Add-Type -AssemblyName System.Drawing       -ErrorAction Stop

        $notify = New-Object System.Windows.Forms.NotifyIcon
        switch ($ToastIcon) {
            'Info'    { $notify.Icon = [System.Drawing.SystemIcons]::Information }
            'Warning' { $notify.Icon = [System.Drawing.SystemIcons]::Warning     }
            'Error'   { $notify.Icon = [System.Drawing.SystemIcons]::Error       }
        }
        $notify.BalloonTipTitle = $Title
        $notify.BalloonTipText  = $Message
        $notify.Visible         = $true
        $notify.ShowBalloonTip(5000)
        # Keep the NotifyIcon alive long enough for the toast to register.
        Start-Sleep -Milliseconds 400
        $notify.Dispose()
    } catch { }
}

# ------------------------------------------------------------------------------
# 3) Emit OSC 9;4 progress sequence to the parent console (Windows Terminal
#    interprets this to color the window's taskbar button). Hook stdout is
#    captured by Claude Code, so write straight to the parent's console.
# ------------------------------------------------------------------------------
$stateMap = @{
    'Clear'         = 0
    'Default'       = 1
    'Error'         = 2
    'Indeterminate' = 3
    'Warning'       = 4
}
$state = $stateMap[$ProgressState]

if (-not ('TermSig.Native' -as [type])) {
    Add-Type -Namespace TermSig -Name Native -MemberDefinition @'
[DllImport("kernel32.dll")] public static extern bool AttachConsole(uint dwProcessId);
[DllImport("kernel32.dll")] public static extern bool FreeConsole();
[DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int nStdHandle);
[DllImport("kernel32.dll")] public static extern bool WriteConsoleW(
    IntPtr hConsoleOutput,
    string lpBuffer,
    uint nNumberOfCharsToWrite,
    out uint lpNumberOfCharsWritten,
    IntPtr lpReserved);
'@
}

[TermSig.Native]::FreeConsole() | Out-Null
$attached = [TermSig.Native]::AttachConsole([uint32]::MaxValue)
if ($attached) {
    $hOut = [TermSig.Native]::GetStdHandle(-11)
    $isInvalid = ($hOut -eq [IntPtr]::Zero) -or ($hOut.ToInt64() -eq -1)
    if (-not $isInvalid) {
        $esc = [char]27
        $bel = [char]7
        # Use BEL as ST terminator — more widely accepted than ESC \.
        $seq = "$esc]9;4;$state;0$bel"
        $written = 0
        [TermSig.Native]::WriteConsoleW(
            $hOut,
            $seq,
            [uint32]$seq.Length,
            [ref]$written,
            [IntPtr]::Zero
        ) | Out-Null
    }
    [TermSig.Native]::FreeConsole() | Out-Null
}

# ------------------------------------------------------------------------------
# 4) Flash the terminal's taskbar button (extra cue). Skipped when clearing.
# ------------------------------------------------------------------------------
if ($ProgressState -ne 'Clear') {
    if (-not ('FlashWin.Api' -as [type])) {
        Add-Type -Namespace FlashWin -Name Api -MemberDefinition @'
[StructLayout(LayoutKind.Sequential)]
public struct FLASHWINFO {
    public uint cbSize;
    public IntPtr hwnd;
    public uint dwFlags;
    public uint uCount;
    public uint dwTimeout;
}
[DllImport("user32.dll")]
public static extern bool FlashWindowEx(ref FLASHWINFO pwfi);
[DllImport("user32.dll")]
public static extern bool IsWindowVisible(IntPtr hWnd);
[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
'@
    }

    # Resolve the real terminal window to flash.
    #   1) Try GetConsoleWindow() — reliable for conhost (cmd.exe reports
    #      MainWindowHandle = 0 to PowerShell, so the process walk alone falls
    #      through to explorer.exe).
    #   2) Otherwise walk the process tree, but only accept handles belonging
    #      to a known terminal host — never shells or explorer.
    function Find-TerminalHandle {
        $consoleHwnd = [FlashWin.Api]::GetConsoleWindow()
        if ($consoleHwnd -ne [IntPtr]::Zero -and [FlashWin.Api]::IsWindowVisible($consoleHwnd)) {
            return $consoleHwnd
        }

        $terminalHosts = @(
            'WindowsTerminal', 'Terminal', 'wt',
            'conhost', 'cmd', 'pwsh', 'powershell',
            'mintty', 'alacritty', 'wezterm', 'wezterm-gui'
        )
        $currentId = $PID
        for ($i = 0; $i -lt 15; $i++) {
            try {
                $proc = Get-Process -Id $currentId -ErrorAction Stop
                if ($proc.MainWindowHandle -ne [IntPtr]::Zero -and $terminalHosts -contains $proc.ProcessName) {
                    return $proc.MainWindowHandle
                }
                $parentId = (Get-CimInstance Win32_Process -Filter "ProcessId=$currentId" -ErrorAction Stop).ParentProcessId
                if (-not $parentId -or $parentId -eq 0) { return [IntPtr]::Zero }
                $currentId = $parentId
            } catch {
                return [IntPtr]::Zero
            }
        }
        return [IntPtr]::Zero
    }

    $hwnd = Find-TerminalHandle
    if ($hwnd -ne [IntPtr]::Zero) {
        $fw = New-Object FlashWin.Api+FLASHWINFO
        $fw.cbSize   = [System.Runtime.InteropServices.Marshal]::SizeOf($fw)
        $fw.hwnd     = $hwnd
        # FLASHW_ALL (3) = caption + taskbar ; FLASHW_TIMERNOFG (12) = until focus.
        $fw.dwFlags  = 3 -bor 12
        $fw.uCount   = [uint32]::MaxValue
        $fw.dwTimeout = 0
        [FlashWin.Api]::FlashWindowEx([ref]$fw) | Out-Null
    }
}

# Keep the PS process alive briefly so the sound thread can start playback.
Start-Sleep -Milliseconds 500
