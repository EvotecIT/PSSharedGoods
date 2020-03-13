function Get-ComputerServices {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $Services = Get-PSService -ComputerName $ComputerName | Select-Object Name, Displayname, Status
    return $Services
}