---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Get-ComputerSystem

## SYNOPSIS
Short description

## SYNTAX

```
Get-ComputerSystem [[-ComputerName] <String[]>] [[-Protocol] <String>] [-All] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Get-ComputerSystem -ComputerName AD1, AD2, EVO1, ADFFS | ft -a *
```

Output:
WARNING: Get-ComputerSystem - No data for computer ADFFS.
Most likely an error on receiving side.
ComputerName Name Manufacturer          Domain        Model           Systemtype   PrimaryOwnerName PCSystemType PartOfDomain CurrentTimeZone BootupState SystemFamily    Roles
------------ ---- ------------          ------        -----           ----------   ---------------- ------------ ------------ --------------- ----------- ------------    -----
AD1          AD1  Microsoft Corporation ad.evotec.xyz Virtual Machine x64-based PC Windows User                1         True              60 Normal boot Virtual Machine LM_Workstation, LM_Server, Primary_Domain_Controller, Timesource, NT, DFS
AD2          AD2  Microsoft Corporation ad.evotec.xyz Virtual Machine x64-based PC Windows User                1         True              60 Normal boot Virtual Machine LM_Workstation, LM_Server, Backup_Domain_Controller, Timesource, NT, DFS
EVO1         EVO1 MSI                   ad.evotec.xyz MS-7980         x64-based PC                             1         True              60 Normal boot Default string  LM_Workstation, LM_Server, SQLServer, NT, Potential_Browser, Master_Browser

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
