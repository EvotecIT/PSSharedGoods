
Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force

Convert-Identity -Identity 'TEST\some'
Convert-Identity -Identity 'S-1-5-21-853615985-2870445339-3163598659-519'
Convert-Identity -Identity 'EVOTECPL\Domain Admins'
Convert-Identity -Identity 'NT AUTHORITY\NETWORK', 'NT AUTHORITY\SYSTEM'
Convert-Identity -Identity 'przemyslaw.klys@evotec.pl'
Convert-Identity -Identity 'S-1-5-21-853615985-2870445339-3163598659-1105'
Convert-Identity -Identity 'adm.pklys'
# Another forest SID
Convert-Identity -Identity 'TEST\some'
Convert-Identity -Identity 'S-1-5-21-1928204107-2710010574-1926425344-1105'
Convert-Identity -Identity 'TEST\TestUserIgnore'
Convert-Identity -Identity 'S-1-5-21-1928204107-2710010574-1926425344-1106'
ConvertTo-SID -Identity 'S-1-5-21-1928204107-2710010574-1926425344-1106'
ConvertTo-Identity -Identity 'S-1-5-21-853615985-2870445339-3163598659-519'
ConvertTo-Identity -Identity 'EVOTECPL\Domain Admins'

ConvertTo-SID -Identity 'EVOTEC\Domain Admins', 'EVOTECPL\Domain Admins', 'Domain Admins' | Format-Table
ConvertTo-SID -Identity 'NT AUTHORITY\NETWORK', 'NT AUTHORITY\SYSTEM'
ConvertTo-SID -Identity 'przemyslaw.klys@evotec.pl' | Format-Table
ConvertTo-SID -Identity 'test2' | Format-Table