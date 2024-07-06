function Get-PrivateRegistryTranslated {
    <#
    .SYNOPSIS
    Retrieves translated private registry information based on the provided parameters.

    .DESCRIPTION
    This function retrieves translated private registry information based on the specified RegistryPath, HiveDictionary, ReverseTypesDictionary, Type, Key, and Value parameters.

    .PARAMETER RegistryPath
    Specifies the array of registry paths to be translated.

    .PARAMETER HiveDictionary
    Specifies the dictionary containing mappings of registry hives.

    .PARAMETER ReverseTypesDictionary
    Specifies the dictionary containing mappings of registry value types.

    .PARAMETER Type
    Specifies the type of the registry value. Valid values are 'REG_SZ', 'REG_NONE', 'None', 'REG_EXPAND_SZ', 'REG_BINARY', 'REG_DWORD', 'REG_MULTI_SZ', 'REG_QWORD', 'string', 'binary', 'dword', 'qword', 'multistring', 'expandstring'.

    .PARAMETER Key
    Specifies the key associated with the registry value.

    .PARAMETER Value
    Specifies the value of the registry key.

    .EXAMPLE
    Get-PrivateRegistryTranslated -RegistryPath "HKLM\Software\Microsoft" -HiveDictionary @{"HKLM"="HKEY_LOCAL_MACHINE"} -ReverseTypesDictionary @{"string"="REG_SZ"} -Type "string" -Key "Version" -Value "10.0.19041"

    Description
    -----------
    Retrieves translated registry information for the specified registry path.

    .EXAMPLE
    Get-PrivateRegistryTranslated -RegistryPath "HKCU\Software\Settings" -HiveDictionary @{"HKCU"="HKEY_CURRENT_USER"} -ReverseTypesDictionary @{"dword"="REG_DWORD"} -Type "dword" -Key "SettingA" -Value 1

    Description
    -----------
    Retrieves translated registry information for the specified registry path.

    #>
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