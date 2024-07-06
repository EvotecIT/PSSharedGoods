function Get-WinADOrganizationalUnitFromDN {
    <#
    .SYNOPSIS
    This function extracts the Organizational Unit (OU) from a given Distinguished Name (DN).

    .DESCRIPTION
    This function takes a Distinguished Name (DN) as input and returns the Organizational Unit (OU) part of it.

    .PARAMETER DistinguishedName
    Specifies the Distinguished Name (DN) from which to extract the Organizational Unit (OU).

    .EXAMPLE
    Extract the Organizational Unit (OU) from a Distinguished Name.
    
    $DistinguishedName = 'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
    Get-WinADOrganizationalUnitFromDN -DistinguishedName $DistinguishedName

    .NOTES
    This function uses regular expressions to extract the Organizational Unit (OU) from the given Distinguished Name (DN).
    #>
    [CmdletBinding()]
    param(
        $DistinguishedName
    )
    return [Regex]::Match($DistinguishedName,'(?=OU)(.*\n?)(?<=.)').Value
}