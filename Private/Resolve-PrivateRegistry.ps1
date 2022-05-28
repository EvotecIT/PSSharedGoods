function Resolve-PrivateRegistry {
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
            # This makes sure any short HIVES are converted to expected values
            foreach ($DictionaryKey in $Script:Dictionary.Keys) {
                if ($R.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                    $R -replace $DictionaryKey, $Script:Dictionary[$DictionaryKey]
                    break
                }
            }
        } else {
            $R
        }
    }
}