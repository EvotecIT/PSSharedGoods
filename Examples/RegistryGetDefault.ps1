Clear-Host

Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$Registry = Get-PSRegistry -Path "HKEY_CURRENT_USER\Printers\ConvertUserDevModesCount"
$FoundKeys = foreach ($R in $Registry.PSObject.Properties.Name) {
    if ($R -like "*EVO*") {
        $R
    }
}
foreach ($Key in $FoundKeys) {
    Remove-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Printers\ConvertUserDevModesCount" -Key $Key
}

#Get-PSRegistry -RegistryPath "HKLM\SOFTWARE\Microsoft\Windows NT"

#Get-PSRegistry -RegistryPath "HKEY_USERS" | Format-Table
#Get-PSRegistry -RegistryPath "HKUDUO:\Environment" -Key "OneDrive" -Verbose | Format-Table
#Get-PSRegistry -RegistryPath "HKUDUDO:\Environment" -Key "OneDrive" -Verbose | Format-Table
#Get-PSRegistry -RegistryPath "HKUDUDO\Environment" -Key "OneDrive" -Verbose | Format-Table
#Get-PSRegistry -RegistryPath "HKEY_ALL_DOMAIN_USERS_OTHER_DEFAULT:\Environment" -Key "OneDrive" -Verbose | Format-Table
#Get-PSRegistry -RegistryPath "HKEY_ALL_DOMAIN_USERS_OTHER_DEFAULT\Environment" -Key "TEMP" -Verbose | Format-Table
#Get-PSRegistry -RegistryPath "HKUDUDO:\Software\\Policies1\\Microsoft\\Windows\\CloudContent" -Key "DisableTailoredExperiencesWithDiagnosticData" -Verbose | Format-Table
#Set-PSRegistry -Verbose -RegistryPath "HKUDUDO:\Software\\Policies1\\Microsoft\\Windows\\CloudContent" -Key 'DisableTailoredExperiencesWithDiagnosticData' -Type dword -Value 1 | Format-Table
#Set-PSRegistry -RegistryPath 'Users\Offline_test.1\Software\Policies1\Microsoft\Windows\CloudContent' -Key 'DisableTailoredExperiencesWithDiagnosticData' -Type dword -Value 1 | Format-Table

#Get-PSRegistry -Verbose -RegistryPath "Users\Offline_test.1\Software\Policies1\Microsoft\Windows\CloudContent" -Key 'DisableTailoredExperiencesWithDiagnosticData' | Format-Table
#Set-PSRegistry -Verbose -RegistryPath 'HKU:\Offline_Przemek\Software\Policies1\Microsoft\Windows\CloudContent' -Key 'DisableTailoredExperiencesWithDiagnosticData' -Type dword -Value 1 | Format-Table
#Set-PSRegistry -Verbose -RegistryPath 'HKEY_USERS:\Offline_Przemek\Software\Policies1\Microsoft\Windows\CloudContent' -Key 'DisableTailoredExperiencesWithDiagnosticData' -Type dword -Value 1 | Format-Table
#Set-PSRegistry -RegistryPath 'Users\.DEFAULT_USER\Software\Policies1\Microsoft\Windows\CloudContent' -Key 'DisableTailoredExperiencesWithDiagnosticData' -Type dword -Value 1 | Format-Table
#Get-PSRegistry -RegistryPath "HKUDUD:\Environment" | Format-Table
#Get-PSRegistry -RegistryPath "HKUD:\Test1" | Format-Table
#Get-PSRegistry -RegistryPath "HKEY_DEFAULT_USER\Test1" | Format-Table

#Get-PSRegistry -RegistryPath "HKEY_USERS\S-1-5-21-853615985-2870445339-3163598659-1105\Control Panel\Mouse" | Format-Table
#Get-PSRegistry -RegistryPath "HKUDUO:\Control Panel\Mouse" -Verbose | Format-Table
#Get-PSRegistry -RegistryPath "HKEY_DEFAULT_USER\Test1" -Key '' | Format-Table

# for ($i = 0; $i -lt 20; $i++) {
#     New-PSRegistry -RegistryPath "HKUD:\Test$i"
#     Remove-PSRegistry -RegistryPath "HKUD:\Test$i"
# }

# Set-PSRegistry -RegistryPath "HKUD:\Test1" -Type REG_DWORD -Key "TestMe" -Value 5

# Get-PSRegistry -RegistryPath "HKUDUD:\Software\\Policies\\Microsoft\\Windows\\CloudContent" #-Key 'ConfigureWindowsSpotlight'
# Set-PSRegistry -RegistryPath "HKUDUD:\Software\\Policies\\Microsoft\\Windows\\CloudContent" -Key 'ConfigureWindowsSpotlight' -Type dword -Value 2
# Set-PSRegistry -RegistryPath "Users\.DEFAULT_USER\Software\Policies\Microsoft\Windows\CloudContent" -Key 'DisableThirdPartySuggestions' -Type dword -Value 1
# Get-PSRegistry -RegistryPath "Users\.DEFAULT_USER\Software\Policies\Microsoft\Windows\CloudContent" | Format-List

# Get the domain name from the first line of $results.DuplicatePasswordGroups