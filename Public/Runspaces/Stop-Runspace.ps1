function Stop-Runspace {
    [cmdletbinding()]
    param(
        [System.Object[]]$Runspaces,
        [string] $FunctionName,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    $List = @()
    while ($Runspaces.Status -ne $null) {
        #foreach ($v in $($runspaces.Pipe.Streams.Verbose)) {
        #    Write-Verbose "$FunctionName - 1Verbose from runspace: $v"
        #}
        $completed = $runspaces | Where-Object { $_.Status.IsCompleted -eq $true }

        foreach ($runspace in $completed) {
            #write-verbose 'Stop-runspace - Hello 2'
            foreach ($e in $($runspace.Pipe.Streams.Error)) {
                Write-Verbose "$FunctionName - Error from runspace: $e"
            }
            foreach ($v in $($runspace.Pipe.Streams.Verbose)) {
                Write-Verbose "$FunctionName - Verbose from runspace: $v"
            }
            #write-verbose 'Stop-runspace - Hello 3'
            $List += $runspace.Pipe.EndInvoke($runspace.Status)
            #write-verbose 'Stop-runspace - Hello 4'
            $runspace.Status = $null
            #write-verbose 'Stop-runspace - Hello 5'
        }
    }
    #write-verbose 'Stop-runspace - Hello 6'
    $RunspacePool.Close()
    #write-verbose 'Stop-runspace - Hello 7'
    $RunspacePool.Dispose()
    #write-verbose 'Stop-runspace - Hello 8'
    return $List
}