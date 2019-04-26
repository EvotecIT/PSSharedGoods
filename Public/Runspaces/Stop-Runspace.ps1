function Stop-Runspace {
    [cmdletbinding()]
    param(
        [Array] $Runspaces,
        [string] $FunctionName,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool,
        [switch] $ExtendedOutput
    )
    [Array] $List = while ($Runspaces.Status -ne $null) {
    #[Array] $List = While (@($Runspaces | Where-Object -FilterScript {$null -ne $_.Status}).count -gt 0) {
        foreach ($Runspace in $Runspaces | Where-Object { $_.Status.IsCompleted -eq $true }) {
            $Errors = foreach ($e in $($Runspace.Pipe.Streams.Error)) {
                Write-Error -ErrorRecord $e
                $e
            }
            foreach ($w in $($Runspace.Pipe.Streams.Warning)) {
                Write-Warning -Message $w
            }
            foreach ($v in $($Runspace.Pipe.Streams.Verbose)) {
                Write-Verbose -Message $v
            }
            if ($ExtendedOutput) {
                @{
                    Output = $Runspace.Pipe.EndInvoke($Runspace.Status)
                    Errors = $Errors
                }
            } else {
                $Runspace.Pipe.EndInvoke($Runspace.Status)
            }
            $Runspace.Status = $null
        }
    }
    $RunspacePool.Close()
    $RunspacePool.Dispose()
    if ($List.Count -eq 1) {
        return , $List
    } else {
        return $List
    }
}