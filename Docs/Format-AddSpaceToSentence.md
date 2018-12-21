---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Format-AddSpaceToSentence

## SYNOPSIS
Short description

## SYNTAX

```
Format-AddSpaceToSentence [-Text] <String[]> [-ToLowerCase] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
$test = @(
```

'OnceUponATime',
    'OnceUponATime1',
    'Money@Risk',
    'OnceUponATime123',
    'AHappyMan2014'
    'OnceUponATime_123'
)

Format-AddSpaceToSentence -Text $Test

$Test | Format-AddSpaceToSentence -ToLowerCase

## PARAMETERS

### -Text
Parameter description

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ToLowerCase
{{Fill ToLowerCase Description}}

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
