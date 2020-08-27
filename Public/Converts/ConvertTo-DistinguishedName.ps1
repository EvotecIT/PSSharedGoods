function ConvertTo-DistinguishedName {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER CanonicalName
    Parameter description

    .PARAMETER ToOU
    Parameter description

    .PARAMETER ToObject
    Parameter description

    .PARAMETER ToDomain
    Parameter description

    .EXAMPLE
    An example

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
                # Assemble the DN by replacing
                $DN = 'DN=' + $CN.Replace('.', ',DC=')
            }
            $DN
        }
    }
}
<#
$CanonicalObjects = @(
    'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
    'ad.evotec.xyz/Production/Accounts/Special/SADM Testing 2'
)
$CanonicalOU = @(
    'ad.evotec.xyz/Production/Groups/Security/NetworkAdministration'
    'ad.evotec.xyz/Production'
)
$CanonicalDomain = @(
    'ad.evotec.pl'
    'ad.evotec.xyz'
    'test.evotec.pl'
)

$CanonicalObjects | ConvertTo-DistinguishedName -ToObject
$CanonicalOU | ConvertTo-DistinguishedName -ToOU
$CanonicalDomain | ConvertTo-DistinguishedName -ToDomain
#>