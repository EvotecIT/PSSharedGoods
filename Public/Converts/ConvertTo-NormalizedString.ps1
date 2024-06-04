function ConvertTo-NormalizedString {
    <#
    .SYNOPSIS
    Converts a string to a normalized string

    .DESCRIPTION
    Converts a string to a normalized string

    .PARAMETER String
    The string to convert

    .EXAMPLE
    ConvertTo-NormalizedString -String "café"

    .EXAMPLE
    "café" | ConvertTo-NormalizedString

    .EXAMPLE
    ConvertTo-NormalizedString -String "café"
    "café" | ConvertTo-NormalizedString
    'Helène' | ConvertTo-NormalizedString
    "Przemysław Kłys and Helène" | ConvertTo-NormalizedString

    .EXAMPLE
    "äöüß" | ConvertTo-NormalizedString
    ConvertTo-NormalizedString -String "café"
    "café" | ConvertTo-NormalizedString
    'Helène' | ConvertTo-NormalizedString
    "Przemysław Kłys and Helène" | ConvertTo-NormalizedString
    "kłys" | ConvertTo-NormalizedString
    "ąęćśł" | ConvertTo-NormalizedString
    "Michael Roßbach" | ConvertTo-NormalizedString
    "öüóőúéáűí" | ConvertTo-NormalizedString
    "ß" | ConvertTo-NormalizedString
    "Un été de Raphaël" | ConvertTo-NormalizedString
    ("äâûê", "éèà", "ùçä") | ConvertTo-NormalizedString
    "Fore ðære mærðe…" | ConvertTo-NormalizedString
    "ABC-abc-ČŠŽ-čšž" | ConvertTo-NormalizedString
    "Æ×Þ°±ß…" | ConvertTo-NormalizedString

    .NOTES
    General notes
    #>#
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)][string[]] $String,
        [switch] $Simplify
    )
    Begin {
        $SpecialCasesGerman = @{
            [char] "ä" = "a"
            [char] "ö" = "o"
            [char] "ü" = "u"
            [char] "ß" = "ss"
            [char] "Ö" = "O"
            [char] "Ü" = "U"
            [char] "Ä" = "A"
        }
        $SpecialCasesGermanGramatical = @{
            [char] "ä" = "ae"
            [char] "ö" = "oe"
            [char] "ü" = "ue"
            [char] "ß" = "ss"
            [char] "Ö" = "Oe"
            [char] "Ü" = "Ue"
            [char] "Ä" = "Ae"
        }

        $SpecialCases = @{
            #[char]"Ä" = "A"
            #[char]"Ä" = "Ae"
            #[char]"Ö" = "Oe"
            #[char]"Ö" = "O"
            #[char]"Ü" = "Ue"
            #[char]"Ü" = "U"
            #[char]"ä" = "a"
            #[char]"ä" = "ae"
            #[char]"ö" = "oe"
            #[char]"ö" = "o"
            #[char]"ü" = "ue"
            #[char]"ü" = "u"
            #[char]'ß' = 'ss'
            [char]"ø" = "o"
            [char]"Ø" = "O"
            [char]"Å" = "A"
            [char]'ð' = 'd'
            [char]'Æ' = 'AE'
            [char]'æ' = 'ae'
            [char]'Þ' = 'TH'
            [char]'þ' = 'th'
            [char]'×' = 'X'
            [char]'°' = 'o'
            [char]'±' = 'p'
            [char]'ç' = 'c'
            [char]'Ç' = 'C'
            [char]"…" = "..."
            [char]"ï" = "i"
            [char]"Ï" = "I"
            [char]"ű" = "u"
            [char]"ő" = "o"
            [char]"á" = "a"
            [char]"é" = "e"
            [char]"í" = "i"
            [char]"ó" = "o"
            [char]"ú" = "u"
            [char]"ý" = "y"
            [char]"ĺ" = "l"
            [char]"ŕ" = "r"
            [char]"č" = "c"
            [char]"ď" = "d"
            [char]"ľ" = "l"
            [char]"ň" = "n"
            [char]"š" = "s"
            [char]"ť" = "t"
            [char]"ž" = "z"
            [char]"ô" = "o"
            [char]"ą" = "a"
            [char]"ę" = "e"
            [char]"è" = "e"
            [char]"ć" = "c"
            [char]"ś" = "s"
            [char]"ź" = "z"
            [char]"ł" = "l"
            [char]"ń" = "n"
            [char]"Ű" = "U"
            [char]"Ő" = "O"
            [char]"Á" = "A"
            [char]"É" = "E"
            [char]"Í" = "I"
            [char]"Ó" = "O"
            [char]"Ú" = "U"
            [char]"Ý" = "Y"
            [char]"Ĺ" = "L"
            [char]"Ŕ" = "R"
            [char]"Č" = "C"
            [char]"Ď" = "D"
            [char]"Ľ" = "L"
            [char]"Ň" = "N"
            [char]"Š" = "S"
            [char]"Ť" = "T"
            [char]"Ž" = "Z"
            [char]"Ô" = "O"
            [char]"Ą" = "A"
            [char]"Ę" = "E"
            [char]"Ć" = "C"
            [char]"Ś" = "S"
            [char]"Ź" = "Z"
            [char]"Ł" = "L"
            [char]"Ń" = "N"
            "_"       = " "
        }
    }
    Process {
        foreach ($S in $String) {
            # First replace special cases
            $sb = [System.Text.StringBuilder]::new()
            foreach ($Char in $S.ToCharArray()) {
                if ($Simplify -and $SpecialCasesGerman.ContainsKey($Char)) {
                    [void] $sb.Append($SpecialCasesGerman[$Char])
                } elseif ($SpecialCasesGermanGramatical.ContainsKey($Char)) {
                    [void] $sb.Append($SpecialCasesGermanGramatical[$Char])
                } elseif ($SpecialCases.ContainsKey($Char)) {
                    [void] $sb.Append($SpecialCases[$Char])
                } else {
                    [void] $sb.Append($Char)
                }
            }
            $S = $sb.ToString()
            # Then normalize the striing
            $normalizedString = $S.Normalize([System.Text.NormalizationForm]::FormD)
            # Remove diacritics
            $sb = [System.Text.StringBuilder]::new()
            for ($i = 0; $i -lt $normalizedString.Length; $i++) {
                $c = $normalizedString[$i]
                if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
                    [void]$sb.Append($c)
                }
            }
            $S = $sb.ToString().Normalize([System.Text.NormalizationForm]::FormC)
            # #replace diacritics, if anything is missing
            $sb = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($S))
            $sb
        }
    }
}