function Start-TimeLog {
    <#
    .SYNOPSIS
    Starts a new stopwatch for logging time.

    .DESCRIPTION
    This function starts a new stopwatch that can be used for logging time durations.

    .EXAMPLE
    Start-TimeLog
    Starts a new stopwatch for logging time.

    #>
    [CmdletBinding()]
    param()
    [System.Diagnostics.Stopwatch]::StartNew()
}