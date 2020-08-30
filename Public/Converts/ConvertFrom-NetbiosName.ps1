function ConvertFrom-NetbiosName {
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