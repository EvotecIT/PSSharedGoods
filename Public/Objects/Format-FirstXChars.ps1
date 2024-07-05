function Format-FirstXChars {
    <#
    .SYNOPSIS
    This function returns the first X characters of a given text string.

    .DESCRIPTION
    The Format-FirstXChars function takes a text string and a number of characters as input and returns the first X characters of the text string.

    .PARAMETER Text
    The input text string from which the first X characters will be extracted.

    .PARAMETER NumberChars
    The number of characters to extract from the beginning of the input text string.

    .EXAMPLE
    Format-FirstXChars -Text "VERBOSE: Loading module from path 'C:\Users\pklys\.vscode\extensions\ms-vs" -NumberChars 15
    # Returns: VERBOSE: Loading

    .NOTES
    This function is useful for truncating long text strings to a specific length.
    #>
    param(
        [string] $Text,
        [int] $NumberChars
    )
    return ($Text.ToCharArray() | Select-Object -First $NumberChars) -join ''
}