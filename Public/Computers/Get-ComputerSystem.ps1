function Get-ComputerSystem {
    <#
    .SYNOPSIS
    Retrieves computer system information from remote computers.

    .DESCRIPTION
    This function retrieves computer system information from remote computers using CIM/WMI queries.

    .PARAMETER ComputerName
    Specifies the names of the remote computers to retrieve system information from.

    .PARAMETER Protocol
    Specifies the protocol to use for the remote connection. Valid values are 'Default', 'Dcom', or 'Wsman'.

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER All
    Indicates whether to retrieve all available properties of the computer system.

    .EXAMPLE
    Get-ComputerSystem -ComputerName AD1, AD2, EVO1, ADFFS | ft -a *

    Retrieves computer system information for the specified computers and displays it in a table format.

    .NOTES
    This function uses CIM/WMI queries to gather system information from remote computers.
    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [switch] $All
    )
    [string] $Class = 'Win32_ComputerSystem'
    if ($All) {
        $Properties = '*'
    } else {
        $Properties = 'PSComputerName', 'Name', 'Manufacturer' , 'Domain', 'Model' , 'Systemtype', 'PrimaryOwnerName', 'PCSystemType', 'PartOfDomain', 'CurrentTimeZone', 'BootupState', 'Roles', 'SystemFamily'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName     = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Name             = $Data.Name
                    Manufacturer     = $Data.Manufacturer
                    Domain           = $Data.Domain
                    Model            = $Data.Model
                    Systemtype       = $Data.Systemtype
                    PrimaryOwnerName = $Data.PrimaryOwnerName
                    PCSystemType     = [Microsoft.PowerShell.Commands.PCSystemType] $Data.PCSystemType
                    PartOfDomain     = $Data.PartOfDomain
                    CurrentTimeZone  = $Data.CurrentTimeZone
                    BootupState      = $Data.BootupState
                    SystemFamily     = $Data.SystemFamily
                    Roles            = $Data.Roles -join ', '
                }
            }
        }
    }
}
