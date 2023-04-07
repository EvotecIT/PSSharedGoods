function Get-PSConvertSpecialRegistry {
    [cmdletbinding()]
    param(
        [Array] $RegistryPath,
        [Array] $Computers,
        [System.Collections.IDictionary] $HiveDictionary,
        [switch] $ExpandEnvironmentNames
    )
    $FixedPath = foreach ($R in $RegistryPath) {
        foreach ($DictionaryKey in $HiveDictionary.Keys) {
            $SplitParts = $R.Split("\")
            $FirstPart = $SplitParts[0]
            if ($FirstPart -eq $DictionaryKey) {
                #if ($R.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($HiveDictionary[$DictionaryKey] -in 'All', 'All+Default', 'Default', 'AllDomain+Default', 'AllDomain', 'AllDomain+Other', 'AllDomain+Other+Default') {
                    foreach ($Computer in $Computers) {
                        $SubKeys = Get-PSRegistry -RegistryPath "HKEY_USERS" -ComputerName $Computer -ExpandEnvironmentNames:$ExpandEnvironmentNames.IsPresent -DoNotUnmount
                        if ($SubKeys.PSSubKeys) {
                            $RegistryKeys = ConvertTo-HKeyUser -SubKeys ($SubKeys.PSSubKeys | Sort-Object) -HiveDictionary $HiveDictionary -DictionaryKey $DictionaryKey -RegistryPath $R
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