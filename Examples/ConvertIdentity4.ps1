Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force

@(
    Convert-Identity -Identity 'CN=Test Test 2,OU=Users,OU=Production,DC=ad,DC=evotec,DC=pl'
    Convert-Identity -Identity 'NT AUTHORITY\INTERACTIVE'
    Convert-Identity -Identity 'INTERACTIVE'
    Convert-Identity -Identity 'EVOTEC\Domain Admins'
    Convert-Identity -Identity 'EVOTECPL\Domain Admins'
    Convert-Identity -Identity 'Test\Domain Admins'
) | Format-Table