function Get-ComputerBios {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )

    $Data1 = Get-WmiObject win32_bios -ComputerName $ComputerName| Select-Object Status, Version, PrimaryBIOS, Manufacturer, ReleaseDate, SerialNumber
    return $Data1
}