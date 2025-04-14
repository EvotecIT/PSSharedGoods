Import-Module .\PSSharedGoods.psd1 -Force

#ConvertFrom-DistinguishedName -DistinguishedName 'CN=Users,DC=ad,DC=evotec,DC=xyz' -ToContainer
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=Group Policy Creator Owners,CN=Users,DC=ad,DC=evotec,DC=xyz' -ToContainer
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=Admin,OU=Servers,DC=ad,DC=evotec,DC=xyz' -ToContainer
#ConvertFrom-DistinguishedName -DistinguishedName 'OU=Servers,DC=ad,DC=evotec,DC=xyz' -ToContainer
#ConvertFrom-DistinguishedName -DistinguishedName 'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz' -ToContainer

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

$Place = ConvertFrom-DistinguishedName -ToOrganizationalUnit -DistinguishedName "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
$Place

#ConvertFrom-DistinguishedName -ToMultipleOrganizationalUnit -IncludeParent -DistinguishedName $Place



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