function Get-ComputerNetwork {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data3 = get-WmiObject win32_networkadapter -ComputerName $ComputerName | Select-Object Name, Manufacturer, Description , AdapterType, Speed, MACAddress, NetConnectionID, PNPDeviceID
    $Data3 = $Data3 | Select-Object Name, Manufacturer, Speed, AdapterType, MACAddress
    return $Data3
}