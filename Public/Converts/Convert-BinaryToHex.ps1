function Convert-BinaryToHex {
    <#
    .SYNOPSIS
    Converts an array of binary numbers to hexadecimal format.

    .DESCRIPTION
    This function takes an array of binary numbers and converts them to hexadecimal format.

    .PARAMETER Binary
    Specifies the array of binary numbers to be converted to hexadecimal.

    .EXAMPLE
    Convert-BinaryToHex -Binary 1101 1010
    Converts the binary numbers 1101 and 1010 to hexadecimal format.

    .EXAMPLE
    1101 1010 | Convert-BinaryToHex
    Converts the binary numbers 1101 and 1010 piped into the function to hexadecimal format.
    #>
    param(
        [alias('Bin')]
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true)]
        [Byte[]]$Binary
    )
    if ($null -eq $Binary) {
        return
    }
    # assume pipeline input if we don't have an array (surely there must be a better way)
    if ($Binary.Length -eq 1) {
        $Binary = @($input)
    }
    $Return = -join ($Binary |  ForEach-Object { "{0:X2}" -f $_ })
    $Return
}