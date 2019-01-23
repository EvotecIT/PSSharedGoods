---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# ConvertFrom-X500Address

## SYNOPSIS

## SYNTAX

```
ConvertFrom-X500Address [[-IMCEAEXString] <String>] [-Full] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
By default returns string without @evotec.pl in the end. This is because the string from NDR needs domain name removed to be able to add it back to Exchange
```

ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=5209048016da47689b4421790ad1763f-EVOTEC+20PL+20Recepcja+20G@evotec.pl'
ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=8bcad655e07c46788fe1f796162cd87f-EVOTEC+20PL+20Recepcja+20G@evotec.pl'
ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl'
ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl'

### EXAMPLE 2
```
ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=5209048016da47689b4421790ad1763f-EVOTEC+20PL+20Recepcja+20G@evotec.pl' -Full
```

ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=8bcad655e07c46788fe1f796162cd87f-EVOTEC+20PL+20Recepcja+20G@evotec.pl' -Full
ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl' -Full
ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl' -Full

## PARAMETERS

### -IMCEAEXString
{{Fill IMCEAEXString Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Full
{{Fill Full Description}}

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

## RELATED LINKS
