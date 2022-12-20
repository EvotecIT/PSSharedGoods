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
        [string] $Domain,
        [Microsoft.ActiveDirectory.Management.ADEntity] $RootDSE,
        [switch] $DisplayName
    )
    if (-not $Script:ADSchemaMap -or -not $Script:ADSchemaMapDisplayName) {
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

        $Script:ADSchemaMap = @{ }
        $Script:ADSchemaMapDisplayName = @{ }
        $Script:ADSchemaMapDisplayName['00000000-0000-0000-0000-000000000000'] = 'All'
        $Script:ADSchemaMap.Add('00000000-0000-0000-0000-000000000000', 'All')
        Write-Verbose "Convert-ADGuidToSchema - Querying Schema from $QueryServer"
        $Time = [System.Diagnostics.Stopwatch]::StartNew()
        if (-not $Script:StandardRights) {
            $Script:StandardRights = Get-ADObject -SearchBase $Script:RootDSE.schemaNamingContext -LDAPFilter "(schemaidguid=*)" -Properties name, lDAPDisplayName, schemaIDGUID -Server $QueryServer -ErrorAction Stop | Select-Object name, lDAPDisplayName, schemaIDGUID
        }
        foreach ($S in $Script:StandardRights) {
            $Script:ADSchemaMap["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.name
            $Script:ADSchemaMapDisplayName["$(([System.GUID]$S.schemaIDGUID).Guid)"] = $S.lDAPDisplayName
        }
        $Time.Stop()
        $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        Write-Verbose "Convert-ADGuidToSchema - Querying Schema from $QueryServer took $TimeToExecute"
        Write-Verbose "Convert-ADGuidToSchema - Querying Extended Rights from $QueryServer"
        $Time = [System.Diagnostics.Stopwatch]::StartNew()
        #Create a hashtable to store the GUID value of each extended right in the forest
        if (-not $Script:ExtendedRightsGuids) {
            $Script:ExtendedRightsGuids = Get-ADObject -SearchBase $Script:RootDSE.ConfigurationNamingContext -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties name, displayName, lDAPDisplayName, rightsGuid -Server $QueryServer -ErrorAction Stop | Select-Object name, displayName, lDAPDisplayName, rightsGuid
        }
        foreach ($S in $Script:ExtendedRightsGuids) {
            $Script:ADSchemaMap["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.name
            $Script:ADSchemaMapDisplayName["$(([System.GUID]$S.rightsGUID).Guid)"] = $S.displayName
        }
        $Time.Stop()
        $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        Write-Verbose "Convert-ADGuidToSchema - Querying Extended Rights from $QueryServer took $TimeToExecute"
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