function Get-WinADDSAGuid {
    <#
    .SYNOPSIS
    Get DSA GUIDs from a forest for all domain controllers

    .DESCRIPTION
    This function retrieves DSA GUIDs from a forest for all domain controllers

    .PARAMETER Forest
    Target different Forest, by default current forest is used

    .PARAMETER ExcludeDomains
    Exclude domain from search, by default whole forest is scanned

    .PARAMETER IncludeDomains
    Include only specific domains, by default whole forest is scanned

    .PARAMETER ExcludeDomainControllers
    Exclude specific domain controllers, by default there are no exclusions, as long as VerifyDomainControllers switch is enabled. Otherwise this parameter is ignored.

    .PARAMETER IncludeDomainControllers
    Include only specific domain controllers, by default all domain controllers are included, as long as VerifyDomainControllers switch is enabled. Otherwise this parameter is ignored.

    .PARAMETER SkipRODC
    Skip Read-Only Domain Controllers. By default all domain controllers are included.

    .PARAMETER ExtendedForestInformation
    Ability to provide Forest Information from another command to speed up processing

    .EXAMPLE
    Get-WinADDSAGuid | Format-Table

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [alias('DomainControllers', 'ComputerName')][string[]] $IncludeDomainControllers,
        [switch] $SkipRODC,
        [System.Collections.IDictionary] $ExtendedForestInformation,
        [pscredential] $Credential
    )
    $Forest = Get-WinADForestDetails -Forest $Forest -ExtendedForestInformation $ExtendedForestInformation -ExcludeDomains $ExcludeDomains -ExcludeDomainControllers $ExcludeDomainControllers -IncludeDomains $IncludeDomains -IncludeDomainControllers $IncludeDomainControllers -SkipRODC:$SkipRODC -Credential $Credential
    $ListDSA = [ordered]@{}
    foreach ($DC in $Forest.ForestDomainControllers) {
        $ListDSA[$DC.DsaGuid] = [PSCustomObject] @{
            Domain      = $DC.Domain
            HostName    = $DC.HostName
            DsaGuid     = $DC.DsaGuid
            DsaGuidName = $DC.DsaGuidName
        }
    }
    if ($Hashtable) {
        $ListDSA
    } else {
        $ListDSA.Values | ForEach-Object { $_ }
    }
}
