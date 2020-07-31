function Format-ToTitleCase {
    <#
    .SYNOPSIS
    Formats string or number of strings to Title Case

    .DESCRIPTION
    Formats string or number of strings to Title Case allowing for prettty display

    .PARAMETER Text
    Sentence or multiple sentences to format

    .PARAMETER RemoveWhiteSpace
    Removes spaces after formatting string to Title Case.

    .EXAMPLE
    Format-ToTitleCase 'me'

    Output:
    Me

    .EXAMPLE
    'me i feel good' | Format-ToTitleCase

    Output:
    Me I Feel Good
    Not Feel

    .EXAMPLE
    'me i feel', 'not feel' | Format-ToTitleCase

    Output:
    Me I Feel Good
    Not Feel

    .EXAMPLE
    Format-ToTitleCase -Text 'This is my thing' -RemoveWhiteSpace

    Output:
    ThisIsMyThing

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)][string[]] $Text,
        [switch] $RemoveWhiteSpace
    )
    Begin {}
    Process {
        $Conversion = foreach ($T in $Text) {
            if ($RemoveWhiteSpace) {
                (Get-Culture).TextInfo.ToTitleCase($T) -replace ' ', ''
            } else {
                (Get-Culture).TextInfo.ToTitleCase($T)
            }
        }
    }
    End {
        return $Conversion
    }
}