function ConvertFrom-HTML {
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