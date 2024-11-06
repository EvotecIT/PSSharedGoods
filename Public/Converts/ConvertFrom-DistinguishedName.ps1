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
    Converts DistinguishedName to Domain Canonical Name (CN)

    .PARAMETER ToCanonicalName
    Converts DistinguishedName to Canonical Name

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

    .EXAMPLE
    $Con = @(
        'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz'
        'CN=Mmm,DC=elo,CN=nee,DC=RootDNSServers,CN=MicrosoftDNS,CN=System,DC=ad,DC=evotec,DC=xyz'
        'CN=e6d5fd00-385d-4e65-b02d-9da3493ed850,CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz'
        'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl'
        'OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz'
    )

    ConvertFrom-DistinguishedName -DistinguishedName $Con -ToLastName

    Output:
    Windows Authorization Access Group
    Mmm
    e6d5fd00-385d-4e65-b02d-9da3493ed850
    Domain Controllers
    Microsoft Exchange Security Groups

    .EXAMPLEE
    ConvertFrom-DistinguishedName -DistinguishedName 'DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
    ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
    ConvertFrom-DistinguishedName -DistinguishedName 'CN=test,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName

    Output:
    ad.evotec.xyz
    ad.evotec.xyz\Production\Users
    ad.evotec.xyz\Production\Users\test

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
        [Parameter(ParameterSetName = 'ToLastName')]
        [Parameter(ParameterSetName = 'ToCanonicalName')]
        [alias('Identity', 'DN')][Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)][string[]] $DistinguishedName,
        [Parameter(ParameterSetName = 'ToOrganizationalUnit')][switch] $ToOrganizationalUnit,
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')][alias('ToMultipleOU')][switch] $ToMultipleOrganizationalUnit,
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')][switch] $IncludeParent,
        [Parameter(ParameterSetName = 'ToDC')][switch] $ToDC,
        [Parameter(ParameterSetName = 'ToDomainCN')][switch] $ToDomainCN,
        [Parameter(ParameterSetName = 'ToLastName')][switch] $ToLastName,
        [Parameter(ParameterSetName = 'ToCanonicalName')][switch] $ToCanonicalName
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
                # $Value = [Regex]::Match($Distinguished, '(?=OU=)(.*\n?)(?<=.)').Value
                # if ($Value) {
                #     $Value
                # }

                # Match everything after first CN= until the end, excluding the first CN if it exists
                # $Value = $UseMe -replace '^CN=[^,]+,', ''
                # if ($Value -match '^(CN=.*|OU=.*)') {
                #     $Value
                # }

                if ($Distinguished -match '^CN=[^,\\]+(?:\\,[^,\\]+)*,(.+)$') {
                    # $matches[1] contains everything after first CN= including escaped chars
                    $matches[1]
                } elseif ($Distinguished -match '^(OU=|CN=)') {
                    # Return full string if it starts with OU= or doesn't have leading CN=
                    $Distinguished
                }
            } elseif ($ToMultipleOrganizationalUnit) {
                # if ($IncludeParent) {
                #     $Distinguished
                # }
                # while ($true) {
                #     #$dn = $dn -replace '^.+?,(?=CN|OU|DC)'
                #     $Distinguished = $Distinguished -replace '^.+?,(?=..=)'
                #     if ($Distinguished -match '^DC=') {
                #         break
                #     }
                #     $Distinguished
                # }

                $Parts = $Distinguished -split '(?<!\\),'
                $Results = [System.Collections.ArrayList]::new()

                # Start with full path if IncludeParent is specified
                if ($IncludeParent) {
                    $null = $Results.Add($Distinguished)
                }

                # Build paths from right to left, excluding DC parts
                for ($i = 1; $i -lt $Parts.Count; $i++) {
                    $CurrentPath = $Parts[$i..($Parts.Count - 1)] -join ','
                    if ($CurrentPath -match '^(OU=|CN=)' -and $CurrentPath -notmatch '^DC=') {
                        $null = $Results.Add($CurrentPath)
                    }
                }
                # Return results
                foreach ($R in $Results) {
                    if ($R -match '^(OU=|CN=)') {
                        $R
                    }
                }
            } elseif ($ToDC) {
                #return [Regex]::Match($DistinguishedName, '(?=DC=)(.*\n?)(?<=.)').Value
                # return [Regex]::Match($DistinguishedName, '.*?(DC=.*)').Value
                $Value = $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                if ($Value) {
                    $Value
                }
                #return [Regex]::Match($DistinguishedName, 'CN=.*?(DC=.*)').Groups[1].Value
            } elseif ($ToLastName) {
                # Would be best if it worked, but there is too many edge cases so hand splits seems to be the best solution
                # Feel free to change it back to regex if you know how ;)
                <# https://stackoverflow.com/questions/51761894/regex-extract-ou-from-distinguished-name
                $Regex = "^(?:(?<cn>CN=(?<name>.*?)),)?(?<parent>(?:(?<path>(?:CN|OU).*?),)?(?<domain>(?:DC=.*)+))$"
                $Found = $Distinguished -match $Regex
                if ($Found) {
                    $Matches.name
                }
                #>
                $NewDN = $Distinguished -split ",DC="
                if ($NewDN[0].Contains(",OU=")) {
                    [Array] $ChangedDN = $NewDN[0] -split ",OU="
                } elseif ($NewDN[0].Contains(",CN=")) {
                    [Array] $ChangedDN = $NewDN[0] -split ",CN="
                } else {
                    [Array] $ChangedDN = $NewDN[0]
                }
                if ($ChangedDN[0].StartsWith('CN=')) {
                    $ChangedDN[0] -replace 'CN=', ''
                } else {
                    $ChangedDN[0] -replace 'OU=', ''
                }
            } elseif ($ToCanonicalName) {
                $Domain = $null
                $Rest = $null
                foreach ($O in $Distinguished -split '(?<!\\),') {
                    if ($O -match '^DC=') {
                        $Domain += $O.Substring(3) + '.'
                    } else {
                        $Rest = $O.Substring(3) + '\' + $Rest
                    }
                }
                if ($Domain -and $Rest) {
                    $Domain.Trim('.') + '\' + ($Rest.TrimEnd('\') -replace '\\,', ',')
                } elseif ($Domain) {
                    $Domain.Trim('.')
                } elseif ($Rest) {
                    $Rest.TrimEnd('\') -replace '\\,', ','
                }
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

# $OU = @(
#     'CN=Certificate Service DCOM Access,CN=Builtin,DC=ad,DC=evotec,DC=pl'
#     'CN=Builtin,DC=ad,DC=evotec,DC=pl'
#     'CN=Test My\, User,OU=US,OU=ITR01,DC=ad,DC=evotec,DC=xyz'
#     'CN=Weird Name\, with $\,.,OU=SE2,OU=SE,OU=ITR01,DC=ad,DC=evotec,DC=xyz'
#     'CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl'
# )

# ConvertFrom-DistinguishedName -DistinguishedName $OU -ToOrganizationalUnit

# ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl"
# ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl" -ToOrganizationalUnit
# ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl" -ToDC
# ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl" -ToDomainCN
# ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl" -ToCanonicalName
# ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl" -ToMultipleOrganizationalUnit -IncludeParent

#ConvertFrom-DistinguishedName -DistinguishedName "CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl" -ToMultipleOrganizationalUnit -IncludeParent
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=Weird Name\, with $\,.,OU=SE2,OU=SE,OU=ITR01,DC=ad,DC=evotec,DC=xyz' -ToMultipleOrganizationalUnit -IncludeParent

#ConvertFrom-DistinguishedName -DistinguishedName 'DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
#ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=test,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName


#ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToMultipleOrganizationalUnit -IncludeParent
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=test,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'


# $DistinguishedName = @(
#     'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
#     'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
#     'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
# )
# ConvertFrom-DistinguishedName -ToOrganizationalUnit -DistinguishedName $DistinguishedName


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