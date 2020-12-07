function Get-ComputerStartup {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_startupCommand'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Caption', 'Description', 'Command', 'Location', 'Name', 'User', 'UserSID', 'PSComputerName' #, 'SettingID'
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