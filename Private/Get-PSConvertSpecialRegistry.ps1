function Get-PSConvertSpecialRegistry {
    [cmdletbinding()]
    param(
        [Array] $RegistryPath,
        [Array] $Computers,
        [System.Collections.IDictionary] $HiveDictionary
    )
    $FixedPath = foreach ($R in $RegistryPath) {
        foreach ($DictionaryKey in $HiveDictionary.Keys) {
            if ($R.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($HiveDictionary[$DictionaryKey] -in 'All', 'All+Default', 'Default', 'AllDomain+Default', 'AllDomain') {
                    foreach ($Computer in $Computers) {
                        $SubKeys = Get-PSRegistry -RegistryPath "HKEY_USERS" -ComputerName $Computer
                        if ($SubKeys.PSSubKeys) {
                            $RegistryKeys = ConvertTo-HKeyUser -SubKeys ($SubKeys.PSSubKeys | Sort-Object) -HiveDictionary $HiveDictionary -DictionaryKey $DictionaryKey
                            foreach ($S in $RegistryKeys) {
                                [PSCustomObject] @{
                                    ComputerName = $Computer
                                    RegistryPath = $S
                                    Error        = $null
                                    ErrorMessage = $null
                                }
                            }
                        } else {
                            [PSCustomObject] @{
                                ComputerName = $Computer
                                RegistryPath = $R
                                Error        = $true
                                ErrorMessage = "Couldn't connect to $Computer to list HKEY_USERS"
                            }
                        }
                    }
                } else {
                    $R
                }
                break
            }
        }
    }
    $FixedPath
}