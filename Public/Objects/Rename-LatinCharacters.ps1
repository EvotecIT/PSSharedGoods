Function Rename-LatinCharacters {
    [alias('Remove-StringLatinCharacters')]
    param (
        [string]$String
    )
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}