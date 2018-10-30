function Convert-ExchangeItems {
    [cmdletbinding()]
    param(
        $Count,
        [string] $Default = 'N/A'
    )
    if ($null -eq $Count) {
        return $Default
    } else {
        return $Count
    }
}