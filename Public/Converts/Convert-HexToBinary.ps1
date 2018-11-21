function Convert-HexToBinary {
	param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] [string] $Hex
    )
	$return = @()

	for ($i = 0; $i -lt $Hex.Length ; $i += 2)
	{
		$return += [Byte]::Parse($Hex.Substring($i, 2), [System.Globalization.NumberStyles]::HexNumber)
	}

	Write-Output $return
}