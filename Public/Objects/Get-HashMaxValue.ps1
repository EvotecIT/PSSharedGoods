function Get-HashMaxValue {
    [CmdletBinding()]
    param (
        [Object] $hashTable,
        [switch] $Lowest
    )
    if ($Lowest) {
        return ($hashTable.GetEnumerator() | Sort-Object value -Descending | Select-Object -Last 1).Value
    } else {
        return ($hashTable.GetEnumerator() | Sort-Object value -Descending | Select-Object -First 1).Value
    }
}