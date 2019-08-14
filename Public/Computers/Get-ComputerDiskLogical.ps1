function Get-ComputerDiskLogical {
    <#
    .SYNOPSIS
    Getting drive space

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER Protocol
    Parameter description

    .PARAMETER RoundingPlaceRoundingPlace

    .PARAMETER RoundingPlace

    .PARAMETER OnlyLocalDisk
    Parameter description

    .PARAMETER All
    Parameter description

    .EXAMPLE
    Get-ComputerDiskLogical -ComputerName AD1, AD2, EVOWIN -OnlyLocalDisk | ft -AutoSize

    Output:

    ComputerName DeviceID DriveType  ProviderName FreeSpace UsedSpace TotalSpace FreePercent UsedPercent VolumeName
    ------------ -------- ---------  ------------ --------- --------- ---------- ----------- ----------- ----------
    AD2          C:       Local Disk                  96,96     29,49     126,45       76,68       23,32
    AD1          C:       Local Disk                 103,17     23,28     126,45       81,59       18,41
    EVOWIN       C:       Local Disk                 133,31    343,03     476,34       27,99       72,01
    EVOWIN       D:       Local Disk                   2433     361,4    2794,39       87,07       12,93 Media
    EVOWIN       E:       Local Disk                  66,05     399,7     465,75       14,18       85,82 Testing Environment

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [string][ValidateSet('GB', 'TB', 'MB')] $Size = 'GB',
        [int] $RoundingPlace = 2,
        [int] $RoundingPlacePercent = 2,
        [switch] $OnlyLocalDisk,
        [switch] $All
    )
    [string] $Class = 'win32_logicalDisk'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'DeviceID', 'DriveType', 'ProviderName', 'FreeSpace', 'Size', 'VolumeName', 'PSComputerName'
    }

    $DriveType = @{
        '0' = 'Unknown'
        '1' = 'No Root Directory'
        '2' = 'Removable Disk'
        '3' = 'Local Disk'
        '4' = 'Network Drive'
        '5' = 'Compact Disc'
        '6' = 'RAM Disk'
    }

    $Divider = "1$Size"

    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        $Output = foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    DeviceID     = $Data.DeviceID
                    DriveType    = $DriveType["$($Data.DriveType)"]
                    ProviderName = $Data.ProviderName
                    #SerialNumber     = if ($Data.SerialNumber) { $Data.SerialNumber.Trim() } else { '' }
                    FreeSpace    = [Math]::Round($Data.FreeSpace / $Divider, $RoundingPlace)
                    UsedSpace    = [Math]::Round(($Data.Size - $Data.FreeSpace) / $Divider, $RoundingPlace)
                    TotalSpace   = [Math]::Round($Data.Size / $Divider, $RoundingPlace)

                    FreePercent  = if ($Data.Size -gt 0 ) { [Math]::round(($Data.FreeSpace / $Data.Size) * 100, $RoundingPlacePercent) } else { '0' }
                    UsedPercent  = if ($Data.Size -gt 0 ) { [Math]::round((($Data.Size - $Data.FreeSpace) / $Data.Size) * 100, $RoundingPlacePercent) } else { '0' }
                    VolumeName   = $Data.VolumeName
                    # Partitions       = $Data.Partitions
                    # SizeGB           = $Data.Size / 1Gb -as [int]
                    # PNPDeviceID      = $Data.PNPDeviceID
                    # UsedSpace(in GB)    FreeSpace(in GB)    TotalSpace(in GB)


                }

            }
        }
        if ($OnlyLocalDisk) {
            $Output | Where-Object { $_.DriveType -eq 'Local Disk' }
        } else {
            $Output
        }
    }
}