---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Get-FileName

## SYNOPSIS
Short description

## SYNTAX

```
Get-FileName [[-Extension] <String>] [-Temporary] [-TemporaryFileOnly] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Get-FileName -Temporary
```

Output: 3ymsxvav.tmp

Get-FileName -Temporary
Output: C:\Users\pklys\AppData\Local\Temp\tmpD74C.tmp

Get-FileName -Temporary -Extension 'xlsx'
Output: C:\Users\pklys\AppData\Local\Temp\tmp45B6.xlsx

## PARAMETERS

### -Extension
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Tmp
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temporary
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

### -TemporaryFileOnly
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
