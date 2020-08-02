function Get-ComputerDisk {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER Protocol
    Parameter description

    .PARAMETER All
    Parameter description

    .EXAMPLE
    Get-ComputerDisk -ComputerName AD1, AD2, EVO1, AD2019 | Format-Table -AutoSize *

    Output:
    WARNING: Get-ComputerSystem - No data for computer AD2019. Most likely an error on receiving side.

    ComputerName Index Model                     Caption                   SerialNumber         Description MediaType             FirmwareRevision Partitions SizeGB PNPDeviceID
    ------------ ----- -----                     -------                   ------------         ----------- ---------             ---------------- ---------- ------ -----------
    AD1              0 Microsoft Virtual Disk    Microsoft Virtual Disk                         Disk drive  Fixed hard disk media 1.0                       3    127 SCSI\DISK&VEN_MSFT&PROD_VIRTUAL_DISK\000000
    AD2              0 Microsoft Virtual Disk    Microsoft Virtual Disk                         Disk drive  Fixed hard disk media 1.0                       3    127 SCSI\DISK&VEN_MSFT&PROD_VIRTUAL_DISK\000000
    EVO1             0 WDC WD30EFRX-68AX9N0      WDC WD30EFRX-68AX9N0      WD-WMC1T2351095      Disk drive  Fixed hard disk media 80.00A80                  1   2795 SCSI\DISK&VEN_WDC&PROD_WD30EFRX-68AX9N0\4&191557A4&0&000000
    EVO1             2 Samsung SSD 950 PRO 512GB Samsung SSD 950 PRO 512GB 0025_3857_61B0_0EF2. Disk drive  Fixed hard disk media 2B0Q                      3    477 SCSI\DISK&VEN_NVME&PROD_SAMSUNG_SSD_950\5&35365596&0&000000
    EVO1             1 Samsung SSD 860 EVO 500GB Samsung SSD 860 EVO 500GB S3Z2NB0K176976A      Disk drive  Fixed hard disk media RVT01B6Q                  1    466 SCSI\DISK&VEN_SAMSUNG&PROD_SSD\4&191557A4&0&000100

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_diskdrive'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Index', 'Model', 'Caption', 'SerialNumber', 'Description', 'MediaType', 'FirmwareRevision', 'Partitions', 'Size', 'PNPDeviceID', 'PSComputerName'
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
                    Index            = $Data.Index
                    Model            = $Data.Model
                    Caption          = $Data.Caption
                    SerialNumber     = if ($Data.SerialNumber) { $Data.SerialNumber.Trim() } else { '' }
                    Description      = $Data.Description
                    MediaType        = $Data.MediaType
                    FirmwareRevision = $Data.FirmwareRevision
                    Partitions       = $Data.Partitions
                    SizeGB           = $Data.Size / 1Gb -as [int]
                    PNPDeviceID      = $Data.PNPDeviceID
                }
            }
        }
    }
}