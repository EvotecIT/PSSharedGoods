function Get-Colors {
    <#
    .SYNOPSIS
    Retrieves RGB color values based on the provided color names.

    .DESCRIPTION
    The Get-Colors function retrieves RGB color values from a predefined list based on the color names provided as input. If no color names are specified, it returns all available RGB color values.

    .PARAMETER Color
    Specifies an array of color names for which RGB values are to be retrieved.

    .EXAMPLE
    Get-Colors -Color "Red", "Green"
    Retrieves the RGB values for the colors Red and Green.

    .EXAMPLE
    Get-Colors
    Retrieves all available RGB color values.

    #>
    [CmdletBinding()]
    param(
        [string[]] $Color
    )
    if ($Color) {
        foreach ($_ in $Color) {
            $Script:RGBColors.$_
        }
    } else {
        return $Script:RGBColors
    }
}
$ScriptBlockColors = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Script:RGBColors.Keys | Where-Object { $_ -like "*$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName Get-Colors -ParameterName Color -ScriptBlock $ScriptBlockColors