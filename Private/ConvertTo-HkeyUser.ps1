function ConvertTo-HkeyUser {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $HiveDictionary,
        [Array] $SubKeys
    )
    if ($HiveDictionary[$DictionaryKey] -eq 'All') {
        foreach ($Sub in $Subkeys) {
            if ($Sub -notlike "*_Classes*" -and $Sub -ne '.DEFAULT') {
                $R.Replace($DictionaryKey, "Users\$Sub")
            }
        }
    } elseif ($HiveDictionary[$DictionaryKey] -eq 'AllDefault') {
        if ($Sub -notlike "*_Classes*") {
            $R.Replace($DictionaryKey, "Users\$Sub")
        }
    } elseif ($HiveDictionary[$DictionaryKey] -eq 'Default') {
        if ($Sub -eq '.DEFAULT') {
            $R.Replace($DictionaryKey, "Users\$Sub")
        }
    }
}