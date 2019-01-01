function Start-Runspace {
    [cmdletbinding()]
    param (
        [string] $ScriptBlock,
        [hashtable] $Parameters,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    $runspace = [PowerShell]::Create()
    $null = $runspace.AddScript($ScriptBlock)
    $null = $runspace.AddParameters($Parameters)
    $runspace.RunspacePool = $RunspacePool
    $Data = [PSCustomObject]@{
        Pipe   = $runspace
        Status = $runspace.BeginInvoke()
    }
    return $Data
}