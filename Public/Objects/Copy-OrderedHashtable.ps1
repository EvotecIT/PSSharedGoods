function Copy-OrderedHashtable {
    param(
        $OrderedHashtableSource,
        $OrderedHashtableTarget
    )
    if ($null -eq $OrderedHashtableTarget) {
        $OrderedHashtableTarget = [ordered] @{}
    }
    foreach ($pair in $OrderedHashtableSource.GetEnumerator()) {
        $OrderedHashtableTarget[$pair.Key] = $pair.Value
    }
    return $OrderedHashtableTarget
}