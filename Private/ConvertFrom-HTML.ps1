function ConvertFrom-HTML {
    <#
    .SYNOPSIS
    Converts HTML strings to plain text.

    .DESCRIPTION
    This function converts HTML strings to plain text. It can also remove HTML tags if specified.

    .PARAMETER HTML
    Specifies the HTML strings to convert.

    .PARAMETER RemoveTags
    Indicates whether to remove HTML tags from the input HTML strings.

    .EXAMPLE
    ConvertFrom-HTML -HTML "<p>Hello, <b>World</b>!</p>" -RemoveTags
    This example converts the HTML string "<p>Hello, <b>World</b>!</p>" to plain text and removes the HTML tags.

    #>
    [alias('Convert-HTMLToString')]
    [CmdletBinding()]
    param(
        [string[]] $HTML,
        [switch] $RemoveTags
    )
    foreach ($H in $HTML) {
        if ($RemoveTags) {
            # this removes things like between brackets like </p>  or <p>
            $H = $H -replace '<[^>]+>', ''
        }
        # This replaces chars to their clean equivalent
        $H -replace '&#8220;', '"' -replace '&#8217;', "'" -replace '&#8221;', '"' -replace '&#8230;', '...' -replace '&#8212;', '-' -replace '&#8211;', '-'
    }
}