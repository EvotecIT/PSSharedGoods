function ConvertFrom-NetbiosName {
    <#
    .SYNOPSIS
    Converts a NetBIOS name to its corresponding domain name and object name.

    .DESCRIPTION
    This function takes a NetBIOS name in the format 'Domain\Object' and converts it to the corresponding domain name and object name.

    .PARAMETER Identity
    Specifies the NetBIOS name(s) to convert.

    .EXAMPLE
    'TEST\Domain Admins', 'EVOTEC\Domain Admins', 'EVOTECPL\Domain Admins' | ConvertFrom-NetbiosName
    Converts the NetBIOS names 'TEST\Domain Admins', 'EVOTEC\Domain Admins', and 'EVOTECPL\Domain Admins' to their corresponding domain names and object names.

    .EXAMPLE
    ConvertFrom-NetbiosName -Identity 'TEST\Domain Admins', 'EVOTEC\Domain Admins', 'EVOTECPL\Domain Admins'
    Converts the NetBIOS names 'TEST\Domain Admins', 'EVOTEC\Domain Admins', and 'EVOTECPL\Domain Admins' to their corresponding domain names and object names.

    #>
    [cmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string[]] $Identity
    )
    process {
        foreach ($Ident in $Identity) {
            if ($Ident -like '*\*') {
                $NetbiosWithObject = $Ident -split "\\"
                if ($NetbiosWithObject.Count -eq 2) {
                    $LDAPQuery = ([ADSI]"LDAP://$($NetbiosWithObject[0])")
                    $DomainName = ConvertFrom-DistinguishedName -DistinguishedName $LDAPQuery.distinguishedName -ToDomainCN
                    [PSCustomObject] @{
                        DomainName = $DomainName
                        Name       = $NetbiosWithObject[1]
                    }
                } else {
                    # we can't be sure what we got so lets push back what we got
                    [PSCustomObject] @{
                        DomainName = ''
                        Name       = $Ident
                    }
                }
            } else {
                # we can't be sure what we got so lets push back what we got
                [PSCustomObject] @{
                    DomainName = ''
                    Name       = $Ident
                }
            }
        }
    }
}
<#
'TEST\Domain Admins', 'EVOTEC\Domain Admins', 'EVOTECPL\Domain Admins' | ConvertFrom-NetbiosName
ConvertFrom-NetbiosName -Identity 'TEST\Domain Admins', 'EVOTEC\Domain Admins', 'EVOTECPL\Domain Admins'
#>