function Get-ComputerBios {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )

    #$Data1 = Get-WmiObject win32_bios -ComputerName $ComputerName| Select-Object Status, Version, PrimaryBIOS, Manufacturer, ReleaseDate, SerialNumber
    #return $Data1

    [string] $Class = 'win32_bios'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'PSComputerName', 'Status', 'Version', 'PrimaryBIOS', 'Manufacturer', 'ReleaseDate', 'SerialNumber', 'SMBIOSBIOSVersion', 'SMBIOSMajorVersion', 'SMBIOSMinorVersion', 'SystemBiosMajorVersion', 'SystemBiosMinorVersion'

    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Status       = $Data.Status
                    Version      = $Data.Version
                    VersionBIOS  = -join ($Data.SMBIOSMajorVersion, ".", $Data.SMBIOSMinorVersion, ".", $Data.SystemBiosMajorVersion, ".", $Data.SystemBiosMinorVersion)
                    PrimaryBIOS  = $Data.PrimaryBIOS
                    Manufacturer = $Data.Manufacturer
                    ReleaseDate  = $Data.ReleaseDate
                }
            }
        }
    }
}