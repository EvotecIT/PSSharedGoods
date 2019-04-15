function Measure-Collection {
    param(
        [string] $Name,
        [ScriptBlock] $ScriptBlock
    )
    $Time = [System.Diagnostics.Stopwatch]::StartNew()
    Invoke-Command -ScriptBlock $ScriptBlock
    $Time.Stop()
    "Name: $Name, $($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds, ticks $($Time.Elapsed.Ticks)"
}