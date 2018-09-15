function Add-ToHashTable($Hashtable, $Key, $Value) {
    if ($Value -ne $null -and $Value -ne '') {
        $Hashtable.Add($Key, $Value)
    }
}