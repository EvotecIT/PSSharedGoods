<#
function Get-ComputerStartup {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $Data4 = Get-WmiObject win32_startupCommand -ComputerName $ComputerName | Select-Object Name, Location, Command, User, caption
    $Data4 = $Data4 | Select-Object Name, Command, User, Caption
    return $Data4
}
#>

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

#Get-ComputerStartup -ComputerName PL05LAP00531.area1.eurofins.local