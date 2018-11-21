function Convert-BinaryToHex {
	param(
        [alias('Bin')][Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)][Byte[]]$Binary
    )
	# assume pipeline input if we don't have an array (surely there must be a better way)
	if ($Binary.Length -eq 1) {
        $Binary = @($input)
    }
	$Return = -join ($Binary |  foreach { "{0:X2}" -f $_ })
	Write-Output $Return
}