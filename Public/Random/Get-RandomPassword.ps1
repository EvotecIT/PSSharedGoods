function Get-RandomPassword {
    [cmdletbinding()]
    param(
        [int] $LettersLowerCase = 4,
        [int] $LettersHigherCase = 2,
        [int] $Numbers = 1,
        [int] $SpecialChars = 0,
        [int] $SpecialCharsLimited = 1
    )
    $password = Get-RandomCharacters -length $LettersLowerCase -characters 'abcdefghiklmnoprstuvwxyz'
    $password += Get-RandomCharacters -length $LettersHigherCase -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
    $password += Get-RandomCharacters -length $Numbers -characters '1234567890'
    $password += Get-RandomCharacters -length $SpecialChars -characters '!$%()=?{@#'
    $password += Get-RandomCharacters -length $SpecialCharsLimited -characters '!$#'
    return $password
}