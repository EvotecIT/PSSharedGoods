function Get-WinADOrganizationalUnitFromDN {
    <#
    .SYNOPSIS


    .DESCRIPTION
    Long description

    .PARAMETER DistinguishedName
    Parameter description

    .EXAMPLE
    An example

    $DistinguishedName = 'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
    Get-WinADOrganizationalUnitFromDN -DistinguishedName $DistinguishedName

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        $DistinguishedName
    )
    return [Regex]::Match($DistinguishedName,'(?=OU)(.*\n?)(?<=.)').Value
}