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
        [switch] $ToOrganizationalUnit
    )
    if ($ToOrganizationalUnit) {
        return [Regex]::Match($DistinguishedName, '(?=OU)(.*\n?)(?<=.)').Value
    } else {
        $Regex = '^CN=(?<cn>.+?)(?<!\\),(?<ou>(?:(?:OU|CN).+?(?<!\\),)+(?<dc>DC.+?))$'
        $Output = foreach ($_ in $DistinguishedName) {
            $_ -match $Regex
            $Matches
        }
        $Output.cn
    }
}