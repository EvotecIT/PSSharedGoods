function Get-MimeType {
	<#
	.SYNOPSIS
	Get-MimeType function returns the MIME type of a file based on its extension.

	.DESCRIPTION
	This function takes a file name as input and returns the corresponding MIME type based on the file extension.

	.PARAMETER FileName
	Specifies the name of the file for which the MIME type needs to be determined.

	.EXAMPLE
	Get-MimeType -FileName "example.jpg"
	Returns "image/jpeg" as the MIME type for the file "example.jpg".

	.EXAMPLE
	Get-MimeType -FileName "example.png"
	Returns "image/png" as the MIME type for the file "example.png".
	#>
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