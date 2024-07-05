function ConvertFrom-Color {
    <#
    .SYNOPSIS
    Converts color names or hex codes to different formats.

    .DESCRIPTION
    ConvertFrom-Color function converts color names or hex codes to different formats such as decimal values or System.Drawing.Color objects.

    .PARAMETER Color
    Specifies the color names or hex codes to convert.

    .PARAMETER AsDecimal
    Indicates whether to convert the color to a decimal value.

    .PARAMETER AsDrawingColor
    Indicates whether to convert the color to a System.Drawing.Color object.

    .EXAMPLE
    ConvertFrom-Color -Color Red, Blue -AsDecimal
    Converts the colors Red and Blue to decimal values.

    .EXAMPLE
    ConvertFrom-Color -Color "#FFA500" -AsDrawingColor
    Converts the color with hex code #FFA500 to a System.Drawing.Color object.

    #>
    [alias('Convert-FromColor')]
    [CmdletBinding()]
    param (
        [ValidateScript( {
                if ($($_ -in $Script:RGBColors.Keys -or $_ -match "^#([A-Fa-f0-9]{6})$" -or $_ -eq "") -eq $false) {
                    throw "The Input value is not a valid colorname nor an valid color hex code."
                } else { $true }
            })]
        [alias('Colors')][string[]] $Color,
        [switch] $AsDecimal,
        [switch] $AsDrawingColor
    )
    $Colors = foreach ($C in $Color) {
        $Value = $Script:RGBColors."$C"
        if ($C -match "^#([A-Fa-f0-9]{6})$") {
            $C
            continue
        }
        if ($null -eq $Value) {
            continue
        }
        $HexValue = Convert-Color -RGB $Value
        Write-Verbose "Convert-FromColor - Color Name: $C Value: $Value HexValue: $HexValue"
        if ($AsDecimal) {
            [Convert]::ToInt64($HexValue, 16)
        } elseif ($AsDrawingColor) {
            [System.Drawing.Color]::FromArgb("#$($HexValue)")
        } else {
            "#$($HexValue)"
        }
    }
    $Colors
}
$ScriptBlockColors = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Script:RGBColors.Keys | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName ConvertFrom-Color -ParameterName Color -ScriptBlock $ScriptBlockColors