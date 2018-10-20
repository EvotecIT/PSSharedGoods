function Set-EmailBodyTableReplacement($Body, $TableName, $TableData) {
    $TableData = $TableData | ConvertTo-Html -Fragment | Out-String
    $Body = $Body -replace "<<$TableName>>", $TableData
    return $Body
}