function Start-Runspace {
    <#
    .SYNOPSIS
    Starts a new runspace with the provided script block, parameters, and runspace pool.

    .DESCRIPTION
    This function creates a new runspace using the specified script block, parameters, and runspace pool. It then starts the runspace and returns an object containing the runspace and its status.

    .PARAMETER ScriptBlock
    The script block to be executed in the new runspace.

    .PARAMETER Parameters
    The parameters to be passed to the script block.

    .PARAMETER RunspacePool
    The runspace pool in which the new runspace will be created.

    .EXAMPLE
    $scriptBlock = {
        Get-Process
    }
    $parameters = @{
        Name = 'explorer.exe'
    }
    $runspacePool = [RunspaceFactory]::CreateRunspacePool(1, 5)
    $runspacePool.Open()
    $result = Start-Runspace -ScriptBlock $scriptBlock -Parameters $parameters -RunspacePool $runspacePool
    $result.Pipe | Receive-Job -Wait

    This example starts a new runspace that retrieves information about the 'explorer.exe' process.

    #>
    [cmdletbinding()]
    param (
        [ScriptBlock] $ScriptBlock,
        [System.Collections.IDictionary] $Parameters,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    if ($ScriptBlock -ne '') {
        $runspace = [PowerShell]::Create()
        $null = $runspace.AddScript($ScriptBlock)
        if ($null -ne $Parameters) {
            $null = $runspace.AddParameters($Parameters)
        }
        $runspace.RunspacePool = $RunspacePool
        # return data
        [PSCustomObject]@{
            Pipe   = $runspace
            Status = $runspace.BeginInvoke()
        }
    }
}