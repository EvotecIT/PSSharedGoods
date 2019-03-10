---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Set-ServiceRecovery

## SYNOPSIS
#

## SYNTAX

```
Set-ServiceRecovery [-ServiceDisplayName] <String> [-Server] <String> [[-action1] <String>] [[-time1] <Int32>]
 [[-action2] <String>] [[-time2] <Int32>] [[-actionLast] <String>] [[-timeLast] <Int32>]
 [[-resetCounter] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Set-ServiceRecovery -ServiceDisplayName "Pulseway" -Server "MAIL1"
```

## PARAMETERS

### -ServiceDisplayName
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -action1
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Restart
Accept pipeline input: False
Accept wildcard characters: False
```

### -time1
Parameter description

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 30000
Accept pipeline input: False
Accept wildcard characters: False
```

### -action2
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Restart
Accept pipeline input: False
Accept wildcard characters: False
```

### -time2
Parameter description

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 30000
Accept pipeline input: False
Accept wildcard characters: False
```

### -actionLast
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Restart
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeLast
Parameter description

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 30000
Accept pipeline input: False
Accept wildcard characters: False
```

### -resetCounter
Parameter description

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 4000
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
