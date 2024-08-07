﻿function Resolve-PrivateRegistry {
    <#
    .SYNOPSIS
    Resolves and standardizes registry paths for consistency and compatibility.

    .DESCRIPTION
    The Resolve-PrivateRegistry function resolves and standardizes registry paths to ensure uniformity and compatibility across different systems. It cleans up the paths, converts short hive names to full names, and handles special cases like DEFAULT USER mappings.

    .PARAMETER RegistryPath
    Specifies an array of registry paths to be resolved and standardized.

    .EXAMPLE
    Resolve-PrivateRegistry -RegistryPath 'Users\.DEFAULT_USER\Software\MyApp'
    Resolves the registry path 'Users\.DEFAULT_USER\Software\MyApp' to 'HKUD\Software\MyApp' for consistent usage.

    .EXAMPLE
    Resolve-PrivateRegistry -RegistryPath 'HKCU\Software\MyApp'
    Resolves the registry path 'HKCU\Software\MyApp' to 'HKEY_CURRENT_USER\Software\MyApp' for compatibility with standard naming conventions.

    #>
    [CmdletBinding()]
    param(
        [alias('Path')][string[]] $RegistryPath
    )
    foreach ($R in $RegistryPath) {
        # clean up the path
        $R = $R.Replace("\\", "\").Replace("\\", "\")

        # This is to address DEFAULT USER Mapping when after returning value from registry someone takes it and feeds it back to cmdlets
        If ($R.StartsWith("Users\.DEFAULT_USER") -or $R.StartsWith('HKEY_USERS\.DEFAULT_USER')) {
            $R = $R.Replace("Users\.DEFAULT_USER", "HKUD")
            $R.Replace('HKEY_USERS\.DEFAULT_USER', "HKUD")
        } elseif ($R -like '*:*') {
            $Found = $false
            # This makes sure any short HIVES are converted to expected values
            foreach ($DictionaryKey in $Script:Dictionary.Keys) {
                $SplitParts = $R.Split("\")
                $FirstPart = $SplitParts[0]
                if ($FirstPart -eq $DictionaryKey) {
                    $R -replace $DictionaryKey, $Script:Dictionary[$DictionaryKey]
                    $Found = $true
                    break
                }
            }
            # Lets try to fix things for user if he uses LONG HIVE names but still with colon
            if (-not $Found) {
                $R.Replace(":", "")
            }
        } else {
            # This makes sure we do any string without ":" as literal and follow what user wants
            $R
        }
    }
}