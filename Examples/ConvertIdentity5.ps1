Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force

$Identity = @(
    'S-1-5-4'
    'S-1-5-4'
    'S-1-5-11'
    'S-1-5-32-549'
    'S-1-5-32-550'
    'S-1-5-32-548'
    'S-1-5-64-10'
    'S-1-5-64-14'
    'S-1-5-64-21'
    'S-1-5-18'
    'S-1-5-19'
    'S-1-5-32-544'
    'S-1-5-20-20-10-51' # Wrong SID
    'S-1-5-21-853615985-2870445339-3163598659-512'
    'S-1-5-21-3661168273-3802070955-2987026695-512'
    'S-1-5-21-1928204107-2710010574-1926425344-512'
    'CN=Test Test 2,OU=Users,OU=Production,DC=ad,DC=evotec,DC=pl'
    'Test Local Group'
    'przemyslaw.klys@evotec.pl'
    'test2'
    'NT AUTHORITY\NETWORK'
    'NT AUTHORITY\SYSTEM'
    'S-1-5-21-853615985-2870445339-3163598659-519'
    'TEST\some'
    'EVOTECPL\Domain Admins'
    'NT AUTHORITY\INTERACTIVE'
    'INTERACTIVE'
    'EVOTEC\Domain Admins'
    'EVOTECPL\Domain Admins'
    'Test\Domain Admins'
    'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' # Valid
    'CN=S-1-5-21-1928204107-2710010574-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' # not valid
    'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' # cached
)

$TestOutput = Convert-Identity -Identity $Identity -Verbose
$TestOutput | Format-Table

$Identity.Count
$TestOutput.Count