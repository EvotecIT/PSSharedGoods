function ConvertTo-HkeyUser {
    <#
    .SYNOPSIS
    Converts registry paths based on specified criteria.

    .DESCRIPTION
    This function converts registry paths based on the provided HiveDictionary, SubKeys, DictionaryKey, and RegistryPath parameters.

    .PARAMETER HiveDictionary
    Specifies the dictionary containing the criteria for converting registry paths.

    .PARAMETER SubKeys
    Specifies an array of subkeys to process.

    .PARAMETER DictionaryKey
    Specifies the key in the RegistryPath to be replaced.

    .PARAMETER RegistryPath
    Specifies the original registry path to be converted.

    .EXAMPLE
    ConvertTo-HkeyUser -HiveDictionary @{ 'Key1' = 'AllDomain'; 'Key2' = 'All+Default' } -SubKeys @('S-1-5-21-123456789-123456789-123456789-1001', '.DEFAULT') -DictionaryKey 'Key1' -RegistryPath 'HKLM:\Software\Key1\SubKey'

    Description:
    Converts the RegistryPath based on the specified criteria in the HiveDictionary for the provided SubKeys.

    .EXAMPLE
    ConvertTo-HkeyUser -HiveDictionary @{ 'Key1' = 'Users'; 'Key2' = 'AllDomain+Other' } -SubKeys @('S-1-5-21-123456789-123456789-123456789-1001', 'Offline_User1') -DictionaryKey 'Key2' -RegistryPath 'HKLM:\Software\Key2\SubKey'

    Description:
    Converts the RegistryPath based on the specified criteria in the HiveDictionary for the provided SubKeys.

    #>
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $HiveDictionary,
        [Array] $SubKeys,
        [string] $DictionaryKey,
        [string] $RegistryPath
    )
    $OutputRegistryKeys = foreach ($Sub in $Subkeys) {
        if ($HiveDictionary[$DictionaryKey] -eq 'All') {
            if ($Sub -notlike "*_Classes*" -and $Sub -ne '.DEFAULT') {
                $RegistryPath.Replace($DictionaryKey, "Users\$Sub")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'All+Default') {
            if ($Sub -notlike "*_Classes*") {
                if (-not $Script:DefaultRegistryMounted) {
                    $Script:DefaultRegistryMounted = Mount-DefaultRegistryPath
                }
                if ($Sub -eq '.DEFAULT') {
                    $RegistryPath.Replace($DictionaryKey, "Users\.DEFAULT_USER")
                } else {
                    $RegistryPath.Replace($DictionaryKey, "Users\$Sub")
                }
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'Default') {
            if ($Sub -eq '.DEFAULT') {
                if (-not $Script:DefaultRegistryMounted) {
                    $Script:DefaultRegistryMounted = Mount-DefaultRegistryPath
                }
                $RegistryPath.Replace($DictionaryKey, "Users\.DEFAULT_USER")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDomain+Default') {
            if (($Sub.StartsWith("S-1-5-21") -and $Sub -notlike "*_Classes*") -or $Sub -eq '.DEFAULT') {
                if (-not $Script:DefaultRegistryMounted) {
                    $Script:DefaultRegistryMounted = Mount-DefaultRegistryPath
                }
                if ($Sub -eq '.DEFAULT') {
                    $RegistryPath.Replace($DictionaryKey, "Users\.DEFAULT_USER")
                } else {
                    $RegistryPath.Replace($DictionaryKey, "Users\$Sub")
                }
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDomain+Other') {
            if (($Sub.StartsWith("S-1-5-21") -and $Sub -notlike "*_Classes*")) {
                if (-not $Script:OfflineRegistryMounted) {
                    $Script:OfflineRegistryMounted = Mount-AllRegistryPath
                    foreach ($Key in $Script:OfflineRegistryMounted.Keys) {
                        $RegistryPath.Replace($DictionaryKey, "Users\$Key")
                    }
                }
                $RegistryPath.Replace($DictionaryKey, "Users\$Sub")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDomain+Other+Default') {
            if (($Sub.StartsWith("S-1-5-21") -and $Sub -notlike "*_Classes*") -or $Sub -eq '.DEFAULT') {
                if (-not $Script:DefaultRegistryMounted) {
                    $Script:DefaultRegistryMounted = Mount-DefaultRegistryPath
                }
                if (-not $Script:OfflineRegistryMounted) {
                    $Script:OfflineRegistryMounted = Mount-AllRegistryPath
                    foreach ($Key in $Script:OfflineRegistryMounted.Keys) {
                        $RegistryPath.Replace($DictionaryKey, "Users\$Key")
                    }
                }
                if ($Sub -eq '.DEFAULT') {
                    $RegistryPath.Replace($DictionaryKey, "Users\.DEFAULT_USER")
                } else {
                    $RegistryPath.Replace($DictionaryKey, "Users\$Sub")
                }
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDomain') {
            if ($Sub.StartsWith("S-1-5-21") -and $Sub -notlike "*_Classes*") {
                $RegistryPath.Replace($DictionaryKey, "Users\$Sub")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'Users') {
            if ($Sub -like "Offline_*") {
                $Script:OfflineRegistryMounted = Mount-AllRegistryPath -MountUsers $Sub
                foreach ($Key in $Script:OfflineRegistryMounted.Keys) {
                    if ($Script:OfflineRegistryMounted[$Key].Status -eq $true) {
                        $RegistryPath
                    }
                }
            }
        }
    }
    $OutputRegistryKeys | Sort-Object -Unique
}