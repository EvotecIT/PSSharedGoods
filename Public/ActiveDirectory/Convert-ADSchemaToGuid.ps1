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

    .PARAMETER AsString
    Return the guid as a string

    .EXAMPLE
    Convert-ADSchemaToGuid -SchemaName 'ms-Exch-MSO-Forward-Sync-Cookie'

    .EXAMPLE
    Convert-ADSchemaToGuid -SchemaName 'ms-Exch-MSO-Forward-Sync-Cookie' -AsString

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $SchemaName,
        [string] $Domain = $Env:USERDNSDOMAIN,
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE,
        [switch] $AsString
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
    # Create a hashtable to store the GUID value of each schema class and attribute
    if (-not $Script:ADGuidMap -or -not $Script:ADGuidMapString) {
        $Script:ADGuidMap = [ordered] @{
            'All' = [System.GUID]'00000000-0000-0000-0000-000000000000'
        }
        $Script:ADGuidMapString = [ordered] @{
            'All' = '00000000-0000-0000-0000-000000000000'
        }
        $StandardRights = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter "(schemaidguid=*)" -Properties lDAPDisplayName, schemaIDGUID -Server $QueryServer
        foreach ($Guid in $StandardRights) {
            $Script:ADGuidMapString[$Guid.lDAPDisplayName] = ([System.GUID]$Guid.schemaIDGUID).Guid
            $Script:ADGuidMapString[$Guid.Name] = ([System.GUID]$Guid.schemaIDGUID).Guid
            $Script:ADGuidMap[$Guid.lDAPDisplayName] = ([System.GUID]$Guid.schemaIDGUID)
            $Script:ADGuidMap[$Guid.Name] = ([System.GUID]$Guid.schemaIDGUID)
        }

        #Create a hashtable to store the GUID value of each extended right in the forest
        $ExtendedRightsGuids = Get-ADObject -SearchBase $Script:RootDSE.ConfigurationNamingContext -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties name, displayName, rightsGuid -Server $QueryServer
        foreach ($Guid in $ExtendedRightsGuids) {
            $Script:ADGuidMapString[$Guid.Name] = ([System.GUID]$Guid.RightsGuid).Guid
            $Script:ADGuidMapString[$Guid.DisplayName] = ([System.GUID]$Guid.RightsGuid).Guid
            $Script:ADGuidMap[$Guid.Name] = ([System.GUID]$Guid.RightsGuid)
            $Script:ADGuidMap[$Guid.DisplayName] = ([System.GUID]$Guid.RightsGuid)
        }
    }
    if ($SchemaName) {
        if ($AsString) {
            return $Script:ADGuidMapString[$SchemaName]
        } else {
            return $Script:ADGuidMap[$SchemaName]
        }
    } else {
        if ($AsString) {
            $Script:ADGuidMapString
        } else {
            $Script:ADGuidMap
        }
    }
}