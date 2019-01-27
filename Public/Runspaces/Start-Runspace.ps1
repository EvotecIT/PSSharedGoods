function Start-Runspace {
    [cmdletbinding()]
    param (
        [string] $ScriptBlock,
        [System.Collections.IDictionary] $Parameters,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    if ($null -ne $Parameters -and $ScriptBlock -ne '
    ') {
        $runspace = [PowerShell]::Create()
        $null = $runspace.AddScript($ScriptBlock)
        $null = $runspace.AddParameters($Parameters)
        $runspace.RunspacePool = $RunspacePool
        # return data
        [PSCustomObject]@{
            Pipe   = $runspace
            Status = $runspace.BeginInvoke()
        }
    }
}