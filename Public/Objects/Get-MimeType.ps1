function Get-MimeType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string] $FileName
	)

	$MimeMappings = @{
		'.jpeg' = 'image/jpeg'
		'.jpg'  = 'image/jpeg'
		'.png'  = 'image/png'
	}

	$Extension = [System.IO.Path]::GetExtension( $FileName )
	$ContentType = $MimeMappings[ $Extension ]

	if ([string]::IsNullOrEmpty($ContentType)) {
		return New-Object System.Net.Mime.ContentType
	} else {
		return New-Object System.Net.Mime.ContentType($ContentType)
	}
}