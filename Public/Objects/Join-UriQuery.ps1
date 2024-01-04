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

    .PARAMETER EscapeUriString
    If set, will escape the url string

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts' -QueryParameter @{
        page     = 1
        per_page = 20
        search   = 'SearchString'
    }

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz/wp-json/wp/v2/posts' -QueryParameter @{
        page     = 1
        per_page = 20
        search   = 'SearchString'
    }

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'

    .NOTES
    General notes
    #>
    [alias('Join-UrlQuery')]
    [CmdletBinding()]
    param (
        [parameter(Mandatory)][uri] $BaseUri,
        [parameter(Mandatory = $false)][uri] $RelativeOrAbsoluteUri,
        [Parameter()][System.Collections.IDictionary] $QueryParameter,
        [alias('EscapeUrlString')][switch] $EscapeUriString
    )
    Begin {
        Add-Type -AssemblyName System.Web
    }
    Process {
        # Join primary url with additional path if needed
        if ($BaseUri -and $RelativeOrAbsoluteUri) {
            $Url = Join-Uri -BaseUri $BaseUri -RelativeOrAbsoluteUri $RelativeOrAbsoluteUri
        } else {
            $Url = $BaseUri
        }

        # Create a http name value collection from an empty string
        if ($QueryParameter) {
            $Collection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
            foreach ($key in $QueryParameter.Keys) {
                $Collection.Add($key, $QueryParameter.$key)
            }
        }

        # Build the uri
        $uriRequest = [System.UriBuilder] $Url
        if ($Collection) {
            $uriRequest.Query = $Collection.ToString()
        }
        if (-not $EscapeUriString) {
            $uriRequest.Uri.AbsoluteUri
        } else {
            [System.Uri]::EscapeUriString($uriRequest.Uri.AbsoluteUri)
        }
    }
}