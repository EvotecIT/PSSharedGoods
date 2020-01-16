function Get-WinADForestGUIDs {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Domain
    Parameter description

    .PARAMETER RootDSE
    Parameter description

    .PARAMETER DisplayNameKey
    Parameter description

    .EXAMPLE
    Get-WinADForestGUIDs

    .EXAMPLE
    Get-WinADForestGUIDs -DisplayNameKey

    .NOTES
    General notes
    #>
    [alias('Get-WinADDomainGUIDs')]
    [cmdletbinding()]
    param(
        [string] $Domain = $Env:USERDNSDOMAIN,
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE,
        [switch] $DisplayNameKey
    )
    if ($null -eq $RootDSE) {
        $RootDSE = Get-ADRootDSE -Server $Domain
    }
    $GUID = @{ }
    $GUID.Add('00000000-0000-0000-0000-000000000000', 'All')
    $Schema = Get-ADObject -SearchBase $RootDSE.schemaNamingContext -LDAPFilter '(schemaIDGUID=*)' -Properties name, schemaIDGUID
    foreach ($S in $Schema) {
        <#
        if ($GUID.Keys -notcontains $S.schemaIDGUID ) {
            $GUID.add([System.GUID]$S.schemaIDGUID, $S.name)
        }
        #>
        if ($DisplayNameKey) {
            $GUID["$($S.name)"] = $(([System.GUID]$S.schemaIDGUID).Guid)
        } else {
            $GUID["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.name
        }
    }


    $Extended = Get-ADObject -SearchBase "CN=Extended-Rights,$($RootDSE.configurationNamingContext)" -LDAPFilter '(objectClass=controlAccessRight)' -Properties name, rightsGUID
    foreach ($S in $Extended) {
        <#
        if ($GUID.Keys -notcontains $S.rightsGUID ) {
            $GUID.add([System.GUID]$S.rightsGUID, $S.name)
        }
        #>
        if ($DisplayNameKey) {
            $GUID["$($S.name)"] = $(([System.GUID]$S.rightsGUID).Guid)
        } else {
            $GUID["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.name
        }
    }
    return $GUID
}