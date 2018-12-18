function Get-RandomStringName {
    [cmdletbinding()]
    param(
        [int] $Size = 31,
        [switch] $ToLower
    )
    if ($ToLower) {
        return (-join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object {[char]$_})).ToLower()
    } else {
        return -join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object {[char]$_})
    }
}