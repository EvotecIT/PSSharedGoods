Describe -Name 'Testing ConvertFrom-DistinguishedName' {
    It 'ToOrganizationalUnit Conversion' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=Test My\, User,OU=US,OU=ITR01,DC=ad,DC=evotec,DC=xyz'
            'CN=Weird Name\, with $\,.,OU=SE2,OU=SE,OU=ITR01,DC=ad,DC=evotec,DC=xyz'
            'CN=Administrator,CN=Users,DC=ad,DC=evotec,DC=pl'
            'CN=Builtin,DC=ad,DC=evotec,DC=pl'
            'CN=Certificate Service DCOM Access,CN=Builtin,DC=ad,DC=evotec,DC=pl'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = ConvertFrom-DistinguishedName -ToOrganizationalUnit -DistinguishedName $DistinguishedName
        $Output | Should -Be @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=US,OU=ITR01,DC=ad,DC=evotec,DC=xyz'
            'OU=SE2,OU=SE,OU=ITR01,DC=ad,DC=evotec,DC=xyz'
            'CN=Users,DC=ad,DC=evotec,DC=pl'
            'DC=ad,DC=evotec,DC=pl'
            'CN=Builtin,DC=ad,DC=evotec,DC=pl'
            "OU=FourServers,DC=FourAnyway,DC=com"
        )
    }
    It 'ToOrganizationalUnit Conversion - Pipeline' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToOrganizationalUnit
        $Output | Should -Be @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "OU=FourServers,DC=FourAnyway,DC=com"
        )
    }
    It 'ToDC Conversion' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = ConvertFrom-DistinguishedName -ToDC -DistinguishedName $DistinguishedName
        $Output | Should -Be @(
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=FourAnyway,DC=com'
        )
    }
    It 'ToDC Conversion - Pipeline' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToDC
        $Output | Should -Be @(
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=FourAnyway,DC=com'
        )
    }
    It 'ToDomainCN Conversion' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = ConvertFrom-DistinguishedName -ToDomainCN -DistinguishedName $DistinguishedName
        $Output | Should -Be @(
            'ad.evotec.xyz'
            'ad.evotec.xyz'
            'ad.evotec.xyz'
            'FourAnyway.com'
        )
    }
    It 'ToDomainCN Conversion - Pipeline' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToDomainCN
        $Output | Should -Be @(
            'ad.evotec.xyz'
            'ad.evotec.xyz'
            'ad.evotec.xyz'
        )
    }
    It 'ToMultipleOU Conversion - Pipeline' {
        $DistinguishedName = @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToMultipleOrganizationalUnit
        $Output | Should -Be @(
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=FourServers,DC=FourAnyway,DC=com'
        )
    }
    It 'ToMultipleOU Conversion with Parent - Pipeline' {
        $DistinguishedName = @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            "CN=Four-PRINT-CLAY-SHIP-0004,CN=Four-PRINT,OU=FourServers,DC=FourAnyway,DC=com"
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToMultipleOrganizationalUnit -IncludeParent
        $Output | Should -Be @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
            "OU=FourServers,DC=FourAnyway,DC=com"
        )
    }
    It 'ToLastName Conversion' {
        $DistinguishedName = @(
            'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz'
            'CN=Mmm,DC=elo,CN=nee,DC=RootDNSServers,CN=MicrosoftDNS,CN=System,DC=ad,DC=evotec,DC=xyz'
            'CN=e6d5fd00-385d-4e65-b02d-9da3493ed850,CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz'
            'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl'
            'OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz'
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )

        $Output = ConvertFrom-DistinguishedName -DistinguishedName $DistinguishedName -ToLastName
        $Output | Should -Be @(
            'Windows Authorization Access Group'
            'Mmm'
            'e6d5fd00-385d-4e65-b02d-9da3493ed850'
            'Domain Controllers'
            'Microsoft Exchange Security Groups'
            'Przemyslaw Klys'
            'ITR03_AD Admins'
            'SADM Testing 2'
        )
    }
    It 'ToLastName Conversion -Pipeline' {
        $DistinguishedName = @(
            'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz'
            'CN=Mmm,DC=elo,CN=nee,DC=RootDNSServers,CN=MicrosoftDNS,CN=System,DC=ad,DC=evotec,DC=xyz'
            'CN=e6d5fd00-385d-4e65-b02d-9da3493ed850,CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz'
            'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl'
            'OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz'
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )

        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToLastName
        $Output | Should -Be @(
            'Windows Authorization Access Group'
            'Mmm'
            'e6d5fd00-385d-4e65-b02d-9da3493ed850'
            'Domain Controllers'
            'Microsoft Exchange Security Groups'
            'Przemyslaw Klys'
            'ITR03_AD Admins'
            'SADM Testing 2'
        )
    }

    It 'ToContainer Conversion' {
        $DistinguishedName = @(
            'CN=Users,DC=ad,DC=evotec,DC=xyz'
            'CN=Group Policy Creator Owners,CN=Users,DC=ad,DC=evotec,DC=xyz'
            'CN=Admin,OU=Servers,DC=ad,DC=evotec,DC=xyz'
            'OU=Servers,DC=ad,DC=evotec,DC=xyz'
            'CN=Windows Authorization Access Group,CN=Builtin,DC=ad,DC=evotec,DC=xyz'
            'CN=e6d5fd00-385d-4e65-b02d-9da3493ed850,CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz'
            'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl'
            'OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz'
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )

        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToContainer
        $Output | Should -Be @(
            'CN=Users,DC=ad,DC=evotec,DC=xyz',
            'CN=Users,DC=ad,DC=evotec,DC=xyz',
            'OU=Servers,DC=ad,DC=evotec,DC=xyz',
            'OU=Servers,DC=ad,DC=evotec,DC=xyz',
            'CN=Builtin,DC=ad,DC=evotec,DC=xyz',
            'CN=Operations,CN=DomainUpdates,CN=System,DC=ad,DC=evotec,DC=xyz',
            'OU=Domain Controllers,DC=ad,DC=evotec,DC=pl',
            'OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz',
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz',
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
}