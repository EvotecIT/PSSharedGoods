function Stop-TimeLog {
    <#
    .SYNOPSIS
    Stops the stopwatch and returns the elapsed time in a specified format.

    .DESCRIPTION
    The Stop-TimeLog function stops the provided stopwatch and returns the elapsed time in a specified format. The function can output the elapsed time as a single string or an array of days, hours, minutes, seconds, and milliseconds.

    .PARAMETER Time
    Specifies the stopwatch object to stop and retrieve the elapsed time from.

    .PARAMETER Option
    Specifies the format in which the elapsed time should be returned. Valid values are 'OneLiner' (default) or 'Array'.

    .PARAMETER Continue
    Indicates whether the stopwatch should continue running after retrieving the elapsed time.

    .EXAMPLE
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    # Perform some operations
    Stop-TimeLog -Time $stopwatch
    # Output: "0 days, 0 hours, 0 minutes, 5 seconds, 123 milliseconds"

    .EXAMPLE
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    # Perform some operations
    Stop-TimeLog -Time $stopwatch -Option Array
    # Output: ["0 days", "0 hours", "0 minutes", "5 seconds", "123 milliseconds"]
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)][System.Diagnostics.Stopwatch] $Time,
        [ValidateSet('OneLiner', 'Array')][string] $Option = 'OneLiner',
        [switch] $Continue
    )
    Begin {}
    Process {
        if ($Option -eq 'Array') {
            $TimeToExecute = "$($Time.Elapsed.Days) days", "$($Time.Elapsed.Hours) hours", "$($Time.Elapsed.Minutes) minutes", "$($Time.Elapsed.Seconds) seconds", "$($Time.Elapsed.Milliseconds) milliseconds"
        } else {
            $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        }
    }
    End {
        if (-not $Continue) {
            $Time.Stop()
        }
        return $TimeToExecute
    }
}