function Format-AddSpaceToSentence {
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

    Format-AddSpaceToSentence -Text $Test

    $Test | Format-AddSpaceToSentence -ToLowerCase

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0)][string[]] $Text,
        [switch] $ToLowerCase
    )
    Begin { }
    Process {
        $Value = foreach ($T in $Text) {
            ($T -creplace '([A-Z\W_]|\d+)(?<![a-z])', ' $&').trim()
        }
        if ($ToLowerCase) {
            $Value.ToLower()
        } else {
            $Value
        }
    }
    End {

    }
}