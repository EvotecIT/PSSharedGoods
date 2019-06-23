function Copy-OrderedHashtable {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $OrderedHashtableSource,
        [System.Collections.IDictionary] $OrderedHashtableTarget
    )
    if ($null -eq $OrderedHashtableTarget) {
        $OrderedHashtableTarget = [ordered] @{ }
    }
    foreach ($pair in $OrderedHashtableSource.GetEnumerator()) {
        $OrderedHashtableTarget[$pair.Key] = $pair.Value
    }
    return $OrderedHashtableTarget
}