function Get-RandomStringName {
    [cmdletbinding()]
    param(
        [int] $Size = 31,
        [switch] $ToLower,
        [switch] $LettersOnly
    )
    if ($ToLower) {
        if ($LettersOnly) {
            return (-join ((1..$Size) | % {(65..90) + (97..122) | Get-Random} | % {[char]$_})).ToLower()
        } else {
            return ( -join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object {[char]$_})).ToLower()
        }
    } else {
        if ($LettersOnly) {
            -join ((1..$Size) | % {(65..90) + (97..122) | Get-Random } | % {[char]$_})
        } else {
            return -join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object {[char]$_})
        }
    }
}