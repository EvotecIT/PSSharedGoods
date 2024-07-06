function Get-ComputerMissingDrivers {
    <#
    .SYNOPSIS
    Retrieves information about missing drivers on a specified computer.

    .DESCRIPTION
    This function retrieves information about missing drivers on a specified computer by querying the Win32_PNPEntity WMI class.

    .PARAMETER ComputerName
    Specifies the name of the computer to query. Defaults to the local computer.

    .EXAMPLE
    Get-ComputerMissingDrivers -ComputerName "Computer01"
    Retrieves information about missing drivers on a computer named "Computer01".

    .EXAMPLE
    Get-ComputerMissingDrivers
    Retrieves information about missing drivers on the local computer.

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $Data = Get-WmiObject Win32_PNPEntity -ComputerName $ComputerName | Where-Object {$_.Configmanagererrorcode -ne 0} | Select-Object Caption, ConfigmanagererrorCode, Description, DeviceId, HardwareId, PNPDeviceID
    return $Data
}
