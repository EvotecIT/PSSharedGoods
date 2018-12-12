function Format-FirstXChars {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Text
    Parameter description

    .PARAMETER NumberChars
    Parameter description

    .EXAMPLE
    Format-FirstChars -Text "VERBOSE: Loading module from path 'C:\Users\pklys\.vscode\extensions\ms-vs" -NumberChars 15

    .NOTES
    General notes
    #>

    param(
        [string] $Text,
        [int] $NumberChars
    )
    return ($Text.ToCharArray() | Select-Object -First $NumberChars) -join ''
}