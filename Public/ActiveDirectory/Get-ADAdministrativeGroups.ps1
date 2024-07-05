function Get-ADADministrativeGroups {
    <#
    .SYNOPSIS
    Retrieves administrative groups information from Active Directory.

    .DESCRIPTION
    This function retrieves information about administrative groups in Active Directory based on the specified parameters.

    .PARAMETER Type
    Specifies the type of administrative groups to retrieve. Valid values are 'DomainAdmins' and 'EnterpriseAdmins'.

    .PARAMETER Forest
    Specifies the name of the forest to query for administrative groups.

    .PARAMETER ExcludeDomains
    Specifies an array of domains to exclude from the query.

    .PARAMETER IncludeDomains
    Specifies an array of domains to include in the query.

    .PARAMETER ExtendedForestInformation
    Specifies additional information about the forest to include in the query.

    .EXAMPLE
    Get-ADADministrativeGroups -Type DomainAdmins, EnterpriseAdmins

    Output (Where VALUE is Get-ADGroup output):
    Name                           Value
    ----                           -----
    ByNetBIOS                      {EVOTEC\Domain Admins, EVOTEC\Enterprise Admins, EVOTECPL\Domain Admins}
    ad.evotec.xyz                  {DomainAdmins, EnterpriseAdmins}
    ad.evotec.pl                   {DomainAdmins}

    .NOTES
    This function requires Active Directory module to be installed on the system.
    #>
    [cmdletBinding()]
    param(
        [parameter(Mandatory)][validateSet('DomainAdmins', 'EnterpriseAdmins')][string[]] $Type,
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [System.Collections.IDictionary] $ExtendedForestInformation
    )
    $ADDictionary = [ordered] @{ }
    $ADDictionary['ByNetBIOS'] = [ordered] @{ }
    $ADDictionary['BySID'] = [ordered] @{ }

    $ForestInformation = Get-WinADForestDetails -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExtendedForestInformation $ExtendedForestInformation
    foreach ($Domain in $ForestInformation.Domains) {
        $ADDictionary[$Domain] = [ordered] @{ }
        $QueryServer = $ForestInformation['QueryServers'][$Domain]['HostName'][0]
        $DomainInformation = Get-ADDomain -Server $QueryServer

        if ($Type -contains 'DomainAdmins') {
            Get-ADGroup -Filter "SID -eq '$($DomainInformation.DomainSID)-512'" -Server $QueryServer -ErrorAction SilentlyContinue | ForEach-Object {
                $ADDictionary['ByNetBIOS']["$($DomainInformation.NetBIOSName)\$($_.Name)"] = $_
                $ADDictionary[$Domain]['DomainAdmins'] = "$($DomainInformation.NetBIOSName)\$($_.Name)"
                $ADDictionary['BySID'][$_.SID.Value] = $_
            }
        }
    }
    # We need to treat EnterpriseAdmins separatly as it should be always available, not only when requested specific domain
    foreach ($Domain in $ForestInformation.Forest.Domains) {
        if (-not $ADDictionary[$Domain]) {
            $ADDictionary[$Domain] = [ordered] @{ }
        }
        if ($Type -contains 'EnterpriseAdmins') {
            $QueryServer = $ForestInformation['QueryServers'][$Domain]['HostName'][0]
            $DomainInformation = Get-ADDomain -Server $QueryServer

            Get-ADGroup -Filter "SID -eq '$($DomainInformation.DomainSID)-519'" -Server $QueryServer -ErrorAction SilentlyContinue | ForEach-Object {
                $ADDictionary['ByNetBIOS']["$($DomainInformation.NetBIOSName)\$($_.Name)"] = $_
                $ADDictionary[$Domain]['EnterpriseAdmins'] = "$($DomainInformation.NetBIOSName)\$($_.Name)"
                $ADDictionary['BySID'][$_.SID.Value] = $_ #"$($DomainInformation.NetBIOSName)\$($_.Name)"
            }
        }
    }
    return $ADDictionary
}

#Get-WinADForestDetails -IncludeDomains 'ad.evotec.xyz'
#Get-ADADministrativeGroups -Type DomainAdmins, EnterpriseAdmins -IncludeDomains 'ad.evotec.pl'