function Convert-ExchangeItems {
    <#
    .SYNOPSIS
    Converts the count of Exchange items to a specified default value if the count is null.

    .DESCRIPTION
    This function takes the count of Exchange items and returns the count if it is not null. If the count is null, it returns the specified default value.

    .PARAMETER Count
    The count of Exchange items to be processed.

    .PARAMETER Default
    The default value to return if the count is null. Default is 'N/A'.

    .EXAMPLE
    Convert-ExchangeItems -Count 10 -Default 'No items'
    # Returns 10

    .EXAMPLE
    Convert-ExchangeItems -Count $null -Default 'No items'
    # Returns 'No items'

    .NOTES
    General notes
    #>
    [cmdletbinding()]
    param(
        [int] $Count,
        [string] $Default = 'N/A'
    )
    if ($null -eq $Count) {
        return $Default
    } else {
        return $Count
    }
}