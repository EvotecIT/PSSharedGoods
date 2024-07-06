function Measure-Collection {
    <#
    .SYNOPSIS
    Measures the execution time of a script block and outputs the duration.

    .DESCRIPTION
    This function measures the time taken to execute a given script block and outputs the duration in days, hours, minutes, seconds, milliseconds, and ticks.

    .PARAMETER Name
    Specifies the name of the measurement.

    .PARAMETER ScriptBlock
    Specifies the script block to be executed and measured.

    .EXAMPLE
    Measure-Collection -Name "Example" -ScriptBlock { Start-Sleep -Seconds 5 }
    # Outputs: Name: Example, 0 days, 0 hours, 0 minutes, 5 seconds, 0 milliseconds, ticks 5000000

    .EXAMPLE
    Measure-Collection -Name "Another Example" -ScriptBlock { Get-Process }
    # Outputs: Name: Another Example, 0 days, 0 hours, 0 minutes, X seconds, Y milliseconds, ticks Z

    #>
    param(
        [string] $Name,
        [ScriptBlock] $ScriptBlock
    )
    $Time = [System.Diagnostics.Stopwatch]::StartNew()
    Invoke-Command -ScriptBlock $ScriptBlock
    $Time.Stop()
    "Name: $Name, $($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds, ticks $($Time.Elapsed.Ticks)"
}