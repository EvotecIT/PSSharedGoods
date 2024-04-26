function Format-StringToSentence {
    <#
    .SYNOPSIS
    Formats a given string by adding spaces before uppercase letters, digits, and non-word characters.

    .DESCRIPTION
    The Format-AddSpaceToSentence function takes a string or an array of strings
    and adds a space before each uppercase letter, digit, and non-word character (excluding dots, spaces, and underscores).
    It also provides options to convert the string to lowercase, remove certain characters before or after the formatting, and remove double spaces.

    .PARAMETER Text
    The string or array of strings to be formatted.

    .PARAMETER RemoveCharsBefore
    An array of characters to be removed from the string before the formatting is applied.

    .PARAMETER RemoveCharsAfter
    An array of characters to be removed from the string after the formatting is applied.

    .PARAMETER ToLowerCase
    If this switch is present, the function will convert the string to lowercase.

    .PARAMETER RemoveDoubleSpaces
    If this switch is present, the function will remove any double spaces from the string.

    .PARAMETER MakeWordsUpperCase
    An array of words that should be converted to uppercase after the formatting is applied.

    .PARAMETER DisableAddingSpace
    If this switch is present, the function will not add spaces before uppercase letters, digits, and non-word characters.

    .EXAMPLE
    $test = @(
        'OnceUponATime',
        'OnceUponATime1',
        'Money@Risk',
        'OnceUponATime123',
        'AHappyMan2014'
        'OnceUponATime_123'
        'Domain test.com'
    )

    Format-StringToSentence -Text $Test -RemoveCharsAfter '_' -RemoveDoubleSpaces

    This example formats each string in the $test array, removes any underscores after the formatting, and removes any double spaces.

    .EXAMPLE
    $test = @(
        'OnceUponATime',
        'OnceUponATime1',
        'Money@Risk',
        'OnceUponATime123',
        'AHappyMan2014'
        'OnceUponATime_123'
        'Domain test.com'
    )

    $Test | Format-StringToSentence -ToLowerCase -RemoveCharsAfter '_' -RemoveDoubleSpaces

    This example does the same as the previous one, but also converts each string to lowercase.

    .EXAMPLE
    $test = @(
        'OnceUponATime',
        'OnceUponATime1',
        'Money@Risk',
        'OnceUponATime123',
        'AHappyMan2014'
        'OnceUponATime_123'
        'Domain test.com'
    )

    Format-StringToSentence -Text $Test -RemoveCharsAfter '_' -RemoveDoubleSpaces -MakeWordsUpperCase 'test.com', 'money'

    .NOTES
    The function uses the -creplace operator to add spaces, which is case-insensitive. Therefore, it will add spaces before both uppercase and lowercase letters if they are specified in the RemoveCharsBefore or RemoveCharsAfter parameters.
    #>
    [alias('Format-AddSpaceToSentence')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0)][string[]] $Text,
        [string[]] $RemoveCharsBefore,
        [string[]] $RemoveCharsAfter,
        [switch] $ToLowerCase,
        [switch] $RemoveDoubleSpaces,
        [string[]] $MakeWordsUpperCase,
        [switch] $DisableAddingSpace
    )
    Process {
        foreach ($T in $Text) {
            if ($RemoveCharsBefore) {
                foreach ($R in $RemoveCharsBefore) {
                    $T = $T -ireplace [regex]::Escape($R), ""
                }
            }
            if (-not $DisableAddingSpace) {
                $T = $T -creplace '([A-Z]|[^a-zA-Z0-9_.\s]|_|\d+)(?<![a-z])', ' $&'
            }
            if ($ToLowerCase) {
                $T = $T.ToLower()
            }
            if ($RemoveCharsAfter) {
                foreach ($R in $RemoveCharsAfter) {
                    $T = $T -ireplace [regex]::Escape($R), ""
                }
            }
            if ($RemoveDoubleSpaces) {
                $T = $T -creplace '\s+', ' '
            }
            if ($MakeWordsUpperCase) {
                foreach ($W in $MakeWordsUpperCase) {
                    $T = $T -ireplace [regex]::Escape($W), $W.ToUpper()

                }
            }
            $T.Trim()
        }
    }
}