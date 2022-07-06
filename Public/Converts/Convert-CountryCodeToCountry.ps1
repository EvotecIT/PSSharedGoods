function Convert-CountryCodeToCountry {
    <#
    .SYNOPSIS
    Converts a country code to a country name, or when used with a switch to full culture information

    .DESCRIPTION
    Converts a country code to a country name, or when used with a switch to full culture information

    .PARAMETER CountryCode
    Country code

    .PARAMETER All
    Provide full culture information rather than just the country name

    .EXAMPLE
    Convert-CountryCodeToCountry -CountryCode 'PL'

    .EXAMPLE
    Convert-CountryCodeToCountry -CountryCode 'PL' -All

    .EXAMPLE
    $Test = Convert-CountryCodeToCountry
    $Test['PL']['Culture'] | fl
    $Test['PL']['RegionInformation']

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [string] $CountryCode,
        [switch] $All
    )
    $QuickSearch = [ordered] @{}
    $AllCultures = [cultureinfo]::GetCultures([System.Globalization.CultureTypes]::SpecificCultures)
    foreach ($Culture in $AllCultures) {
        $RegionInformation = [System.Globalization.RegionInfo]::new($Culture.LCID)
        $QuickSearch[$RegionInformation.Name] = @{
            'Culture'           = $Culture
            'RegionInformation' = $RegionInformation
        }
    }
    if ($CountryCode) {
        if ($All) {
            $QuickSearch[$CountryCode]
        } else {
            $QuickSearch[$CountryCode].RegionInformation.EnglishName
        }
    } else {
        $QuickSearch
    }
}