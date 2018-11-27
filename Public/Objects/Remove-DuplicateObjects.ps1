function Remove-DuplicateObjects {
    [CmdletBinding()]
    param(
        $Object,
        $Property
    )
    $Count = Get-ObjectCount -Object $Object
    if ($Count -eq 0) {
        return $Object
    } else {
        return $Object | Sort-Object -Property $Property -Unique
    }
}