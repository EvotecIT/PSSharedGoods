function Convert-BinaryToIP {
    <#
    .SYNOPSIS
    Converts a binary string to an IP address format.

    .DESCRIPTION
    This function takes a binary string as input and converts it to an IP address format. The binary string must be evenly divisible by 8.

    .PARAMETER Binary
    The binary string to convert to an IP address format.

    .EXAMPLE
    Convert-BinaryToIP -Binary "01000001000000100000000100000001"
    Output: 65.0.1.1
    #>
    [cmdletBinding()]
    param(
        [string] $Binary
    )
    $Binary = $Binary -replace '\s+'
    if ($Binary.Length % 8) {
        Write-Warning -Message "Convert-BinaryToIP - Binary string '$Binary' is not evenly divisible by 8."
        return $Null
    }
    [int] $NumberOfBytes = $Binary.Length / 8
    $Bytes = @(foreach ($i in 0..($NumberOfBytes - 1)) {
            try {
                #$Bytes += # skipping this and collecting "outside" seems to make it like 10 % faster
                [System.Convert]::ToByte($Binary.Substring(($i * 8), 8), 2)
            } catch {
                Write-Warning -Message "Convert-BinaryToIP - Error converting '$Binary' to bytes. `$i was $i."
                return $Null
            }
        })
    return $Bytes -join '.'
}