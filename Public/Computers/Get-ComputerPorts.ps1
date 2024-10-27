function Get-ComputerPorts {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER State
    Parameter description

    .PARAMETER LocalAddress
    Parameter description

    .PARAMETER RemoteAddress
    Parameter description

    .PARAMETER AppliedSetting
    Parameter description

    .PARAMETER LocalPort
    Parameter description

    .PARAMETER RemotePort
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName,
        [ValidateSet(
            'Bound', 'Closed', 'CloseWait', 'Closing', 'DeleteTCB', 'Established', 'FinWait1', 'FinWait2', 'LastAck', 'Listen', 'SynReceived', 'SynSent', 'TimeWait'
        )][string[]] $State,
        [string[]] $LocalAddress,
        [string[]] $RemoteAddress,
        [ValidateSet(
            'Compat', 'Datacenter', 'DatacenterCustom', 'Internet', 'InternetCustom'
        )][string[]] $AppliedSetting,
        [int[]] $LocalPort,
        [int[]] $RemotePort
    )
    $CachedProcesses = [ordered] @{}

    $getNetTCPConnectionSplat = @{
        State          = $State
        LocalAddress   = $LocalAddress
        RemoteAddress  = $RemoteAddress
        AppliedSetting = $AppliedSetting
        LocalPort      = $LocalPort
        RemotePort     = $RemotePort
        CimSession     = $ComputerName
        ErrorAction    = 'Stop'
    }
    Remove-EmptyValue -Hashtable $getNetTCPConnectionSplat

    try {
        $Connections = Get-NetTCPConnection @getNetTCPConnectionSplat
    } catch {
        Write-Warning -Message "Get-ComputerPorts - Error getting connections. Try running as admin? $($_.Exception.Message)"
        return
    }
    try {
        if ($ComputerName) {
            # https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.getprocesses?view=net-8.0#system-diagnostics-process-getprocesses(system-string)
            # $Processes = Invoke-Command -ComputerName $ComputerName {
            #    Get-Process
            #}
            $Processes = [System.Diagnostics.Process]::GetProcesses($ComputerName)
        } else {
            #Get-Process
            $Processes = [System.Diagnostics.Process]::GetProcesses()
        }
    } catch {
        Write-Warning -Message "Get-ComputerPorts - Error getting processes. Try running as admin? $($_.Exception.Message)"
        return
    }
    foreach ($Process in $Processes) {
        $CachedProcesses["$($Process.Id)"] = $Process
    }
    foreach ($Connection in $Connections) {
        $Process = $CachedProcesses["$($Connection.OwningProcess)"]
        [PSCustomObject] @{
            LocalAddress   = $Connection.LocalAddress
            LocalPort      = $Connection.LocalPort
            RemoteAddress  = $Connection.RemoteAddress
            RemotePort     = $Connection.RemotePort
            State          = $Connection.State
            AppliedSetting = $Connection.AppliedSetting   #: Datacenter
            #OwningProcess  = $Connection.OwningProcess    #: 712
            CreationTime   = $Connection.CreationTime     #: 2024 - 10 - 17 08:10:02
            #OffloadState   = $Connection.OffloadState     #: InHost
            ProcessName    = $Process.Name
            ProcessId      = $Process.Id
            StartTime      = $Process.StartTime
        }
    }
}

#Get-ComputerPorts -ComputerName 'AD1' | Sort-Object RemotePort | Format-Table -AutoSize *
Get-ComputerPorts -ComputerName 'AD1' -LocalPort 389, 636, 88, 53, 3268, 3269, 445, 135 | Sort-Object RemotePort | Format-Table -AutoSize *