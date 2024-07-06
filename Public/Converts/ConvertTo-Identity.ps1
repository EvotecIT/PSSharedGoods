function ConvertTo-Identity {
    <#
    .SYNOPSIS
    Converts an identity to its corresponding information.

    .DESCRIPTION
    This function converts an identity to its corresponding information, such as Name, SID, Type, and Class. It retrieves information from Active Directory based on the provided identity.

    .PARAMETER Identity
    Specifies the identity to convert.

    .PARAMETER ADAdministrativeGroups
    Specifies the Active Directory administrative groups.

    .PARAMETER Forest
    Specifies the forest name.

    .PARAMETER ExcludeDomains
    Specifies the domains to exclude.

    .PARAMETER IncludeDomains
    Specifies the domains to include.

    .PARAMETER ExtendedForestInformation
    Specifies additional information about the forest.

    .EXAMPLE
    ConvertTo-Identity -Identity "JohnDoe" -Forest "example.com" -IncludeDomains "domain1", "domain2" -ExcludeDomains "domain3" -ADAdministrativeGroups $ADGroups -ExtendedForestInformation $ExtendedInfo
    Converts the identity "JohnDoe" in the forest "example.com", including domains "domain1" and "domain2" while excluding "domain3", using the specified administrative groups and extended forest information.

    .NOTES
    File Name      : ConvertTo-Identity.ps1
    Prerequisite   : This function requires Active Directory PowerShell module.
    #>
    [cmdletBinding()]
    param(
        [string] $Identity,
        [System.Collections.IDictionary] $ADAdministrativeGroups,

        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [System.Collections.IDictionary] $ExtendedForestInformation
    )
    Begin {
        if (-not $ExtendedForestInformation) {
            $ForestInformation = Get-WinADForestDetails -Extended -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExtendedForestInformation $ExtendedForestInformation
        } else {
            $ForestInformation = $ExtendedForestInformation
        }
        if (-not $ADAdministrativeGroups) {
            $ADAdministrativeGroups = Get-ADADministrativeGroups -Type DomainAdmins, EnterpriseAdmins -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExtendedForestInformation $ExtendedForestInformation
        }
        if (-not $Script:GlobalCacheIdentity) {
            $Script:GlobalCacheIdentity = @{ }
        }
    }
    Process {
        $AdministrativeGroup = $ADAdministrativeGroups['ByNetBIOS']["$($Identity)"]
        if ($AdministrativeGroup) {
            [PSCustomObject] @{
                Name  = $Identity
                SID   = $AdministrativeGroup.SID.Value
                Type  = 'Administrative'
                Class = $AdministrativeGroup.ObjectClass
                Error = ''
            }
        } else {
            if ($Identity -like '*@*') {
                Write-Warning "ConvertTo-Identity - Not implemented."
                #if ($Script:GlobalCacheIdentity[$Identity]) {
                #    $Script:GlobalCacheIdentity[$Identity]
                # } else {
                #
                #    $ADObject = Get-ADObject -Filter "SamAccountName -eq '$($MyIdentity[1])'" -Server $QueryServer -Properties AdminCount, CanonicalName, Name, sAMAccountName, DisplayName, DistinguishedName, ObjectClass, objectSid
                #}
            } elseif ($Identity -like '*\*') {
                if ($Script:GlobalCacheIdentity[$Identity]) {
                    $Script:GlobalCacheIdentity[$Identity]
                } else {
                    $MyIdentity = $Identity.Split("\")
                    $DNSRoot = $ForestInformation['DomainsExtendedNetBIOS'][$($MyIdentity[0])]['DNSRoot']
                    $QueryServer = $ForestInformation['QueryServers'][$DNSRoot]['HostName'][0]
                    $ADObject = Get-ADObject -Filter "SamAccountName -eq '$($MyIdentity[1])'" -Server $QueryServer -Properties AdminCount, CanonicalName, Name, sAMAccountName, DisplayName, DistinguishedName, ObjectClass, objectSid
                    <#
                    AdminCount        : 1
                    CanonicalName     : ad.evotec.xyz/Production/Users/Przemysław Kłys
                    DisplayName       : Przemysław Kłys
                    DistinguishedName : CN=Przemysław Kłys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz
                    Name              : Przemysław Kłys
                    ObjectClass       : user
                    ObjectGUID        : b328932a-857f-4af1-b9d0-35578aa20d22
                    objectSid         : S-1-5-21-853615985-2870445339-3163598659-1105
                    sAMAccountName    : przemyslaw.klys
                    #>

                    if ($ADObject) {
                        $Script:GlobalCacheIdentity[$Identity] = [PSCustomObject] @{
                            Name  = $Identity
                            SID   = $ADObject.objectSid.Value
                            Type  = 'NotAdministrative'
                            Class = $AdObject.ObjectClass
                            Error = ''
                        }
                        $Script:GlobalCacheIdentity[$Identity]
                    } else {
                        [PSCustomObject] @{
                            Name  = $Identity
                            SID   = $Identity
                            Type  = 'Unknown'
                            Class = 'unknown'
                            Error = 'Object not found.'
                        }
                    }
                }
                #
            } elseif ($Identity -like '*-*-*-*') {
                $Data = ConvertFrom-SID -sid $Identity
                if ($Data) {
                    if ($Data.Error) {
                        [PSCustomObject] @{
                            Name  = $Data.Name
                            SID   = $Data.Sid
                            Type  = $Data.Type
                            Class = 'unknown'
                            Error = $Data.Error
                        }
                    } else {
                        # If it's not an error we still need to check whether translated SID is administrative or not
                        $AdministrativeGroup = $ADAdministrativeGroups['ByNetBIOS']["$($Data.Name)"]
                        if ($AdministrativeGroup) {
                            [PSCustomObject] @{
                                Name  = $Data.Name
                                SID   = $AdministrativeGroup.SID.Value
                                Type  = 'Administrative'
                                Class = $AdministrativeGroup.ObjectClass
                                Error = ''
                            }
                        } else {
                            [PSCustomObject] @{
                                Name  = $Data.Name
                                SID   = $Data.Sid
                                Type  = $Data.Type
                                Class = ''
                                Error = $Data.Error
                            }
                        }
                    }
                } else {
                    [PSCustomObject] @{
                        Name  = $Identity
                        SID   = $Identity
                        Type  = 'Unknown'
                        Class = 'unknown'
                        Error = 'SID not found'
                    }
                }
                <#
                Name  SID   Error                                                                                          Type
                ----  ---   -----                                                                                          ----
                1-2-3 1-2-3 Exception calling ".ctor" with "1" argument(s): "Value was invalid....                         Unknown
                #>
            } else {
                [PSCustomObject] @{
                    Name  = $Identity
                    SID   = $Identity
                    Type  = 'Unknown'
                    Class = 'unknown'
                    Error = 'Identity unknown'
                }
            }
        }
    }
    End {

    }
}