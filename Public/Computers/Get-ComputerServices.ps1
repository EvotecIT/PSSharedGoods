function Get-ComputerServices {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $Services = Get-Service -ComputerName $ComputerName | Select-Object Name, Displayname, Status
    return $Services
}