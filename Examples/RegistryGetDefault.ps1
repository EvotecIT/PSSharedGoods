Clear-Host

Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Get-PSRegistry -RegistryPath "HKEY_USERS" | Format-Table
Get-PSRegistry -RegistryPath "HKUDU:\Tests" | Format-Table
Get-PSRegistry -RegistryPath "HKUDUD:\Tests" | Format-Table
Get-PSRegistry -RegistryPath "HKUD:\Test1" | Format-Table
Get-PSRegistry -RegistryPath "HKEY_DEFAULT_USER\Test1" | Format-Table

for ($i = 0; $i -lt 20; $i++) {
    New-PSRegistry -RegistryPath "HKUD:\Test$i"
    Remove-PSRegistry -RegistryPath "HKUD:\Test$i"
}

Set-PSRegistry -RegistryPath "HKUD:\Test1" -Type REG_DWORD -Key "TestMe" -Value 5

Get-PSRegistry -RegistryPath "HKUDUD:\Software\\Policies\\Microsoft\\Windows\\CloudContent" #-Key 'ConfigureWindowsSpotlight'
Set-PSRegistry -RegistryPath "HKUDUD:\Software\\Policies\\Microsoft\\Windows\\CloudContent" -Key 'ConfigureWindowsSpotlight' -Type dword -Value 2
Set-PSRegistry -RegistryPath "Users\.DEFAULT_USER\Software\Policies\Microsoft\Windows\CloudContent" -Key 'DisableThirdPartySuggestions' -Type dword -Value 1
Get-PSRegistry -RegistryPath "Users\.DEFAULT_USER\Software\Policies\Microsoft\Windows\CloudContent" | Format-List