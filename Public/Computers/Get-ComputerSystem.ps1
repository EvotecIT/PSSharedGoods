function Get-ComputerSystem {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER Protocol
    Parameter description

    .PARAMETER All
    Parameter description

    .EXAMPLE
    Get-ComputerSystem -ComputerName AD1, AD2, EVO1, ADFFS | ft -a *

    Output:
    WARNING: Get-ComputerSystem - No data for computer ADFFS. Most likely an error on receiving side.
    ComputerName Name Manufacturer          Domain        Model           Systemtype   PrimaryOwnerName PCSystemType PartOfDomain CurrentTimeZone BootupState SystemFamily    Roles
    ------------ ---- ------------          ------        -----           ----------   ---------------- ------------ ------------ --------------- ----------- ------------    -----
    AD1          AD1  Microsoft Corporation ad.evotec.xyz Virtual Machine x64-based PC Windows User                1         True              60 Normal boot Virtual Machine LM_Workstation, LM_Server, Primary_Domain_Controller, Timesource, NT, DFS
    AD2          AD2  Microsoft Corporation ad.evotec.xyz Virtual Machine x64-based PC Windows User                1         True              60 Normal boot Virtual Machine LM_Workstation, LM_Server, Backup_Domain_Controller, Timesource, NT, DFS
    EVO1         EVO1 MSI                   ad.evotec.xyz MS-7980         x64-based PC                             1         True              60 Normal boot Default string  LM_Workstation, LM_Server, SQLServer, NT, Potential_Browser, Master_Browser


    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'Win32_ComputerSystem'
    if ($All) {
        $Properties = '*'
    } else {
        $Properties = 'PSComputerName', 'Name', 'Manufacturer' , 'Domain', 'Model' , 'Systemtype', 'PrimaryOwnerName', 'PCSystemType', 'PartOfDomain', 'CurrentTimeZone', 'BootupState', 'Roles', 'SystemFamily'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
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