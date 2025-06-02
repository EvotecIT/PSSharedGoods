function ConvertFrom-Color {
    <#
    .SYNOPSIS
    Converts color names or hex codes to different formats.

    .DESCRIPTION
    ConvertFrom-Color function converts color names or hex codes to different formats such as decimal values or System.Drawing.Color objects.
    Enhanced to support 3-character hex codes and rgba() format in addition to 6-character hex and named colors.

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

    .EXAMPLE
    ConvertFrom-Color -Color "#f00"
    Converts the 3-character hex code #f00 to #ff0000.

    .EXAMPLE
    ConvertFrom-Color -Color "rgba(255, 0, 0, 0.5)"
    Passes through rgba format as-is.

    #>
    [alias('Convert-FromColor')]
    [CmdletBinding()]
    param (
        [ValidateScript( {
                # Enhanced validation to support 3-char hex, 6-char hex, rgba, and named colors
                if ($($_ -in $Script:RGBColors.Keys -or
                        $_ -match "^#([A-Fa-f0-9]{6})$" -or
                        $_ -match "^#([A-Fa-f0-9]{3})$" -or
                        $_ -match "^rgba\s*\(" -or
                        $_ -eq "") -eq $false) {
                    throw "The Input value is not a valid colorname, hex code (3 or 6 chars), or rgba format."
                } else { $true }
            })]
        [Parameter(Position = 0)][alias('Colors')][string[]] $Color,
        [switch] $AsDecimal,
        [switch] $AsDrawingColor
    )
    $Colors = foreach ($C in $Color) {
        # Handle rgba() format - pass through as-is
        if ($C -match "^rgba\s*\(") {
            $C
            continue
        }

        # Handle 3-character hex codes - expand to 6 characters
        if ($C -match "^#([A-Fa-f0-9]{3})$") {
            $hex = $C.Substring(1)
            $expandedHex = "#$($hex[0])$($hex[0])$($hex[1])$($hex[1])$($hex[2])$($hex[2])"
            if ($AsDecimal) {
                [Convert]::ToInt64($expandedHex.Substring(1), 16)
            } elseif ($AsDrawingColor) {
                [System.Drawing.Color]::FromArgb($expandedHex)
            } else {
                $expandedHex
            }
            continue
        }

        # Handle 6-character hex codes
        if ($C -match "^#([A-Fa-f0-9]{6})$") {
            if ($AsDecimal) {
                [Convert]::ToInt64($C.Substring(1), 16)
            } elseif ($AsDrawingColor) {
                [System.Drawing.Color]::FromArgb($C)
            } else {
                $C
            }
            continue
        }

        # Handle named colors
        $Value = $Script:RGBColors."$C"
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