Describe -Name 'Testing ConvertTo-DistinguishedName' {
    It 'ToObject Conversion - Pipeline' {
        $CanonicalObjects = @(
            'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
            'ad.evotec.xyz/Production/Accounts/Special/SADM Testing 2'
        )
        $Output = $CanonicalObjects | ConvertTo-DistinguishedName -ToObject
        $Output | Should -be @(
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToObject Conversion' {
        $CanonicalObjects = @(
            'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
            'ad.evotec.xyz/Production/Accounts/Special/SADM Testing 2'
        )
        $Output = ConvertTo-DistinguishedName -ToObject -CanonicalName $CanonicalObjects
        $Output | Should -be @(
            'CN=ITR03_AD Admins,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'CN=SADM Testing 2,OU=Special,OU=Accounts,OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToOU Conversion - Pipeline' {
        $CanonicalOU = @(
            'ad.evotec.xyz/Production/Groups/Security/NetworkAdministration'
            'ad.evotec.xyz/Production'
        )
        $Output = $CanonicalOU | ConvertTo-DistinguishedName -ToOU
        $Output | Should -be @(
            'OU=NetworkAdministration,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToOU Conversion' {
        $CanonicalOU = @(
            'ad.evotec.xyz/Production/Groups/Security/NetworkAdministration'
            'ad.evotec.xyz/Production'
        )
        $Output = ConvertTo-DistinguishedName -ToOU -CanonicalName $CanonicalOU
        $Output | Should -be @(
            'OU=NetworkAdministration,OU=Security,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
            'OU=Production,DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToDomain Conversion' {
        $CanonicalDomain = @(
            'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
            'ad.evotec.pl'
            'ad.evotec.xyz'
            'test.evotec.pl'
            'ad.evotec.xyz/Production'
        )
        $Output = $CanonicalDomain | ConvertTo-DistinguishedName -ToDomain
        $Output | Should -be @(
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=pl'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=test,DC=evotec,DC=pl'
            'DC=ad,DC=evotec,DC=xyz'
        )
    }
    It 'ToDomain Conversion' {
        $CanonicalDomain = @(
            'ad.evotec.xyz/Production/Groups/Security/ITR03_AD Admins'
            'ad.evotec.pl'
            'ad.evotec.xyz'
            'test.evotec.pl'
            'ad.evotec.xyz/Production'
        )
        $Output = ConvertTo-DistinguishedName -ToDomain -CanonicalName $CanonicalDomain
        $Output | Should -be @(
            'DC=ad,DC=evotec,DC=xyz'
            'DC=ad,DC=evotec,DC=pl'
            'DC=ad,DC=evotec,DC=xyz'
            'DC=test,DC=evotec,DC=pl'
            'DC=ad,DC=evotec,DC=xyz'
        )
    }
}