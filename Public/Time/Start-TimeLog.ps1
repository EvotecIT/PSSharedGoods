function Start-TimeLog {
    [CmdletBinding()]
    param()
    $ExecutionTime = [System.Diagnostics.Stopwatch]::StartNew()
    return $ExecutionTime
}