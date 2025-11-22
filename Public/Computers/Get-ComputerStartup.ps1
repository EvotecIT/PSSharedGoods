function Get-ComputerStartup {
    <#
    .SYNOPSIS
    Retrieves information about startup programs on a remote computer.

    .DESCRIPTION
    The Get-ComputerStartup function retrieves information about startup programs on a specified computer using CIM/WMI.

    .PARAMETER ComputerName
    Specifies the name of the computer to retrieve startup information from. Defaults to the local computer.

    .PARAMETER Protocol
    Specifies the protocol to use for the connection. Valid values are 'Default', 'Dcom', or 'Wsman'. Default is 'Default'.

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER All
    Indicates whether to retrieve all properties of the startup programs.

    .EXAMPLE
    Get-ComputerStartup -ComputerName "RemoteComputer" -Protocol Wsman
    Retrieves startup program information from a remote computer using the Wsman protocol.

    .EXAMPLE
    Get-ComputerStartup -All
    Retrieves all startup program information from the local computer.

    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [switch] $All
    )
    [string] $Class = 'win32_startupCommand'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Caption', 'Description', 'Command', 'Location', 'Name', 'User', 'UserSID', 'PSComputerName' #, 'SettingID'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Caption      = $Data.Caption
                    Description  = $Data.Description
                    #SettingID    = $Data.SettingID
                    Command      = $Data.Command
                    Location     = $Data.Location
                    Name         = $Data.Name
                    User         = $Data.User
                    UserSID      = $Data.UserSID
                }
            }
        }
    }
}
