Clear-Host
Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

#Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\Installer" -Key "EnableUserControl"
#Get-PSRegistry -RegistryPath "HKCU:\\\\Tests" -Key 'LimitBlankPasswordUse'
#Set-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -Key 'ForceUnlockLogon' -Value 1 -Type dword -WhatIf
#Set-PSRegistry -RegistryPath "Users\.DEFAULT\Tests" -Key 'LimitBlankPasswordUse' -Value '1' -Type dword

Get-PSRegistry -RegistryPath "HKUDUO:\Tests1\CurrentControlSet\Control\Lsa" | Format-Table
Set-PSRegistry -RegistryPath "HKUDUO:\Tests1\CurrentControlSet\Control\Lsa" -Key 'LimitBlankPasswordUse' -Value '1' -Type dword
return

Set-PSRegistry -RegistryPath "HKEY_DEFAULT_USER\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -ComputerName EVOPOWER | Format-Table
Set-PSRegistry -RegistryPath "HKUA:\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -ComputerName EVOPOWER | Format-Table
Set-PSRegistry -RegistryPath "HKUAD:\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -ComputerName EVOPOWER | Format-Table

#Set-PSRegistry -RegistryPath "HKCU:\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -ComputerName AD1, EVOPower
#Set-PSRegistry -RegistryPath "HKCU:\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -ComputerName EVOPower #, EVOPower

return

Set-PSRegistry -RegistryPath "HKCU:\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -WhatIf
Set-PSRegistry -RegistryPath "HKCU:\\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -WhatIf
Set-PSRegistry -RegistryPath "HKCU:\\Tests" -Key "LimitBlankPass1wordUse" -Value "0" -Type REG_DWORD -WhatIf
Set-PSRegistry -RegistryPath "HKCU:\\Tests\MoreTests\Tests1" -Key "LimitBlankPass1wordUse" -Value "0" -Type REG_DWORD -WhatIf

Test-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot\More\AndMore"
Test-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot\More\AndMore" -Key "LimitBlankPass1wordUse"
Test-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot\More\AndMore" -Key "LimitBlankPasswordUse2"

Get-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' -ComputerName AD1 | Format-Table *

Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_DWORD -Key "16 LDAP Interface Events" -Value 2 -ComputerName AD1 -WhatIf
Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_SZ -Key "LDAP Interface Events" -Value 'test' -ComputerName AD1 -WhatIf
Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_EXPAND_SZ -Key "LDAP12 Interface Events" -Value 'test' -ComputerName AD1 -WhatIf
Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_MULTI_SZ -Key "LDAP12123 Interface Events" -Value @('test', 'ok') -ComputerName AD1 -WhatIf

Set-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot\More\AndMore" -Key "LimitBlankPasswordUse2" -Value 0 -Type REG_DWORD -WhatIf
Set-PSRegistry -RegistryPath "HKLM\Software\Ok\MaybeNot\More\AndMore" -Key "LimitBlankPasswordUse2" -Value 0 -Type REG_DWORD -ComputerName 'AD1' -WhatIf

Set-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\CurrentControlSet\Control\Lsa" -Key "LimitBlankPasswordUse" -Value "0" -Type REG_DWORD -WhatIf