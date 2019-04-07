function Get-RandomPassword {
    [cmdletbinding()]
    param(
        [int] $LettersLowerCase = 4,
        [int] $LettersHigherCase = 2,
        [int] $Numbers = 1,
        [int] $SpecialChars = 0,
        [int] $SpecialCharsLimited = 1
    )
    $Password = @(
        Get-RandomCharacters -length $LettersLowerCase -characters 'abcdefghiklmnoprstuvwxyz'
        Get-RandomCharacters -length $LettersHigherCase -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
        Get-RandomCharacters -length $Numbers -characters '1234567890'
        Get-RandomCharacters -length $SpecialChars -characters '!$%()=?{@#'
        Get-RandomCharacters -length $SpecialCharsLimited -characters '!$#'
    )
    return $Password -join ''
}