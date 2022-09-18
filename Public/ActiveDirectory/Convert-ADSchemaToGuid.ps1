function Convert-ADSchemaToGuid {
    <#
    .SYNOPSIS
    Converts name of schema properties to guids

    .DESCRIPTION
    Converts name of schema properties to guids

    .PARAMETER SchemaName
    Schema Name to convert to guid

    .PARAMETER All
    Get hashtable of all schema properties and their guids

    .PARAMETER Domain
    Domain to query. By default the current domain is used

    .PARAMETER RootDSE
    RootDSE to query. By default RootDSE is queried from the domain

    .EXAMPLE
    Convert-ADSchemaToGuid -SchemaName 'ms-Exch-MSO-Forward-Sync-Cookie'

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $SchemaName,
        [string] $Domain = $Env:USERDNSDOMAIN,
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE
    )
    if ($RootDSE) {
        $Script:RootDSE = $RootDSE
    } elseif (-not $Script:RootDSE) {
        $Script:RootDSE = Get-ADRootDSE -Server $Domain
    } else {
        $Script:RootDSE = Get-ADRootDSE -Server $Domain
    }
    # Create a hashtable to store the GUID value of each schema class and attribute
    if (-not $Script:ADGuidMap) {
        $Script:ADGuidMap = [ordered] @{
            'All' = [System.GUID]'00000000-0000-0000-0000-000000000000'
        }
        $StandardRights = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter "(schemaidguid=*)" -Properties lDAPDisplayName, schemaIDGUID
        foreach ($Guid in $StandardRights) {
            $Script:ADGuidMap[$Guid.lDAPDisplayName] = ([System.GUID]$Guid.schemaIDGUID).Guid
            $Script:ADGuidMap[$Guid.Name] = ([System.GUID]$Guid.schemaIDGUID).Guid
        }

        #Create a hashtable to store the GUID value of each extended right in the forest
        $ExtendedRightsGuids = Get-ADObject -SearchBase $Script:RootDSE.ConfigurationNamingContext -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties name, displayName, rightsGuid
        foreach ($Guid in $ExtendedRightsGuids) {
            #if ($Guid.Name) {
            $Script:ADGuidMap[$Guid.Name] = ([System.GUID]$Guid.RightsGuid).Guid
            #}
            $Script:ADGuidMap[$Guid.DisplayName] = ([System.GUID]$Guid.RightsGuid).Guid
        }
    }
    if ($SchemaName) {
        $Script:ADGuidMap[$SchemaName]
    } else {
        $Script:ADGuidMap
    }
}