function Get-PSSubRegistryTranslated {
    [cmdletBinding()]
    param(
        [Array] $RegistryPath,
        [System.Collections.IDictionary] $HiveDictionary,
        [string] $Key
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
                        Registry   = $Registry
                        HiveKey    = $HiveDictionary[$Hive]
                        SubKeyName = $null
                        Key        = if ($Key -eq "") { $null } else { $Key }
                    }
                } else {
                    [ordered] @{
                        Registry   = $Registry
                        HiveKey    = $HiveDictionary[$Hive]
                        SubKeyName = $Registry.substring($Hive.Length + 1)
                        Key        = if ($Key -eq "") { $null } else { $Key }
                    }
                }
                break
            } elseif ($Registry -isnot [string] -and $Registry.RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($Hive.Length -eq $Registry.RegistryPath.Length) {
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        Registry     = $Registry.RegistryPath
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $null
                        Key          = if ($Key -eq "") { $null } else { $Key }
                    }
                } else {
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        Registry     = $Registry.RegistryPath
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $Registry.RegistryPath.substring($Hive.Length + 1)
                        Key          = if ($Key -eq "") { $null } else { $Key }
                    }
                }
                break
            }
        }
    }
}