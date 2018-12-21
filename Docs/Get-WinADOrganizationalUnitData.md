---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Get-WinADOrganizationalUnitData

## SYNOPSIS
Short description

## SYNTAX

```
Get-WinADOrganizationalUnitData [[-OrganizationalUnit] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
An example
```

Get-WinADOrganizationalUnitData -OrganizationalUnit 'OU=Users-O365,OU=Production,DC=ad,DC=evotec,DC=xyz'

## PARAMETERS

### -OrganizationalUnit
Parameter description

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Output of function:
    CanonicalName                   : ad.evotec.xyz/Production/Users-O365
    City                            :
    CN                              :
    Country                         : PL
    Created                         : 09.11.2018 17:38:32
    Description                     : OU for Synchronization of Users to Office 365
    DisplayName                     :
    DistinguishedName               : OU=Users-O365,OU=Production,DC=ad,DC=evotec,DC=xyz
    LinkedGroupPolicyObjects        : {cn={74D09C6F-35E9-4743-BCF7-F87D7010C60D},cn=policies,cn=system,DC=ad,DC=evotec,DC=xyz}
    ManagedBy                       :
    Modified                        : 19.11.2018 22:54:47
    Name                            : Users-O365
    PostalCode                      :
    ProtectedFromAccidentalDeletion : True
    State                           :
    StreetAddress                   :

## RELATED LINKS
