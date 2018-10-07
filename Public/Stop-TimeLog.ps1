function Stop-TimeLog {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)][System.Diagnostics.Stopwatch] $Time
    )
    Begin {}
    Process {
        $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
    }
    End {
        $Time.Stop()
        return $TimeToExecute
    }
}