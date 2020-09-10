function ConvertTo-StringByType {
    <#
    .SYNOPSIS
    Private function to use within ConvertTo-JsonLiteral

    .DESCRIPTION
    Private function to use within ConvertTo-JsonLiteral

    .PARAMETER Value
    Value

    .PARAMETER DateTimeFormat
    Format to use when converting DateTime to string

    .EXAMPLE
    $Value = ConvertTo-StringByType -Value $($Object[$a][$i]) -DateTimeFormat $DateTimeFormat

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [Object] $Value,
        [string] $DateTimeFormat
    )
    if ($null -eq $Value ) {
        ''
    } elseif ($Value -is [DateTime]) {
        $($Value).ToString($DateTimeFormat)
    } else {
        try {
            [System.Text.RegularExpressions.Regex]::Unescape($Value)
        } catch {
            $Value.Replace('\', "\\")
        }
    }
}