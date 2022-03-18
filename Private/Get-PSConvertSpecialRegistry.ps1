function Get-PSConvertSpecialRegistry {
    [cmdletbinding()]
    param(
        [Array] $RegistryPath,
        [Array] $Computers
    )

    # We need to support the PSDrive syntax for backwards compatibility
    $Dictionary = @{
        'HKCR:'  = 'HKEY_CLASSES_ROOT'
        'HKCU:'  = 'HKEY_CURRENT_USER'
        'HKLM:'  = 'HKEY_LOCAL_MACHINE'
        'HKU:'   = 'HKEY_USERS'
        'HKCC:'  = 'HKEY_CURRENT_CONFIG'
        'HKDD:'  = 'HKEY_DYN_DATA'
        'HKPD:'  = 'HKEY_PERFORMANCE_DATA'
        # Those don't really exists, but we want to allow targetting all users or default users
        'HKUAD:' = 'HKEY_ALL_USERS_DEFAULT' # All users in HKEY_USERS including .DEFAULT
        'HKUA:'  = 'HKEY_ALL_USERS' # All users in HKEY_USERS excluding .DEFAULT
        'HKUD:'  = 'HKEY_DEFAULT_USER' # DEFAULT user in HKEY_USERS
    }
    $HiveDictionary = @{
        'HKEY_CLASSES_ROOT'      = 'ClassesRoot'
        'HKCR'                   = 'ClassesRoot'
        'HKCU'                   = 'CurrentUser'
        'HKEY_CURRENT_USER'      = 'CurrentUser'
        'HKLM'                   = 'LocalMachine'
        'HKEY_LOCAL_MACHINE'     = 'LocalMachine'
        'HKU'                    = 'Users'
        'HKEY_USERS'             = 'Users'
        'HKCC'                   = 'CurrentConfig'
        'HKEY_CURRENT_CONFIG'    = 'CurrentConfig'
        'HKDD'                   = 'DynData'
        'HKEY_DYN_DATA'          = 'DynData'
        'HKPD'                   = 'PerformanceData'
        'HKEY_PERFORMANCE_DATA ' = 'PerformanceData '

        'HKEY_ALL_USERS'         = 'All'
        'HKEY_ALL_USERS_DEFAULT' = 'AllDefault'
        'HKEY_DEFAULT_USER'      = 'Default'
    }

    $FixedPath = foreach ($R in $RegistryPath) {
        foreach ($DictionaryKey in $HiveDictionary.Keys) {
            if ($R.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($HiveDictionary[$DictionaryKey] -in 'All', 'AllDefault', 'Default') {
                    foreach ($Computer in $Computers) {
                        $SubKeys = Get-PSRegistry -RegistryPath "HKEY_USERS" -ComputerName $Computer
                        if ($SubKeys.PSSubKeys) {
                            $RegistryKeys = ConvertTo-HKeyUser -SubKeys ($SubKeys.PSSubKeys | Sort-Object) -HiveDictionary $HiveDictionary
                            foreach ($S in $RegistryKeys) {
                                [PSCustomObject] @{
                                    ComputerName = $Computer
                                    RegistryPath = $S
                                }
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