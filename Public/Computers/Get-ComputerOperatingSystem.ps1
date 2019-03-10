function Get-ComputerOperatingSystem {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_operatingsystem'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Caption', 'Manufacturer', 'InstallDate', 'OSArchitecture', 'Version', 'SerialNumber', 'BootDevice', 'WindowsDirectory', 'CountryCode', 'OSLanguage', 'OSProductSuite', 'PSComputerName', 'LastBootUpTime', 'LocalDateTime'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName     = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Caption          = $Data.Caption
                    Manufacturer     = $Data.Manufacturer
                    OSArchitecture   = $Data.OSArchitecture
                    OSLanguage       = $Data.OSLanguage
                    OSProductSuite   = $Data.OSProductSuite
                    InstallDate      = $Data.InstallDate
                    LastBootUpTime   = $Data.LastBootUpTime
                    LocalDateTime    = $Data.LocalDateTime
                    Version          = $Data.Version
                    SerialNumber     = $Data.SerialNumber
                    BootDevice       = $Data.BootDevice
                    WindowsDirectory = $Data.WindowsDirectory
                    CountryCode      = $Data.CountryCode
                }
            }
        }
    }
}