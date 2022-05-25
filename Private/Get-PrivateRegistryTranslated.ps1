function Get-PrivateRegistryTranslated {
    [cmdletBinding()]
    param(
        [Array] $RegistryPath,
        [System.Collections.IDictionary] $HiveDictionary,
        [System.Collections.IDictionary] $ReverseTypesDictionary,
        [Parameter()][ValidateSet('REG_SZ', 'REG_NONE', 'None', 'REG_EXPAND_SZ', 'REG_BINARY', 'REG_DWORD', 'REG_MULTI_SZ', 'REG_QWORD', 'string', 'binary', 'dword', 'qword', 'multistring', 'expandstring')][string] $Type,
        [Parameter()][string] $Key,
        [Parameter()][object] $Value
    )
    foreach ($Registry in $RegistryPath) {
        # Remove additional slashes
        if ($Registry -is [string]) {
            $Registry = $Registry.Replace("\\", "\").Replace("\\", "\").TrimStart("\").TrimEnd("\")
        } else {
            $Registry.RegistryPath = $Registry.RegistryPath.Replace("\\", "\").Replace("\\", "\").TrimStart("\").TrimEnd("\")
        }
        foreach ($Hive in $HiveDictionary.Keys) {
            if ($Registry -is [string] -and $Registry.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($Hive.Length -eq $Registry.Length) {
                    [ordered] @{
                        HiveKey    = $HiveDictionary[$Hive]
                        SubKeyName = $null
                        ValueKind  = if ($Type) { [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type]) } else { $null }
                        Key        = $Key
                        Value      = $Value
                    }
                } else {
                    [ordered] @{
                        HiveKey    = $HiveDictionary[$Hive]
                        SubKeyName = $Registry.substring($Hive.Length + 1)
                        ValueKind  = if ($Type) { [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type]) } else { $null }
                        Key        = $Key
                        Value      = $Value
                    }
                }
                break
            } elseif ($Registry -isnot [string] -and $Registry.RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($Hive.Length -eq $Registry.RegistryPath.Length) {
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $null
                        ValueKind    = if ($Type) { [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type]) } else { $null }
                        Key          = $Key
                        Value        = $Value
                    }
                } else {
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $Registry.RegistryPath.substring($Hive.Length + 1)
                        ValueKind    = if ($Type) { [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type]) } else { $null }
                        Key          = $Key
                        Value        = $Value
                    }
                }
                break
            }
        }
    }
}