function Convert-BinaryToHex {
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