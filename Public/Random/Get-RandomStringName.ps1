function Get-RandomStringName {
    <#
    .SYNOPSIS
    Generates a random string of specified length with various options.

    .DESCRIPTION
    This function generates a random string of specified length with options to convert the case and include only letters.

    .PARAMETER Size
    The length of the random string to generate. Default is 31.

    .PARAMETER ToLower
    Convert the generated string to lowercase.

    .PARAMETER ToUpper
    Convert the generated string to uppercase.

    .PARAMETER LettersOnly
    Generate a random string with only letters.

    .EXAMPLE
    Get-RandomStringName -Size 10
    Generates a random string of length 10.

    .EXAMPLE
    Get-RandomStringName -Size 8 -ToLower
    Generates a random string of length 8 and converts it to lowercase.

    .EXAMPLE
    Get-RandomStringName -Size 12 -ToUpper
    Generates a random string of length 12 and converts it to uppercase.

    .EXAMPLE
    Get-RandomStringName -Size 15 -LettersOnly
    Generates a random string of length 15 with only letters.

    #>
    [cmdletbinding()]
    param(
        [int] $Size = 31,
        [switch] $ToLower,
        [switch] $ToUpper,
        [switch] $LettersOnly
    )
    [string] $MyValue = @(
        if ($LettersOnly) {
            ( -join ((1..$Size) | ForEach-Object { (65..90) + (97..122) | Get-Random } | ForEach-Object { [char]$_ }))
        } else {
            ( -join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object { [char]$_ }))
        }
    )
    if ($ToLower) {
        return $MyValue.ToLower()
    }
    if ($ToUpper) {
        return $MyValue.ToUpper()
    }
    return $MyValue
}