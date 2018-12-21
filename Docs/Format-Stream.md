---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Format-Stream

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### All (Default)
```
Format-Stream [[-InputObject] <Object>] [-HideTableHeaders] [[-ColumnHeaderSize] <Int32>] [-AlignRight]
 [[-Stream] <String>] [-List] [-Transpose] [[-TransposeSort] <String>] [-ForegroundColor <ConsoleColor[]>]
 [-ForegroundColorRow <Int32[]>] [<CommonParameters>]
```

### Property
```
Format-Stream [[-InputObject] <Object>] [[-Property] <Object[]>] [-HideTableHeaders]
 [[-ColumnHeaderSize] <Int32>] [-AlignRight] [[-Stream] <String>] [-List] [-Transpose]
 [[-TransposeSort] <String>] [-ForegroundColor <ConsoleColor[]>] [-ForegroundColorRow <Int32[]>]
 [<CommonParameters>]
```

### ExcludeProperty
```
Format-Stream [[-InputObject] <Object>] [[-ExcludeProperty] <Object[]>] [-HideTableHeaders]
 [[-ColumnHeaderSize] <Int32>] [-AlignRight] [[-Stream] <String>] [-List] [-Transpose]
 [[-TransposeSort] <String>] [-ForegroundColor <ConsoleColor[]>] [-ForegroundColorRow <Int32[]>]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AlignRight
{{Fill AlignRight Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnHeaderSize
{{Fill ColumnHeaderSize Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeProperty
{{Fill ExcludeProperty Description}}

```yaml
Type: Object[]
Parameter Sets: ExcludeProperty
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForegroundColor
{{Fill ForegroundColor Description}}

```yaml
Type: ConsoleColor[]
Parameter Sets: (All)
Aliases: Color
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForegroundColorRow
{{Fill ForegroundColorRow Description}}

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: ColorRow

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideTableHeaders
{{Fill HideTableHeaders Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
{{Fill InputObject Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -List
{{Fill List Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: AsList

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
{{Fill Property Description}}

```yaml
Type: Object[]
Parameter Sets: Property
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stream
{{Fill Stream Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Output, Host, Warning, Verbose, Debug, Information

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Transpose
{{Fill Transpose Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Rotate, RotateData, TransposeColumnsRows, TransposeData

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TransposeSort
{{Fill TransposeSort Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: ASC, DESC, NONE

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
