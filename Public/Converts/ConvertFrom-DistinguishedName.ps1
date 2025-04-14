function ConvertFrom-DistinguishedName {
    <#
    .SYNOPSIS
    Converts a Distinguished Name to CN, OU, Multiple OUs, DC or Container

    .DESCRIPTION
    Converts a Distinguished Name to CN, OU, Multiple OUs, DC or Container

    .PARAMETER DistinguishedName
    Distinguished Name to convert

    .PARAMETER ToOrganizationalUnit
    Converts DistinguishedName to Organizational Unit

    .PARAMETER ToMultipleOrganizationalUnit
    Converts DistinguishedName to Multiple Organizational Units

    .PARAMETER ToDC
    Converts DistinguishedName to DC

    .PARAMETER ToDomainCN
    Converts DistinguishedName to Domain Canonical Name (CN)

    .PARAMETER ToCanonicalName
    Converts DistinguishedName to Canonical Name

    .PARAMETER ToLastName
    Converts DistinguishedName to the last CN or OU part

    .PARAMETER ToContainer
    Converts DistinguishedName to its parent container

    .PARAMETER ToFQDN
    Converts DistinguishedName to Fully Qualified Domain Name (FQDN)
    This will only work for very specific cases, and will not really convert all Distinguished Names to FQDN

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

    .EXAMPLE
    ConvertFrom-DistinguishedName -DistinguishedName 'DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
    ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
    ConvertFrom-DistinguishedName -DistinguishedName 'CN=test,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName

    Output:
    ad.evotec.xyz
    ad.evotec.xyz\Production\Users
    ad.evotec.xyz\Production\Users\test

    .EXAMPLE
    ConvertFrom-DistinguishedName -DistinguishedName 'CN=Users,DC=ad,DC=evotec,DC=xyz' -ToContainer
    ConvertFrom-DistinguishedName -DistinguishedName 'CN=Group Policy Creator Owners,CN=Users,DC=ad,DC=evotec,DC=xyz' -ToContainer
    ConvertFrom-DistinguishedName -DistinguishedName 'CN=Admin,OU=Servers,DC=ad,DC=evotec,DC=xyz' -ToContainer
    ConvertFrom-DistinguishedName -DistinguishedName 'OU=Servers,DC=ad,DC=evotec,DC=xyz' -ToContainer

    Output:
    CN=Users,DC=ad,DC=evotec,DC=xyz
    CN=Users,DC=ad,DC=evotec,DC=xyz
    OU=Servers,DC=ad,DC=evotec,DC=xyz
    OU=Servers,DC=ad,DC=evotec,DC=xyz

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
        [Parameter(ParameterSetName = 'ToFQDN')]
        [Parameter(ParameterSetName = 'ToContainer')]
        [alias('Identity', 'DN')][Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)][string[]] $DistinguishedName,
        [Parameter(ParameterSetName = 'ToOrganizationalUnit')][switch] $ToOrganizationalUnit,
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')][alias('ToMultipleOU')][switch] $ToMultipleOrganizationalUnit,
        [Parameter(ParameterSetName = 'ToMultipleOrganizationalUnit')][switch] $IncludeParent,
        [Parameter(ParameterSetName = 'ToDC')][switch] $ToDC,
        [Parameter(ParameterSetName = 'ToDomainCN')][switch] $ToDomainCN,
        [Parameter(ParameterSetName = 'ToLastName')][switch] $ToLastName,
        [Parameter(ParameterSetName = 'ToCanonicalName')][switch] $ToCanonicalName,
        [Parameter(ParameterSetName = 'ToContainer')][switch] $ToContainer,
        [Parameter(ParameterSetName = 'ToFQDN')][switch] $ToFQDN
    )
    process {
        foreach ($Distinguished in $DistinguishedName) {
            if ($ToDomainCN) {
                $DN = $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                $CN = $DN -replace ',DC=', '.' -replace "DC="
                if ($CN) {
                    $CN
                }
            } elseif ($ToOrganizationalUnit) {
                if ($Distinguished -match '^CN=[^,\\]+(?:\\,[^,\\]+)*,(.+)$') {
                    $matches[1]
                } elseif ($Distinguished -match '^(OU=|CN=)') {
                    $Distinguished
                }
            } elseif ($ToMultipleOrganizationalUnit) {
                $Parts = $Distinguished -split '(?<!\\),'
                $Results = [System.Collections.ArrayList]::new()

                if ($IncludeParent) {
                    $null = $Results.Add($Distinguished)
                }

                for ($i = 1; $i -lt $Parts.Count; $i++) {
                    $CurrentPath = $Parts[$i..($Parts.Count - 1)] -join ','
                    if ($CurrentPath -match '^(OU=|CN=)' -and $CurrentPath -notmatch '^DC=') {
                        $null = $Results.Add($CurrentPath)
                    }
                }
                foreach ($R in $Results) {
                    if ($R -match '^(OU=|CN=)') {
                        $R
                    }
                }
            } elseif ($ToDC) {
                $Value = $Distinguished -replace '.*?((DC=[^=]+,)+DC=[^=]+)$', '$1'
                if ($Value) {
                    $Value
                }
            } elseif ($ToLastName) {
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
            } elseif ($ToContainer) {
                <#
                .SYNOPSIS
                Extracts the parent container from a Distinguished Name.

                .DESCRIPTION
                For objects within containers (like "CN=Object,CN=Container,..."), returns the container part.
                For objects within OU containers (like "CN=Object,OU=Container,..."), returns the OU container.
                For container objects directly under the domain (like "CN=Users,DC=..."), returns the full DN.
                For organizational units (like "OU=Container,DC=..."), returns the OU itself.
                #>
                if ($Distinguished -match '^(?:CN|OU)=[^,\\]+(?:\\,[^,\\]+)*,(((?:CN|OU)=[^,\\]+(?:\\,[^,\\]+)*,)+(?:DC=.+))$') {
                    # This is an object within a container, return the parent container part
                    $matches[1]
                } else {
                    # Either this is already a container directly under domain or another type
                    # Return the original DN
                    $Distinguished
                }
            } elseif ($ToFQDN) {
                if ($Distinguished -match '^CN=(.+?),(?:(?:OU|CN).+,)*((?:DC=.+,?)+)$') {
                    $cnPart = $matches[1] -replace '\\,', ','
                    $dcPart = $matches[2] -replace 'DC=', '' -replace ',', '.'
                    "$cnPart.$dcPart"
                } elseif ($Distinguished -match '^CN=(.+?),((?:DC=.+,?)+)$') {
                    $cnPart = $matches[1] -replace '\\,', ','
                    $dcPart = $matches[2] -replace 'DC=', '' -replace ',', '.'
                    "$cnPart.$dcPart"
                }
            } else {
                $Regex = '^CN=(?<cn>.+?)(?<!\\),(?<ou>(?:(?:OU|CN).+?(?<!\\),)+(?<dc>DC.+?))$'
                $Found = $Distinguished -match $Regex
                if ($Found) {
                    $Matches.cn
                }
            }
        }
    }
}

# ConvertFrom-DistinguishedName -ToFQDN -DistinguishedName "CN=adcs,DC=ad,DC=evotec,DC=xyz"

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