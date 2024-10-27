function Get-ComputerPorts {
    <#
    .SYNOPSIS
    Retrieves TCP connection information from a specified computer.

    .DESCRIPTION
    The Get-ComputerPorts function retrieves information about TCP connections on a specified computer.
    It can filter connections based on state, local address, remote address, applied setting, local port, and remote port.

    .PARAMETER ComputerName
    The name of the computer from which to retrieve TCP connection information. If not specified, the local computer is used.

    .PARAMETER State
    The state of the TCP connections to retrieve. Valid states include Bound, Closed, CloseWait, Closing, DeleteTCB, Established, FinWait1, FinWait2, LastAck, Listen, SynReceived, SynSent, and TimeWait.

    .PARAMETER LocalAddress
    The local addresses of the TCP connections to retrieve.

    .PARAMETER RemoteAddress
    The remote addresses of the TCP connections to retrieve.

    .PARAMETER AppliedSetting
    The applied settings of the TCP connections to retrieve. Valid settings include Compat, Datacenter, DatacenterCustom, Internet, and InternetCustom.

    .PARAMETER LocalPort
    The local ports of the TCP connections to retrieve.

    .PARAMETER RemotePort
    The remote ports of the TCP connections to retrieve.

    .EXAMPLE
    Get-ComputerPorts -ComputerName 'AD1' -LocalPort 389, 636, 88, 53, 3268, 3269, 445, 135 | Sort-Object RemotePort | Format-Table -AutoSize *

    Retrieves and displays TCP connection information from the computer 'AD1' for the specified local ports.

    .EXAMPLE
    Get-ComputerPorts -ComputerName 'AD1' -State 'Established' | Sort-Object RemotePort | Format-Table -AutoSize *

    Retrieves and displays TCP connection information from the computer 'AD1' for connections in the 'Established' state.

    .EXAMPLE
    Get-ComputerPorts -ComputerName 'AD1' | ft -AutoSize

    Retrieves and displays all TCP connection information from the computer 'AD1'.

    .NOTES
    This function requires administrative privileges to retrieve process information.
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