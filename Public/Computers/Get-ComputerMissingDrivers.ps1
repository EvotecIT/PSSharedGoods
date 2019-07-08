function Get-ComputerMissingDrivers {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $Data = Get-WmiObject Win32_PNPEntity -ComputerName $ComputerName | Where-Object {$_.Configmanagererrorcode -ne 0} | Select-Object Caption, ConfigmanagererrorCode, Description, DeviceId, HardwareId, PNPDeviceID
    return $Data
}
