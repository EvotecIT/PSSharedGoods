Describe -Name 'Testing ConvertFrom-DistinguishedName' {
    It 'ToOrganizationalUnit Conversion' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = ConvertFrom-DistinguishedName -ToOrganizationalUnit -DistinguishedName $DistinguishedName
        $Output | Should -be @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToOrganizationalUnit Conversion - Pipeline' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToOrganizationalUnit
        $Output | Should -be @(
            'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToDC Conversion' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = ConvertFrom-DistinguishedName -ToDC -DistinguishedName $DistinguishedName
        $Output | Should -be @(
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToDC Conversion - Pipeline' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToDC
        $Output | Should -be @(
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToDomainCN Conversion' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = ConvertFrom-DistinguishedName -ToDomainCN -DistinguishedName $DistinguishedName
        $Output | Should -be @(
            'ad.evotec.xyz'
            'ad.evotec.xyz'
            'ad.evotec.xyz'
        )
    }
    It 'ToDomainCN Conversion - Pipeline' {
        $DistinguishedName = @(
            'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
        $Output = $DistinguishedName | ConvertFrom-DistinguishedName -ToDomainCN
        $Output | Should -be @(
            'ad.evotec.xyz'
            'ad.evotec.xyz'
            'ad.evotec.xyz'
        )
    }
}