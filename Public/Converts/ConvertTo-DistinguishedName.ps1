function ConvertTo-DistinguishedName {
    <#
    .SYNOPSIS
    Converts CanonicalName to DistinguishedName

    .DESCRIPTION
    Converts CanonicalName to DistinguishedName for 3 different options

    .PARAMETER CanonicalName
    One or multiple canonical names

    .PARAMETER ToOU
    Converts CanonicalName to OrganizationalUnit DistinguishedName

    .PARAMETER ToObject
    Converts CanonicalName to Full Object DistinguishedName

    .PARAMETER ToDomain
    Converts CanonicalName to Domain DistinguishedName

    .EXAMPLE

    $CanonicalObjects = @(
    'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
    'ad.evotec.xyz/Production/Accounts/Special/SADM Testing 2'
    )
    $CanonicalOU = @(
        'ad.evotec.xyz/Production/Groups/Security/NetworkAdministration'
        'ad.evotec.xyz/Production'
    )

    $CanonicalDomain = @(
        'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
        'ad.evotec.pl'
        'ad.evotec.xyz'
        'test.evotec.pl'
        'ad.evotec.xyz/Production'
    )
    $CanonicalObjects | ConvertTo-DistinguishedName -ToObject
    $CanonicalOU | ConvertTo-DistinguishedName -ToOU
    $CanonicalDomain | ConvertTo-DistinguishedName -ToDomain

    Output:
    CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz
    CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz
    Output2:
    OU=NetworkAdministration,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz
    OU=Production,DC=ad,DC=evotec,DC=xyz
    Output3:
    DC=ad,DC=evotec,DC=xyz
    DC=ad,DC=evotec,DC=pl
    DC=ad,DC=evotec,DC=xyz
    DC=test,DC=evotec,DC=pl
    DC=ad,DC=evotec,DC=xyz

    .NOTES
    General notes
    #>
    [cmdletBinding(DefaultParameterSetName = 'ToDomain')]
    param(
        [Parameter(ParameterSetName = 'ToOU')]
        [Parameter(ParameterSetName = 'ToObject')]
        [Parameter(ParameterSetName = 'ToDomain')]
        [alias('Identity', 'CN')][Parameter(ValueFromPipeline, Mandatory, ValueFromPipelineByPropertyName, Position = 0)][string[]] $CanonicalName,
        [Parameter(ParameterSetName = 'ToOU')][switch] $ToOU,
        [Parameter(ParameterSetName = 'ToObject')][switch] $ToObject,
        [Parameter(ParameterSetName = 'ToDomain')][switch] $ToDomain
    )
    Process {
        foreach ($CN in $CanonicalName) {
            if ($ToObject) {
                $ADObject = $CN.Replace(',', '\,').Split('/')
                [string]$DN = "CN=" + $ADObject[$ADObject.count - 1]
                for ($i = $ADObject.count - 2; $i -ge 1; $i--) {
                    $DN += ",OU=" + $ADObject[$i]
                }
                $ADObject[0].split(".") | ForEach-Object {
                    $DN += ",DC=" + $_
                }
            } elseif ($ToOU) {
                $ADObject = $CN.Replace(',', '\,').Split('/')
                [string]$DN = "OU=" + $ADObject[$ADObject.count - 1]
                for ($i = $ADObject.count - 2; $i -ge 1; $i--) {
                    $DN += ",OU=" + $ADObject[$i]
                }
                $ADObject[0].split(".") | ForEach-Object {
                    $DN += ",DC=" + $_
                }
            } else {
                $ADObject = $CN.Replace(',', '\,').Split('/')
                # Assemble the DN by replacing
                $DN = 'DC=' + $ADObject[0].Replace('.', ',DC=')
            }
            $DN
        }
    }
}