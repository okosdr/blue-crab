# Clawd music watcher: writes the current Windows media session to
# ~/.dsh-tui/clawd-music.json so the crab can dance while music plays.
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
})[0]

function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}

[Windows.Media.Control.GlobalSystemMediaTransportControlsSessionManager, Windows.Media.Control, ContentType = WindowsRuntime] | Out-Null
$out = Join-Path $env:USERPROFILE '.dsh-tui\clawd-music.json'
$manager = $null

while ($true) {
    try {
        if ($null -eq $manager) {
            $manager = Await ([Windows.Media.Control.GlobalSystemMediaTransportControlsSessionManager]::RequestAsync()) ([Windows.Media.Control.GlobalSystemMediaTransportControlsSessionManager])
        }
        $session = $manager.GetCurrentSession()
        $state = [ordered]@{
            playing = $false
            app     = ''
            title   = ''
            ts      = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
        }
        if ($null -ne $session) {
            $info = $session.GetPlaybackInfo()
            $state.playing = ($info.PlaybackStatus -eq 'Playing')
            $state.app = [string]$session.SourceAppUserModelId
            if ($state.playing) {
                try {
                    $props = Await ($session.TryGetMediaPropertiesAsync()) ([Windows.Media.Control.GlobalSystemMediaTransportControlsSessionMediaProperties])
                    $state.title = [string]$props.Title
                } catch { }
            }
        }
        $json = $state | ConvertTo-Json -Compress; [System.IO.File]::WriteAllText($out, $json, (New-Object System.Text.UTF8Encoding($false)))
    } catch {
        try {
            $manager = $null
            $failJson = [ordered]@{ playing = $false; app = ''; title = ''; ts = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() } | ConvertTo-Json -Compress
            [System.IO.File]::WriteAllText($out, $failJson, (New-Object System.Text.UTF8Encoding($false)))
        } catch { }
    }
    Start-Sleep -Seconds 3
}