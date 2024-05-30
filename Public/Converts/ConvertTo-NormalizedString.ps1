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

    .NOTES
    General notes
    #>#
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)][string[]] $String
    )
    Process {
        foreach ($S in $String) {
            $normalizedString = $S.Normalize([System.Text.NormalizationForm]::FormD)
            $sb = [System.Text.StringBuilder]::new()

            for ($i = 0; $i -lt $normalizedString.Length; $i++) {
                $c = $normalizedString[$i]
                if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
                    [void]$sb.Append($c)
                }
            }

            $sb.ToString().Normalize([System.Text.NormalizationForm]::FormC)
        }
    }
}