function Set-EmailBodyReplacementTable {
    [CmdletBinding()]
    [alias('Set-EmailBodyTableReplacement')]
    param (
        [string] $Body,
        [string] $TableName,
        [Array] $TableData
    )
    $TableData = $TableData | ConvertTo-Html -Fragment | Out-String
    $Body = $Body -replace "<<$TableName>>", $TableData
    return $Body
}