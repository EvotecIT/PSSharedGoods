function Get-RandomPassword {
    <#
    .SYNOPSIS
    Generates a random password with a specified number of lowercase letters, uppercase letters, numbers, and special characters.

    .DESCRIPTION
    This function generates a random password with a customizable combination of lowercase letters, uppercase letters, numbers, and special characters.

    .PARAMETER LettersLowerCase
    Specifies the number of lowercase letters to include in the password.

    .PARAMETER LettersHigherCase
    Specifies the number of uppercase letters to include in the password.

    .PARAMETER Numbers
    Specifies the number of numbers to include in the password.

    .PARAMETER SpecialChars
    Specifies the number of special characters to include in the password.

    .PARAMETER SpecialCharsLimited
    Specifies the number of limited special characters to include in the password.

    .EXAMPLE
    Get-RandomPassword -LettersLowerCase 4 -LettersHigherCase 2 -Numbers 1 -SpecialChars 0 -SpecialCharsLimited 1
    Generates a random password with 4 lowercase letters, 2 uppercase letters, 1 number, and 1 limited special character.

    .EXAMPLE
    Get-RandomPassword -LettersLowerCase 3 -LettersHigherCase 3 -Numbers 2 -SpecialChars 2 -SpecialCharsLimited 1
    Generates a random password with 3 lowercase letters, 3 uppercase letters, 2 numbers, 2 special characters, and 1 limited special character.
    #>
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
    $StringPassword = $Password -join ''
    $StringPassword = ($StringPassword.ToCharArray() | Get-Random -Count $StringPassword.Length) -join ''
    return $StringPassword
}
