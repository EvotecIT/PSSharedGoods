function Get-PSRegistryTranslated {
    [cmdletBinding()]
    param(
        [Array] $RegistryPath,
        [System.Collections.IDictionary] $HiveDictionary,
        [string] $Key
    )
    foreach ($Registry in $RegistryPath) {
        # Remove additional slashes
        $Registry = $Registry.Replace("\\", "\").Replace("\\", "\").TrimStart("\").TrimEnd("\")

        foreach ($Hive in $HiveDictionary.Keys) {
            if ($Registry.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
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
            }
        }
    }
}