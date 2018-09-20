function Stop-TimeLog([System.Diagnostics.Stopwatch] $Time) {
    $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
    $Time.Stop()
    return $TimeToExecute
}