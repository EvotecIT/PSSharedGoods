function Convert-ADGuidToSchema {
    <#
    .SYNOPSIS
    Converts Guid to schema properties

    .DESCRIPTION
    Converts Guid to schema properties

    .PARAMETER Guid
    Guid to Convert to Schema Name

    .PARAMETER Domain
    Domain to query. By default the current domain is used

   .PARAMETER RootDSE
    RootDSE to query. By default RootDSE is queried from the domain

    .EXAMPLE
    $T2 = '570b9266-bbb3-4fad-a712-d2e3fedc34dd'
    $T = [guid] '570b9266-bbb3-4fad-a712-d2e3fedc34dd'

    Convert-ADGuidToSchema -Guid $T
    Convert-ADGuidToSchema -Guid $T2

    .NOTES
    General notes
    #>
    [alias('Get-WinADDomainGUIDs', 'Get-WinADForestGUIDs')]
    [cmdletbinding()]
    param(
        [string] $Guid,
        [string] $Domain = $Env:USERDNSDOMAIN,
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE
    )
    if ($RootDSE) {
        $Script:RootDSE = $RootDSE
    } elseif (-not $Script:RootDSE) {
        if ($Domain) {
            $Script:RootDSE = Get-ADRootDSE -Server $Domain
        } else {
            $Script:RootDSE = Get-ADRootDSE
        }
    }
    $DomainCN = ConvertFrom-DistinguishedName -DistinguishedName $Script:RootDSE.defaultNamingContext -ToDomainCN
    $QueryServer = (Get-ADDomainController -DomainName $DomainCN -Discover -ErrorAction Stop).Hostname[0]
    if (-not $Script:ADSchemaMap) {
        $Script:ADSchemaMap = @{ }
        $Script:ADSchemaMap.Add('00000000-0000-0000-0000-000000000000', 'All')
        $Schema = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter '(schemaIDGUID=*)' -Properties name, schemaIDGUID -Server $QueryServer
        foreach ($S in $Schema) {
            $Script:ADSchemaMap["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.name
        }
        $Extended = Get-ADObject -SearchBase "CN=Extended-Rights,$($Script:RootDSE.configurationNamingContext)" -LDAPFilter '(objectClass=controlAccessRight)' -Properties name, displayName, rightsGUID -Server $QueryServer
        foreach ($S in $Extended) {
            $Script:ADSchemaMap["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.name
        }
    }
    if ($Guid) {
        $Script:ADSchemaMap[$Guid]
    } else {
        $Script:ADSchemaMap
    }
}