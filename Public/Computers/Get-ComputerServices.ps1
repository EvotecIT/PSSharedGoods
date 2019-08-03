function Get-ComputerServices {
    [CmdletBinding()]
    param(
        [stirng] $ComputerName = $Env:COMPUTERNAME
    )
    $Services = Get-PSService -ComputerName $ComputerName | Select-Object Name, Displayname, Status
    return $Services
}