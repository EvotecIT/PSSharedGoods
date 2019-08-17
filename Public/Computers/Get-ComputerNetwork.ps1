function Get-ComputerNetwork {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $Data3 = Get-CimData -Class win32_networkadapter -ComputerName $ComputerName -Properties 'DeviceID','Name', 'PNPDeviceID','Speed','NetworkAddresses','PermanentAddress','AdapterType','MACAddress','Manufacturer','NetConnectionID','ProductName','TimeOfLastReset'
    return $Data3 #| Select-Object 'DeviceID','Name', 'PNPDeviceID','Speed','NetworkAddresses','PermanentAddress','AdapterType','MACAddress','Manufacturer','NetConnectionID','ProductName','TimeOfLastReset'

    # (Get-CimData Win32_NetworkAdapterConfiguration )[4]
}