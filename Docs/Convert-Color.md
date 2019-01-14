---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Convert-Color

## SYNOPSIS
This color converter gives you the hexadecimal values of your RGB colors and vice versa (RGB to HEX)

## SYNTAX

### RGB
```
Convert-Color [[-RGB] <Object>] [<CommonParameters>]
```

### HEX
```
Convert-Color [[-HEX] <String>] [<CommonParameters>]
```

## DESCRIPTION
This color converter gives you the hexadecimal values of your RGB colors and vice versa (RGB to HEX).
Use it to convert your colors and prepare your graphics and HTML web pages.

## EXAMPLES

### EXAMPLE 1
```
.\convert-color -hex FFFFFF
```

Converts hex value FFFFFF to RGB

### EXAMPLE 2
```
.\convert-color -RGB 123,200,255
```

Converts Red = 123 Green = 200 Blue = 255 to Hex value

## PARAMETERS

### -RGB
{{Fill RGB Description}}

```yaml
Type: Object
Parameter Sets: RGB
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HEX
Enter the Hex value to be converted.
Do not use the '#' symbol.
(Ex: 3333CC converts to Red: 51 Green: 51 Blue: 204)

```yaml
Type: String
Parameter Sets: HEX
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
