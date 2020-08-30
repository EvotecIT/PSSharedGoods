Describe 'Test-IsDistinguishedName' {
    It 'Direct input' {
        Test-IsDistinguishedName -Identity 'CN=Domain Admins,CN=Users,DC=ad,DC=evotec,DC=pl' | Should -Be $true
        Test-IsDistinguishedName -Identity 'CN=Domain Admins,CN=Users,DC=ad,DC=evotec,DC=pl' | Should -Be $true
        Test-IsDistinguishedName -Identity 'ad.evotec.pl' | Should -Be $false
        Test-IsDistinguishedName -Identity 'test.evotec.pl' | Should -Be $false
        Test-IsDistinguishedName -Identity 'NT AUTHORITY\INTERACTIVE' | Should -Be $false
        Test-IsDistinguishedName -Identity 'CN=Domain Admins,CN=Users,DC=ad,DC=evotec,DC=pl' | Should -Be $true

    }
    It 'Pipeline input' {
        'CN=Domain Admins,CN=Users,DC=ad,DC=evotec,DC=pl' | Test-IsDistinguishedName | Should -Be $true
        'CN=Domain Admins,CN=Users,DC=ad,DC=evotec,DC=pl' | Test-IsDistinguishedName | Should -Be $true
        'ad.evotec.pl' | Test-IsDistinguishedName | Should -Be $false
        'test.evotec.pl' | Test-IsDistinguishedName | Should -Be $false
        'NT AUTHORITY\INTERACTIVE' | Test-IsDistinguishedName | Should -Be $false
        'CN=Domain Admins,CN=Users,DC=ad,DC=evotec,DC=pl' | Test-IsDistinguishedName | Should -Be $true
    }
}