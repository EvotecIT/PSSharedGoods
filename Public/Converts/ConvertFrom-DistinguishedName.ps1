function ConvertFrom-DistinguishedName {
    <#
    .SYNOPSIS
    Converts a Distinguished Name to CN, OU, Multiple OUs or DC

    .DESCRIPTION
    Converts a Distinguished Name to CN, OU, Multiple OUs or DC

    .PARAMETER DistinguishedName
    Distinguished Name to convert

    .PARAMETER ToOrganizationalUnit
    Converts DistinguishedName to Organizational Unit

    .PARAMETER ToDC
    Converts DistinguishedName to DC

    .PARAMETER ToDomainCN
    Converts DistinguishedName to Domain CN

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

    .EXAMPLE
    ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToMultipleOrganizationalUnit -IncludeParent

    Output:
    OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz
    OU=Production,DC=ad,DC=evotec,DC=xyz

    .EXAMPLE
    ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToMultipleOrganizationalUnit

    Output:
    OU=Production,DC=ad,DC=evotec,DC=xyz

    .NOTES
    General notes
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(ParameterSetName = 'ToOrganizationalUnit')]
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')]
        [Parameter(ParameterSetName = 'ToDC')]
        [Parameter(ParameterSetName = 'ToDomainCN')]
        [Parameter(ParameterSetName = 'Default')]
        [alias('Identity', 'DN')][Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)][string[]] $DistinguishedName,
        [Parameter(ParameterSetName = 'ToOrganizationalUnit')][switch] $ToOrganizationalUnit,
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')][alias('ToMultipleOU')][switch] $ToMultipleOrganizationalUnit,
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')][switch] $IncludeParent,
        [Parameter(ParameterSetName = 'ToDC')][switch] $ToDC,
        [Parameter(ParameterSetName = 'ToDomainCN')][switch] $ToDomainCN
    )
    Process {
        foreach ($Distinguished in $DistinguishedName) {
            if ($ToDomainCN) {
                $DN = $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                $CN = $DN -replace ',DC=', '.' -replace "DC="
                if ($CN) {
                    $CN
                }
            } elseif ($ToOrganizationalUnit) {
                $Value = [Regex]::Match($Distinguished, '(?=OU=)(.*\n?)(?<=.)').Value
                if ($Value) {
                    $Value
                }
            } elseif ($ToMultipleOrganizationalUnit) {
                if ($IncludeParent) {
                    $Distinguished
                }
                while ($true) {
                    #$dn = $dn -replace '^.+?,(?=CN|OU|DC)'
                    $Distinguished = $Distinguished -replace '^.+?,(?=..=)'
                    if ($Distinguished -match '^DC=') {
                        break
                    }
                    $Distinguished
                }
            } elseif ($ToDC) {
                #return [Regex]::Match($DistinguishedName, '(?=DC=)(.*\n?)(?<=.)').Value
                # return [Regex]::Match($DistinguishedName, '.*?(DC=.*)').Value
                $Value = $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                if ($Value) {
                    $Value
                }
                #return [Regex]::Match($DistinguishedName, 'CN=.*?(DC=.*)').Groups[1].Value
            } else {
                $Regex = '^CN=(?<cn>.+?)(?<!\\),(?<ou>(?:(?:OU|CN).+?(?<!\\),)+(?<dc>DC.+?))$'
                #$Output = foreach ($_ in $Distinguished) {
                $Found = $Distinguished -match $Regex
                if ($Found) {
                    $Matches.cn
                }
                #}
                #$Output.cn
            }
        }
    }
}

#ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToMultipleOrganizationalUnit -IncludeParent
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=test,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'

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