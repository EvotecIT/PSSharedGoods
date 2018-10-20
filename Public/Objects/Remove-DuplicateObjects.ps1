function Remove-DuplicateObjects {
    [CmdletBinding()]
    param(
        $Object,
        $Property
    )
    $MyObjects = $Object | Sort-Object -Property $Property -Unique
    return $MyObjects
}