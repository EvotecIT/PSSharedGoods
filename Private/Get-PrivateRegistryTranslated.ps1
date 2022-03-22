function Get-PrivateRegistryTranslated {
    [cmdletBinding()]
    param(
        [Array] $RegistryPath,
        [System.Collections.IDictionary] $HiveDictionary,
        [System.Collections.IDictionary] $ReverseTypesDictionary,
        [Parameter(Mandatory)][ValidateSet('REG_SZ', 'REG_EXPAND_SZ', 'REG_BINARY', 'REG_DWORD', 'REG_MULTI_SZ', 'REG_QWORD', 'string', 'binary', 'dword', 'qword', 'multistring', 'expandstring')][string] $Type,
        [Parameter(Mandatory)][string] $Key,
        [Parameter(Mandatory)][object] $Value
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
                    # [ordered] @{
                    #     Registry   = $Registry
                    #     HiveKey    = $HiveDictionary[$Hive]
                    #     SubKeyName = $null
                    #     Key        = if ($Key -eq "") { $null } else { $Key }
                    # }
                    [ordered] @{
                        HiveKey    = $HiveDictionary[$Hive]
                        SubKeyName = $null
                        ValueKind  = [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type])
                        Key        = $Key
                        Value      = $Value
                    }
                } else {
                    # [ordered] @{
                    #     Registry   = $Registry
                    #     HiveKey    = $HiveDictionary[$Hive]
                    #     SubKeyName = $Registry.substring($Hive.Length + 1)
                    #     Key        = if ($Key -eq "") { $null } else { $Key }
                    # }
                    [ordered] @{
                        HiveKey    = $HiveDictionary[$Hive]
                        SubKeyName = $Registry.substring($Hive.Length + 1)
                        ValueKind  = [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type])
                        Key        = $Key
                        Value      = $Value
                    }
                }
                break
            } elseif ($Registry -isnot [string] -and $Registry.RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($Hive.Length -eq $Registry.RegistryPath.Length) {
                    # [ordered] @{
                    #     ComputerName = $Registry.ComputerName
                    #     Registry     = $Registry.RegistryPath
                    #     HiveKey      = $HiveDictionary[$Hive]
                    #     SubKeyName   = $null
                    #     Key          = if ($Key -eq "") { $null } else { $Key }
                    # }
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $null
                        ValueKind    = [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type])
                        Key          = $Key
                        Value        = $Value
                    }
                } else {
                    # [ordered] @{
                    #     ComputerName = $Registry.ComputerName
                    #     Registry     = $Registry.RegistryPath
                    #     HiveKey      = $HiveDictionary[$Hive]
                    #     SubKeyName   = $Registry.RegistryPath.substring($Hive.Length + 1)
                    #     Key          = if ($Key -eq "") { $null } else { $Key }
                    # }
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $Registry.RegistryPath.substring($Hive.Length + 1)
                        ValueKind    = [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type])
                        Key          = $Key
                        Value        = $Value
                    }
                }
                break
            }
        }
    }
}