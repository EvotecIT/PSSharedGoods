function Get-ObjectKeys {
    param(
        [object] $Object,
        [string] $Ignore
    )
    $Data = $Object.Keys | Where { $_ -notcontains $Ignore }
    return $Data
}