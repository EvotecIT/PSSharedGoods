Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

New-PSRegistry -RegistryPath "HKCU:\\Tests1\CurrentControlSet\Control\Lsa" -Verbose -WhatIf | Format-Table
Get-PSRegistry -RegistryPath "HKCU:\\Tests1\CurrentControlSet\Control\Lsa" -Verbose | Format-Table

New-PSRegistry -RegistryPath "HKUDUO:\\Tests1\CurrentControlSet\Control\Lsa" -WhatIf | Format-Table
Get-PSRegistry -RegistryPath "HKUDUO:\Tests1\CurrentControlSet\Control\Lsa" | Format-Table