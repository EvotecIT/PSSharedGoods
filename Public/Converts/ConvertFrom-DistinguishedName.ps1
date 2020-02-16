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
        [string[]] $DistinguishedName,
        [switch] $ToOrganizationalUnit,
        [switch] $ToDC
    )
    if ($ToOrganizationalUnit) {
        return [Regex]::Match($DistinguishedName, '(?=OU=)(.*\n?)(?<=.)').Value
    } elseif ($ToDC) {
        #return [Regex]::Match($DistinguishedName, '(?=DC=)(.*\n?)(?<=.)').Value
        return [Regex]::Match($DistinguishedName, 'CN=.*?(DC=.*)').Groups #[1] #.Value
    } else {
        $Regex = '^CN=(?<cn>.+?)(?<!\\),(?<ou>(?:(?:OU|CN).+?(?<!\\),)+(?<dc>DC.+?))$'
        $Output = foreach ($_ in $DistinguishedName) {
            $_ -match $Regex
            $Matches
        }
        $Output.cn
    }
}
<#
$Con = @(
    'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz'
    'CN=Mmm,DC=elo,CN=nee,DC=RootDNSServers,CN=MicrosoftDNS,CN=System,DC=ad,DC=evotec,DC=xyz'
    'CN=e6d5fd00-385d-4e65-b02d-9da3493ed850,CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz'
    'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl'
)

foreach ($_ in $Con) {
    ConvertFrom-DistinguishedName -DistinguishedName $_ -ToDC | ft -AutoSize
}

foreach ($_ in $Con) {
    ConvertFrom-DistinguishedName -DistinguishedName $_ -ToOrganizationalUnit
}
#>