function Get-ComputerWindowsFeatures {
    <#
    .SYNOPSIS
    Get Windows Features status on one or more computers/servers

    .DESCRIPTION
    Get Windows Features status on one or more computers/servers

    .PARAMETER ComputerName
    ComputerName to provide when executing query remotly. By default current computer name is used.

    .PARAMETER Protocol
    Protocol to use when gathering data. Choices are Default, Dcom, WSMan

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER EnabledOnly
    Returns only data if Windows Feature is enabled

    .PARAMETER All
    Gets all properties without any preprocessing

    .EXAMPLE
    Get-ComputerWindowsFeatures -EnabledOnly | Format-Table

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [switch] $EnabledOnly,
        [switch] $All
    )
    [string] $Class = 'Win32_OptionalFeature'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Name', 'Caption' , 'Status', 'InstallState', 'InstallDate', 'PSComputerName'
    }

    $State = @{
        '1' = 'Enabled'
        '2' = 'Disabled'
        '3' = 'Absent'
        '4' = 'Unknown'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                $InstallState = $State["$($Data.InstallState)"]
                if ($EnabledOnly -and $InstallState -ne 'Enabled') {
                    continue
                }
                [PSCustomObject] @{
                    ComputerName = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Name         = $Data.Name
                    Caption      = $Data.Caption
                    InstallState = $InstallState
                    #InstallDate  = $Data.InstallDate
                    #Status       = $Data.Status
                }
            }
        }
    }
}
