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
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE #,
        #[switch] $DisplayNameKey
    )
    if ($RootDSE) {
        $Script:RootDSE = $RootDSE
    } elseif (-not $Script:RootDSE) {
        $Script:RootDSE = Get-ADRootDSE -Server $Domain
    } else {
        $Script:RootDSE = Get-ADRootDSE -Server $Domain
    }
    if (-not $Script:ADSchemaMap) {
        $Script:ADSchemaMap = @{ }
        $Script:ADSchemaMap.Add('00000000-0000-0000-0000-000000000000', 'All')
        $Schema = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter '(schemaIDGUID=*)' -Properties name, schemaIDGUID
        foreach ($S in $Schema) {
            # if ($DisplayNameKey) {
            #$Script:ADSchemaMap["$($S.name)"] = $(([System.GUID]$S.schemaIDGUID).Guid)
            # } else {
            $Script:ADSchemaMap["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.name
            # }
        }


        $Extended = Get-ADObject -SearchBase "CN=Extended-Rights,$($Script:RootDSE.configurationNamingContext)" -LDAPFilter '(objectClass=controlAccessRight)' -Properties name, displayName, rightsGUID
        foreach ($S in $Extended) {
            #if ($DisplayNameKey) {
            #$Script:ADSchemaMap["$($S.name)"] = $(([System.GUID]$S.rightsGUID).Guid)
            #} else {
            $Script:ADSchemaMap["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.name
            #}
        }
    }
    if ($Guid) {
        $Script:ADSchemaMap[$Guid]
    } else {
        $Script:ADSchemaMap
    }
}