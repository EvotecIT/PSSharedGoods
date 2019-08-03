function Get-ComputerMissingDrivers {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $Data = Get-WmiObject Win32_PNPEntity -ComputerName $ComputerName | Where-Object {$_.Configmanagererrorcode -ne 0} | Select-Object Caption, ConfigmanagererrorCode, Description, DeviceId, HardwareId, PNPDeviceID
    return $Data
}
