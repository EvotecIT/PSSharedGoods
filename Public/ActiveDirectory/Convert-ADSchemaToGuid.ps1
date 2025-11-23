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

    .PARAMETER Credential
    Alternate credentials for RootDSE/DC/schema queries.

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
        [string] $Domain,
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE,
        [switch] $AsString,
        [pscredential] $Credential
    )
    $credentialSplat = @{}
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $credentialSplat['Credential'] = $Credential
    }
    if (-not $Script:ADGuidMap -or -not $Script:ADGuidMapString) {

        if ($RootDSE) {
            $Script:RootDSE = $RootDSE
        } elseif (-not $Script:RootDSE) {
            if ($Domain) {
                $Script:RootDSE = Get-ADRootDSE -Server $Domain @credentialSplat
            } else {
                $Script:RootDSE = Get-ADRootDSE @credentialSplat
            }
        }
        $DomainCN = ConvertFrom-DistinguishedName -DistinguishedName $Script:RootDSE.defaultNamingContext -ToDomainCN
        $QueryServer = (Get-ADDomainController -DomainName $DomainCN -Discover -ErrorAction Stop @credentialSplat).Hostname[0]
        # Create a hashtable to store the GUID value of each schema class and attribute

        $Script:ADGuidMap = [ordered] @{
            'All' = [System.GUID]'00000000-0000-0000-0000-000000000000'
        }
        $Script:ADGuidMapString = [ordered] @{
            'All' = '00000000-0000-0000-0000-000000000000'
        }
        Write-Verbose "Convert-ADSchemaToGuid - Querying Schema from $QueryServer"
        $Time = [System.Diagnostics.Stopwatch]::StartNew()
        if (-not $Script:StandardRights) {
            $Script:StandardRights = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter "(schemaidguid=*)" -Properties name, lDAPDisplayName, schemaIDGUID -Server $QueryServer -ErrorAction Stop @credentialSplat | Select-Object name, lDAPDisplayName, schemaIDGUID
        }
        foreach ($Guid in $Script:StandardRights) {
            $Script:ADGuidMapString[$Guid.lDAPDisplayName] = ([System.GUID]$Guid.schemaIDGUID).Guid
            $Script:ADGuidMapString[$Guid.Name] = ([System.GUID]$Guid.schemaIDGUID).Guid
            $Script:ADGuidMap[$Guid.lDAPDisplayName] = ([System.GUID]$Guid.schemaIDGUID)
            $Script:ADGuidMap[$Guid.Name] = ([System.GUID]$Guid.schemaIDGUID)
        }
        $Time.Stop()
        $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        Write-Verbose "Convert-ADSchemaToGuid - Querying Schema from $QueryServer took $TimeToExecute"
        Write-Verbose "Convert-ADSchemaToGuid - Querying Extended Rights from $QueryServer"
        $Time = [System.Diagnostics.Stopwatch]::StartNew()
        #Create a hashtable to store the GUID value of each extended right in the forest
        if (-not $Script:ExtendedRightsGuids) {
            $Script:ExtendedRightsGuids = Get-ADObject -SearchBase $Script:RootDSE.ConfigurationNamingContext -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties name, displayName, lDAPDisplayName, rightsGuid -Server $QueryServer -ErrorAction Stop @credentialSplat | Select-Object name, displayName, lDAPDisplayName, rightsGuid
        }
        foreach ($Guid in $Script:ExtendedRightsGuids) {
            $Script:ADGuidMapString[$Guid.Name] = ([System.GUID]$Guid.RightsGuid).Guid
            $Script:ADGuidMapString[$Guid.DisplayName] = ([System.GUID]$Guid.RightsGuid).Guid
            $Script:ADGuidMap[$Guid.Name] = ([System.GUID]$Guid.RightsGuid)
            $Script:ADGuidMap[$Guid.DisplayName] = ([System.GUID]$Guid.RightsGuid)
        }
        $Time.Stop()
        $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        Write-Verbose "Convert-ADSchemaToGuid - Querying Extended Rights from $QueryServer took $TimeToExecute"
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
