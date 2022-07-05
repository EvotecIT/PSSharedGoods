function Convert-CountryToCountryCode {
    <#
    .SYNOPSIS
    Converts a country name to a country code, or when used with a switch to full culture information

    .DESCRIPTION
    Converts a country name to a country code, or when used with a switch to full culture information

    .PARAMETER CountryName
    Country name in it's english name

    .PARAMETER All
    Provide full culture information rather than just the country code

    .EXAMPLE
    Convert-CountryToCountryCode -CountryName 'Poland'

    .EXAMPLE
    Convert-CountryToCountryCode -CountryName 'Poland' -All

    .EXAMPLE
    $Test = Convert-CountryToCountryCode
    $Test['Poland']['Culture']
    $Test['Poland']['RegionInformation']

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [string] $CountryName,
        [switch] $All
    )
    $QuickSearch = [ordered] @{}
    $AllCultures = [cultureinfo]::GetCultures([System.Globalization.CultureTypes]::SpecificCultures)
    foreach ($Culture in $AllCultures) {
        $RegionInformation = [System.Globalization.RegionInfo]::new($Culture.LCID)
        $QuickSearch[$RegionInformation.DisplayName] = @{
            'Culture'           = $Culture
            'RegionInformation' = $RegionInformation
        }
    }
    if ($CountryName) {
        if ($All) {
            $QuickSearch[$CountryName]
        } else {
            $QuickSearch[$CountryName].Culture.TwoLetterIsoLanguageName.ToUpper()
        }
    } else {
        $QuickSearch
    }
}



