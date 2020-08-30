Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force

@(
    Convert-Identity -Identity 'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz'
    Convert-Identity -Identity 'CN=S-1-5-21-1928204107-2710010574-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' -Verbose
) | Format-Table