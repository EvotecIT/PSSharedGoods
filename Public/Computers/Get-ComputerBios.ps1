function Get-ComputerBios {
    <#
    .SYNOPSIS
    Retrieves BIOS information from a remote or local computer.

    .DESCRIPTION
    This function retrieves BIOS information from a specified computer using CIM/WMI.

    .PARAMETER ComputerName
    Specifies the name of the computer to retrieve BIOS information from. Defaults to the local computer.

    .PARAMETER Protocol
    Specifies the protocol to use for communication. Valid values are 'Default', 'Dcom', or 'Wsman'. Default is 'Default'.

    .PARAMETER All
    Switch parameter to retrieve all available BIOS properties.

    .EXAMPLE
    Get-ComputerBios -ComputerName "RemoteComputer" -Protocol Wsman
    Retrieves BIOS information from a remote computer using the Wsman protocol.

    .EXAMPLE
    Get-ComputerBios -All
    Retrieves all available BIOS information from the local computer.

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_bios'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'PSComputerName', 'Status', 'Version', 'PrimaryBIOS', 'Manufacturer', 'ReleaseDate', 'SerialNumber', 'SMBIOSBIOSVersion', 'SMBIOSMajorVersion', 'SMBIOSMinorVersion', 'SystemBiosMajorVersion', 'SystemBiosMinorVersion'

    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Status       = $Data.Status
                    Version      = $Data.Version
                    VersionBIOS  = -join ($Data.SMBIOSMajorVersion, ".", $Data.SMBIOSMinorVersion, ".", $Data.SystemBiosMajorVersion, ".", $Data.SystemBiosMinorVersion)
                    PrimaryBIOS  = $Data.PrimaryBIOS
                    Manufacturer = $Data.Manufacturer
                    ReleaseDate  = $Data.ReleaseDate
                }
            }
        }
    }
}