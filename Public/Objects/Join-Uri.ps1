function Join-Uri {
    <#
    .SYNOPSIS
    Provides ability to join two Url paths together

    .DESCRIPTION
    Provides ability to join two Url paths together

    .PARAMETER BaseUri
    Primary Url to merge

    .PARAMETER RelativeOrAbsoluteUri
    Additional path to merge with primary url

    .EXAMPLE
    Join-Uri 'https://evotec.xyz/' '/wp-json/wp/v2/posts'

    .EXAMPLE
    Join-Uri 'https://evotec.xyz/' 'wp-json/wp/v2/posts'

    .EXAMPLE
    Join-Uri -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'

    .EXAMPLE
    Join-Uri -BaseUri 'https://evotec.xyz/test/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'

    .NOTES
    General notes
    #>
    [alias('Join-Url')]
    [cmdletBinding()]
    param(
        [parameter(Mandatory)][uri] $BaseUri,
        [parameter(Mandatory)][uri] $RelativeOrAbsoluteUri
    )

    return ($BaseUri.OriginalString.TrimEnd('/') + "/" + $RelativeOrAbsoluteUri.OriginalString.TrimStart('/'))
    #return [Uri]::new([Uri]::new($BaseUri), $RelativeOrAbsoluteUri).ToString()
    #return [Uri]::new($BaseUri.OriginalString, $RelativeOrAbsoluteUri).ToString()
}