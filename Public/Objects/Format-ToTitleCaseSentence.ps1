function Format-ToTitleCaseSentence {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Text
    Parameter description

    .EXAMPLE

    $test = @(
        'OnceUponATime',
        'OnceUponATime1',
        'Money@Risk',
        'OnceUponATime123',
        'AHappyMan2014'
        'OnceUponATime_123'
    )

    Format-ToTitleCaseSentence -Text $Test
    $Test | Format-ToTitleCaseSentence

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)][string[]] $Text
    )
    Begin {}
    Process {
        foreach ($T in $Text) {
            ($T -creplace '([A-Z\W_]|\d+)(?<![a-z])', ' $&').trim()
        }
    }
    End {

    }
}
