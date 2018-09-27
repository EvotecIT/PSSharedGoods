function Get-RandomPassword {
    param()
    $password = Get-RandomCharacters -length 4 -characters 'abcdefghiklmnoprstuvwxyz'
    $password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
    $password += Get-RandomCharacters -length 1 -characters '1234567890'
    #$password += Get-RandomCharacters -length 1 -characters '!$%()=?{@#'
    $password += Get-RandomCharacters -length 1 -characters '!$#'
    return $password
}
