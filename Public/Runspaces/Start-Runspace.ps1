function Start-Runspace {
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