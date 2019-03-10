function Get-RandomStringName {
    [cmdletbinding()]
    param(
        [int] $Size = 31,
        [switch] $ToLower,
        [switch] $ToUpper,
        [switch] $LettersOnly
    )
    [string] $MyValue = @(
        if ($LettersOnly) {
            ( -join ((1..$Size) | % {(65..90) + (97..122) | Get-Random} | % {[char]$_}))
        } else {
            ( -join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object {[char]$_}))
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