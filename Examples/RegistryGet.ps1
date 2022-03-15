Clear-Host

Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE\Ok\MaybeNot\More" | Format-Table

Get-PSRegistry -RegistryPath "HKEY_USERS\S-1-5-18\Test", 'HKEY_USERS\S-1-5-19\Test' -Key "Ok" -ComputerName AD1, 'EVOPOWER' | Format-Table

Get-PSRegistry -RegistryPath "HKEY_CLASSES_ROOT" -Key 'test' | Format-Table

Get-PSRegistry -RegistryPath "HKEY_USERS" | Format-Table

$Output = Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE"
$Output | Format-Table

Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE\Ok\MaybeNot\More" -Advanced -ComputerName AD1, EVOPower | Format-Table

$Registry = @(
    "HKEY_LOCAL_MACHINE\SOFTWARE\7-Zip"
    "HKEY_LOCAL_MACHINE\SOFTWARE\Adobe\Adobe Acrobat"
)
Get-PSRegistry -RegistryPath $Registry | Format-Table

Get-PSRegistry -RegistryPath "HKLM:\SOFTWARE\Ok\MaybeNot\More" -ComputerName AD1 | Format-Table