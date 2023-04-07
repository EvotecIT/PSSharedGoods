function ConvertTo-HkeyUser {
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