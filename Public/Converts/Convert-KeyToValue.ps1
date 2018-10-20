function Convert-KeyToKeyValue {
    [CmdletBinding()]
    param (
        [object] $Object
    )
    $NewHash = [ordered] @{}
    foreach ($O in $Object.Keys) {
        $KeyName = "$O ($($Object.$O))"
        $KeyValue = $Object.$O
        $NewHash.$KeyName = $KeyValue
    }
    return $NewHash
}