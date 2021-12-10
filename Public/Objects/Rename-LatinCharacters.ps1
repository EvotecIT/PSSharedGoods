Function Rename-LatinCharacters {
    <#
    .SYNOPSIS
    Renames a name to a name without special chars.

    .DESCRIPTION
    Renames a name to a name without special chars.

    .PARAMETER String
    Provide a string to rename

    .EXAMPLE
    Rename-LatinCharacters -String 'Przemysław Kłys'

    .EXAMPLE
    Rename-LatinCharacters -String 'Przemysław'

    .NOTES
    General notes
    #>
    [alias('Remove-StringLatinCharacters')]
    [cmdletBinding()]
    param(
        [string] $String
    )
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}