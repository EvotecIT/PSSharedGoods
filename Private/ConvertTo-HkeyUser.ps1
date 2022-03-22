function ConvertTo-HkeyUser {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $HiveDictionary,
        [Array] $SubKeys,
        [string] $DictionaryKey
    )
    foreach ($Sub in $Subkeys) {
        if ($HiveDictionary[$DictionaryKey] -eq 'All') {
            if ($Sub -notlike "*_Classes*" -and $Sub -ne '.DEFAULT') {
                $R.Replace($DictionaryKey, "Users\$Sub")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'All+Default') {
            if ($Sub -notlike "*_Classes*") {
                $R.Replace($DictionaryKey, "Users\$Sub")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'Default') {
            if ($Sub -eq '.DEFAULT') {
                $R.Replace($DictionaryKey, "Users\.DEFAULT")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDomain+Default') {
            if (($Sub.StartsWith("S-1-5-21") -and $Sub -notlike "*_Classes*") -or $Sub -eq '.DEFAULT') {
                $R.Replace($DictionaryKey, "Users\$Sub")
            }
        } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDomain') {
            if ($Sub.StartsWith("S-1-5-21") -and $Sub -notlike "*_Classes*") {
                $R.Replace($DictionaryKey, "Users\$Sub")
            }
        }
    }
}