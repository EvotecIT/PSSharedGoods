function Join-UriQuery {
    <#
    .SYNOPSIS
    Provides ability to join two Url paths together including advanced querying

    .DESCRIPTION
    Provides ability to join two Url paths together including advanced querying which is useful for RestAPI/GraphApi calls

    .PARAMETER BaseUri
    Primary Url to merge

    .PARAMETER RelativeOrAbsoluteUri
    Additional path to merge with primary url (optional)

    .PARAMETER QueryParameter
    Parameters and their values in form of hashtable

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts' -QueryParameter @{
        page     = 1
        per_page = 20
        search   = 'SearchString'
    }

    .NOTES
    General notes
    #>
    [alias('Join-UrlQuery')]
    [CmdletBinding()]
    param (
        [parameter(Mandatory)][uri] $BaseUri,
        [parameter(Mandatory = $false)][uri] $RelativeOrAbsoluteUri,
        [Parameter(Mandatory)][System.Collections.IDictionary] $QueryParameter
    )
    # Join primary url with additional path if needed
    if ($BaseUri -and $RelativeOrAbsoluteUri) {
        $Url = Join-Uri -BaseUri $BaseUri -RelativeOrAbsoluteUri $RelativeOrAbsoluteUri
    } else {
        $Url = $PrimaryUrl
    }

    # Create a http name value collection from an empty string
    $Collection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    foreach ($key in $QueryParameter.Keys) {
        $Collection.Add($key, $QueryParameter.$key)
    }

    # Build the uri
    $uriRequest = [System.UriBuilder] $Url
    $uriRequest.Query = $Collection.ToString()
    #return $uriRequest.Uri.OriginalUri
    return $uriRequest.Uri.AbsoluteUri
}