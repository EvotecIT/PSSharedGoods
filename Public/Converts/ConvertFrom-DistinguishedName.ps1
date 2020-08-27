function ConvertFrom-DistinguishedName {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER DistinguishedName
    Parameter description

    .PARAMETER ToOrganizationalUnit
    Parameter description

    .PARAMETER ToDC
    Parameter description

    .PARAMETER ToDomainCN
    Parameter description

    .EXAMPLE
    $DistinguishedName = 'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
    ConvertFrom-DistinguishedName -DistinguishedName $DistinguishedName -ToOrganizationalUnit

    Output:
    OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz

    .EXAMPLE
    $DistinguishedName = 'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
    ConvertFrom-DistinguishedName -DistinguishedName $DistinguishedName

    Output:
    Przemyslaw Klys

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [alias('Identity', 'DN')][Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)][string[]] $DistinguishedName,
        [switch] $ToOrganizationalUnit,
        [switch] $ToDC,
        [switch] $ToDomainCN
    )
    process {
        foreach ($Distinguished in $DistinguishedName) {
            if ($ToDomainCN) {
                $DN = $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                $CN = $DN -replace ',DC=', '.' -replace "DC="
                $CN
            } elseif ($ToOrganizationalUnit) {
                [Regex]::Match($Distinguished, '(?=OU=)(.*\n?)(?<=.)').Value
            } elseif ($ToDC) {
                #return [Regex]::Match($DistinguishedName, '(?=DC=)(.*\n?)(?<=.)').Value
                # return [Regex]::Match($DistinguishedName, '.*?(DC=.*)').Value
                $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                #return [Regex]::Match($DistinguishedName, 'CN=.*?(DC=.*)').Groups[1].Value
            } else {
                $Regex = '^CN=(?<cn>.+?)(?<!\\),(?<ou>(?:(?:OU|CN).+?(?<!\\),)+(?<dc>DC.+?))$'
                $Output = foreach ($_ in $Distinguished) {
                    $_ -match $Regex
                    $Matches
                }
                $Output.cn
            }
        }
    }
}

<#
$DistinguishedName = @(
    'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
    'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
    'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
)
ConvertFrom-DistinguishedName -ToOrganizationalUnit -DistinguishedName $DistinguishedName
#>


<#
$Oops = 'cn={55FB3860-74C9-4262-AD77-30197EAB9999},cn=policies,cn=system,DC=ad,DC=evotec,DC=xyz'
ConvertFrom-DistinguishedName -DistinguishedName $Oops -ToDomainCN | Format-Table -AutoSize

$Con = @(
    'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz'
    'CN=Mmm,DC=elo,CN=nee,DC=RootDNSServers,CN=MicrosoftDNS,CN=System,DC=ad,DC=evotec,DC=xyz'
    'CN=e6d5fd00-385d-4e65-b02d-9da3493ed850,CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz'
    'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl'
    'OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz'
)

foreach ($_ in $Con) {
    ConvertFrom-DistinguishedName -DistinguishedName $_ -ToDC | Format-Table -AutoSize
}

foreach ($_ in $Con) {
    ConvertFrom-DistinguishedName -DistinguishedName $_ -ToOrganizationalUnit | Format-Table -AutoSize
}


return


$Search = '*DC=RootDNSServers*'
$Server = 'ad.evotec.xyz'
$DomainStructure = Get-ADObject -Filter * -Properties canonicalName -SearchScope OneLevel -Server $Server | Sort-Object canonicalName #| Select-Object objectClass, canonicalName, DistinguishedName
$Output = foreach ($Structure in $DomainStructure) {

    Get-ADObject -SearchBase $Structure.DistinguishedName -Filter * -Properties canonicalName -Server $Server -SearchScope Subtree | Sort-Object canonicalName
}
$Output | Where-Object { $_.DistinguishedName -like $Search } | ft -a

#>