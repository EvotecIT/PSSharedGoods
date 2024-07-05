function Convert-HexToBinary {
    <#
    .SYNOPSIS
    Converts a hexadecimal string to a binary representation.

    .DESCRIPTION
    This function takes a hexadecimal string as input and converts it to a binary representation.

    .PARAMETER Hex
    Specifies the hexadecimal string to convert to binary.

    .EXAMPLE
    Convert-HexToBinary -Hex "1A"
    # Outputs: 00011010

    .EXAMPLE
    "1A" | Convert-HexToBinary
    # Outputs: 00011010
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string] $Hex
    )
    $return = for ($i = 0; $i -lt $Hex.Length ; $i += 2) {
        [Byte]::Parse($Hex.Substring($i, 2), [System.Globalization.NumberStyles]::HexNumber)
    }
    Write-Output $return -NoEnumerate
}