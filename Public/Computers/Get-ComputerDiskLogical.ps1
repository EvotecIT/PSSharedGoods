function Get-ComputerDiskLogical {
    <#
    .SYNOPSIS
    Retrieves logical disk information for specified computers.

    .DESCRIPTION
    This function retrieves logical disk information for the specified computers. It provides details such as DeviceID, DriveType, ProviderName, FreeSpace, UsedSpace, TotalSpace, FreePercent, UsedPercent, and VolumeName.

    .PARAMETER ComputerName
    Specifies the names of the computers for which to retrieve disk information.

    .PARAMETER Protocol
    Specifies the protocol to use for retrieving disk information. Valid values are 'Default', 'Dcom', and 'Wsman'.

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER RoundingPlace
    Specifies the number of decimal places to round the disk space values to.

    .PARAMETER OnlyLocalDisk
    Indicates that only local disks should be included in the output.

    .PARAMETER All
    Indicates that information for all disks should be retrieved.

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
    Additional notes about the function.
    #>

    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [string][ValidateSet('GB', 'TB', 'MB')] $Size = 'GB',
        [int] $RoundingPlace = 2,
        [int] $RoundingPlacePercent = 2,
        [switch] $OnlyLocalDisk,
        [switch] $All
    )

    if (-Not ('Pinvoke.Win32Utils' -as [type])) {
        Add-Type -TypeDefinition @'
        using System.Runtime.InteropServices;
        using System.Text;
        namespace pinvoke {
            public static class Win32Utils {
                [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
                public static extern uint QueryDosDevice(string lpDeviceName, StringBuilder lpTargetPath, int ucchMax);
            }
        }
'@
    }

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

    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        $Output = foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                if ($Info.ComputerName -eq $Env:COMPUTERNAME) {
                    $DiskPartitionName = [System.Text.StringBuilder]::new(1024)
                    if ($Data.DeviceID) {
                        [void][PInvoke.Win32Utils]::QueryDosDevice(($Data.DeviceID), $DiskPartitionName, $DiskPartitionName.Capacity)
                    }
                    $DiskPartitionNumber = $DiskPartitionName.ToString()
                } else {
                    $DiskPartitionNumber = ''
                }
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName  = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    DeviceID      = $Data.DeviceID
                    DriveType     = $DriveType["$($Data.DriveType)"]
                    ProviderName  = $Data.ProviderName
                    #SerialNumber     = if ($Data.SerialNumber) { $Data.SerialNumber.Trim() } else { '' }
                    FreeSpace     = [Math]::Round($Data.FreeSpace / $Divider, $RoundingPlace)
                    UsedSpace     = [Math]::Round(($Data.Size - $Data.FreeSpace) / $Divider, $RoundingPlace)
                    TotalSpace    = [Math]::Round($Data.Size / $Divider, $RoundingPlace)

                    FreePercent   = if ($Data.Size -gt 0 ) { [Math]::round(($Data.FreeSpace / $Data.Size) * 100, $RoundingPlacePercent) } else { '0' }
                    UsedPercent   = if ($Data.Size -gt 0 ) { [Math]::round((($Data.Size - $Data.FreeSpace) / $Data.Size) * 100, $RoundingPlacePercent) } else { '0' }
                    VolumeName    = $Data.VolumeName
                    DiskPartition = $DiskPartitionNumber
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
