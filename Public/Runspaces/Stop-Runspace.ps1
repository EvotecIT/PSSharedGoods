function Stop-Runspace {
    <#
    .SYNOPSIS
    Stops and cleans up the specified runspaces.

    .DESCRIPTION
    This function stops and cleans up the specified runspaces by checking their status and handling any errors, warnings, and verbose messages. It also provides an option for extended output.

    .PARAMETER Runspaces
    Specifies the array of runspaces to stop.

    .PARAMETER FunctionName
    Specifies the name of the function associated with the runspaces.

    .PARAMETER RunspacePool
    Specifies the runspace pool to close and dispose of.

    .PARAMETER ExtendedOutput
    Indicates whether to include extended output in the result.

    .EXAMPLE
    Stop-Runspace -Runspaces $runspaceArray -FunctionName "MyFunction" -RunspacePool $pool -ExtendedOutput
    Stops the specified runspaces in the $runspaceArray associated with the function "MyFunction" using the runspace pool $pool and includes extended output.

    #>
    [cmdletbinding()]
    param(
        [Array] $Runspaces,
        [string] $FunctionName,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool,
        [switch] $ExtendedOutput
    )
    #[Array] $List = while ($Runspaces.Status -ne $null) {
    [Array] $List = While (@($Runspaces | Where-Object -FilterScript { $null -ne $_.Status }).count -gt 0) {
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