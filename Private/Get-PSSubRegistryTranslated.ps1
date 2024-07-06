function Get-PSSubRegistryTranslated {
    <#
    .SYNOPSIS
    Retrieves the translated sub-registry information based on the provided RegistryPath, HiveDictionary, and Key.

    .DESCRIPTION
    This function retrieves the translated sub-registry information by matching the RegistryPath with the HiveDictionary. It returns an ordered hashtable with details such as Registry, HiveKey, SubKeyName, Key, Error, and ErrorMessage.

    .PARAMETER RegistryPath
    Specifies an array of registry paths to be translated.

    .PARAMETER HiveDictionary
    Specifies a dictionary containing mappings of hive names to their corresponding keys.

    .PARAMETER Key
    Specifies a string key to be included in the output.

    .EXAMPLE
    Get-PSSubRegistryTranslated -RegistryPath "HKLM\Software\Microsoft" -HiveDictionary @{ "HKLM" = "HKEY_LOCAL_MACHINE" } -Key "Version"
    Retrieves the translated sub-registry information for the specified registry path under HKEY_LOCAL_MACHINE hive with the key "Version".

    .EXAMPLE
    Get-PSSubRegistryTranslated -RegistryPath "HKCU\Software\Microsoft" -HiveDictionary @{ "HKCU" = "HKEY_CURRENT_USER" }
    Retrieves the translated sub-registry information for the specified registry path under HKEY_CURRENT_USER hive without specifying a key.

    #>
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
            $FirstPartSplit = $Registry -split "\\"
            $FirstPart = $FirstPartSplit[0]
        } else {
            $Registry.RegistryPath = $Registry.RegistryPath.Replace("\\", "\").Replace("\\", "\").TrimStart("\").TrimEnd("\")
            $FirstPartSplit = $Registry.RegistryPath -split "\\"
            $FirstPart = $FirstPartSplit[0]
        }

        foreach ($Hive in $HiveDictionary.Keys) {
            if ($Registry -is [string] -and $FirstPart -eq $Hive) {
                # if ($Registry -is [string] -and $Registry.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($Hive.Length -eq $Registry.Length) {
                    [ordered] @{
                        Registry     = $Registry
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $null
                        Key          = if ($Key -eq "") { $null } else { $Key }
                        Error        = $null
                        ErrorMessage = $null
                    }
                } else {
                    [ordered] @{
                        Registry     = $Registry
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $Registry.substring($Hive.Length + 1)
                        Key          = if ($Key -eq "") { $null } else { $Key }
                        Error        = $null
                        ErrorMessage = $null
                    }
                }
                break
            } elseif ($Registry -isnot [string] -and $FirstPart -eq $Hive) {
                #} elseif ($Registry -isnot [string] -and $Registry.RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                if ($Hive.Length -eq $Registry.RegistryPath.Length) {
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        Registry     = $Registry.RegistryPath
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $null
                        Key          = if ($Key -eq "") { $null } else { $Key }
                        Error        = $Registry.Error
                        ErrorMessage = $Registry.ErrorMessage
                    }
                } else {
                    [ordered] @{
                        ComputerName = $Registry.ComputerName
                        Registry     = $Registry.RegistryPath
                        HiveKey      = $HiveDictionary[$Hive]
                        SubKeyName   = $Registry.RegistryPath.substring($Hive.Length + 1)
                        Key          = if ($Key -eq "") { $null } else { $Key }
                        Error        = $Registry.Error
                        ErrorMessage = $Registry.ErrorMessage
                    }
                }
                break
            }
        }
    }
}