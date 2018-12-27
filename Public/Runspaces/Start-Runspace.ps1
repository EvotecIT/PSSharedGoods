function Start-Runspace {
    [cmdletbinding()]
    param (
        [string] $ScriptBlock,
        [hashtable] $Parameters,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    #Write-Verbose "Start-Runspace - Starting"
    $runspace = [PowerShell]::Create()
    $null = $runspace.AddScript($ScriptBlock)
    $null = $runspace.AddParameters($Parameters)
    $runspace.RunspacePool = $RunspacePool
    #Write-Verbose "Start-Runspace - Ending soon"
    $Data = [PSCustomObject]@{
        Pipe   = $runspace;
        Status = $runspace.BeginInvoke()
    }
    #Write-Verbose "Start-Runspace - Ending done"
    return $Data
}