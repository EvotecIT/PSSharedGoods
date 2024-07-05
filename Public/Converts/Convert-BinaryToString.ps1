function Convert-BinaryToString {
    <#
    .SYNOPSIS
    Converts an array of binary numbers to a string.

    .DESCRIPTION
    This function takes an array of binary numbers and converts them to a string using Unicode encoding.

    .PARAMETER Binary
    Specifies the array of binary numbers to be converted to a string.

    .EXAMPLE
    Convert-BinaryToString -Binary 01001000 01100101 01101100 01101100 01101111
    Converts the binary numbers to the string "Hello".

    .EXAMPLE
    01001000 01100101 01101100 01101100 01101111 | Convert-BinaryToString
    Converts the binary numbers piped into the function to the string "Hello".
    #>
    param(
        [alias('Bin')]
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true)]
        [Byte[]]$Binary
    )
    if ($null -ne $Binary) {
        [System.Text.Encoding]::Unicode.GetString($Binary)
    }
}