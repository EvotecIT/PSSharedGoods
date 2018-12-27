function Stop-Runspace {
    [cmdletbinding()]
    param(
        [System.Object[]]$Runspaces,
        [string] $FunctionName,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    $List = @()
    while ($Runspaces.Status -ne $null) {
        $Completed = $Runspaces | Where-Object { $_.Status.IsCompleted -eq $true }
        foreach ($Runspace in $Completed) {
            foreach ($e in $($Runspace.Pipe.Streams.Error)) {
                Write-Error "$FunctionName - Error from Runspace: $e"
            }
            foreach ($w in $($Runspace.Pipe.Streams.Warning)) {
                Write-Warning "$FunctionName - Warning from Runspace: $w"
            }
            foreach ($v in $($Runspace.Pipe.Streams.Verbose)) {
                Write-Verbose "$FunctionName - Verbose from Runspace: $v"
            }
            $List += $Runspace.Pipe.EndInvoke($Runspace.Status)
            $Runspace.Status = $null
        }
    }
    $RunspacePool.Close()
    $RunspacePool.Dispose()
    return $List
}