Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force

$DN = 'CN=Test Test 2,OU=Users,OU=Production,DC=ad,DC=evotec,DC=pl'
Convert-Identity -Identity $DN