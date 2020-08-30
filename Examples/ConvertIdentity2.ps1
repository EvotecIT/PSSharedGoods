
Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force

@(
    $DN = 'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz'
    Convert-Identity -Identity $DN
    $DN = 'CN=Test Test 2,OU=Users,OU=Production,DC=ad,DC=evotec,DC=pl'
    Convert-Identity -Identity $DN
    $Group = Get-ADGroup -Identity 'Test Local Group'
    Convert-Identity -Identity $Group.SID.Value
) | Format-Table