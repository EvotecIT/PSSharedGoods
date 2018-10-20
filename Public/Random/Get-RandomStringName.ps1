function Get-RandomStringName {
    param(
        $Size = 10
    )
    return -join ((48..57) + (97..122) | Get-Random -Count 31 | % {[char]$_})
}