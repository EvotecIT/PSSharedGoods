Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

New-PSRegistry -RegistryPath "HKCU:\\Tests1\CurrentControlSet\Control\Lsa" -Verbose -WhatIf

Get-PSRegistry -RegistryPath "HKCU:\\Tests1\CurrentControlSet\Control\Lsa" -Verbose