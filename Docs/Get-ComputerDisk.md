---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Get-ComputerDisk

## SYNOPSIS
Short description

## SYNTAX

```
Get-ComputerDisk [[-ComputerName] <String[]>] [[-Protocol] <String>] [-All] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Get-ComputerDisk -ComputerName AD1, AD2, EVO1, AD2019 | Format-Table -AutoSize *
```

Output:
WARNING: Get-ComputerSystem - No data for computer AD2019.
Most likely an error on receiving side.

ComputerName Index Model                     Caption                   SerialNumber         Description MediaType             FirmwareRevision Partitions SizeGB PNPDeviceID
------------ ----- -----                     -------                   ------------         ----------- ---------             ---------------- ---------- ------ -----------
AD1              0 Microsoft Virtual Disk    Microsoft Virtual Disk                         Disk drive  Fixed hard disk media 1.0                       3    127 SCSI\DISK&VEN_MSFT&PROD_VIRTUAL_DISK\000000
AD2              0 Microsoft Virtual Disk    Microsoft Virtual Disk                         Disk drive  Fixed hard disk media 1.0                       3    127 SCSI\DISK&VEN_MSFT&PROD_VIRTUAL_DISK\000000
EVO1             0 WDC WD30EFRX-68AX9N0      WDC WD30EFRX-68AX9N0      WD-WMC1T2351095      Disk drive  Fixed hard disk media 80.00A80                  1   2795 SCSI\DISK&VEN_WDC&PROD_WD30EFRX-68AX9N0\4&191557A4&0&000000
EVO1             2 Samsung SSD 950 PRO 512GB Samsung SSD 950 PRO 512GB 0025_3857_61B0_0EF2.
Disk drive  Fixed hard disk media 2B0Q                      3    477 SCSI\DISK&VEN_NVME&PROD_SAMSUNG_SSD_950\5&35365596&0&000000
EVO1             1 Samsung SSD 860 EVO 500GB Samsung SSD 860 EVO 500GB S3Z2NB0K176976A      Disk drive  Fixed hard disk media RVT01B6Q                  1    466 SCSI\DISK&VEN_SAMSUNG&PROD_SSD\4&191557A4&0&000100

## PARAMETERS

### -ComputerName
Parameter description

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Env:COMPUTERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Parameter description

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
