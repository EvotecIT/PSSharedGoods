function Stop-TimeLog {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)][System.Diagnostics.Stopwatch] $Time,
        [ValidateSet('OneLiner', 'Array')][string] $Option = 'OneLiner'
    )
    Begin {}
    Process {
        if ($AsArray) {
            $TimeToExecute = "$($Time.Elapsed.Days) days", "$($Time.Elapsed.Hours) hours", "$($Time.Elapsed.Minutes) minutes", "$($Time.Elapsed.Seconds) seconds", "$($Time.Elapsed.Milliseconds) milliseconds"
        } else {
            $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        }
    }
    End {
        $Time.Stop()
        return $TimeToExecute
    }
}