function Get-ComputerStartup {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $Data4 = Get-WmiObject win32_startupCommand -ComputerName $ComputerName | Select-Object Name, Location, Command, User, caption
    $Data4 = $Data4 | Select-Object Name, Command, User, Caption
    return $Data4
}