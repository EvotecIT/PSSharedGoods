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

    .PARAMETER DisplayName
    Return the schema name by display name. By default it returns as Name

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
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE,
        [switch] $DisplayName
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
    if (-not $Script:ADSchemaMap -or -not $Script:ADSchemaMapDisplayName) {
        $Script:ADSchemaMap = @{ }
        $Script:ADSchemaMapDisplayName = @{ }
        $Script:ADSchemaMapDisplayName['00000000-0000-0000-0000-000000000000'] = 'All'
        $Script:ADSchemaMap.Add('00000000-0000-0000-0000-000000000000', 'All')
        Write-Verbose "Convert-ADGuidToSchema - Querying Schema from $QueryServer"
        $Schema = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter '(schemaIDGUID=*)' -Properties name, lDAPDisplayName, schemaIDGUID -Server $QueryServer
        foreach ($S in $Schema) {
            $Script:ADSchemaMap["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.name
            $Script:ADSchemaMapDisplayName["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.lDAPDisplayName
        }
        Write-Verbose "Convert-ADGuidToSchema - Querying Extended Rights from $QueryServer"
        $Extended = Get-ADObject -SearchBase "CN=Extended-Rights,$($Script:RootDSE.configurationNamingContext)" -LDAPFilter '(objectClass=controlAccessRight)' -Properties name, displayName, rightsGUID -Server $QueryServer
        foreach ($S in $Extended) {
            $Script:ADSchemaMap["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.name
            $Script:ADSchemaMapDisplayName["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.displayName
        }
    }
    if ($Guid) {
        if ($DisplayName) {
            $Script:ADSchemaMapDisplayName[$Guid]
        } else {
            $Script:ADSchemaMap[$Guid]
        }
    } else {
        if ($DisplayName) {
            $Script:ADSchemaMapDisplayName
        } else {
            $Script:ADSchemaMap
        }
    }
}