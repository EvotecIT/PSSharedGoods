function Start-TimeLog() {
    $ExecutionTime = [System.Diagnostics.Stopwatch]::StartNew()
    return $ExecutionTime
}