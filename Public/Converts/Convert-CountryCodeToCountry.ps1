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

    .EXAMPLE
    Convert-CountryCodeToCountry -CountryCode 'PL'
    Convert-CountryCodeToCountry -CountryCode 'POL'

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [string] $CountryCode,
        [switch] $All
    )
    if ($Script:QuickSearch) {
        if ($PSBoundParameters.ContainsKey('CountryCode')) {
            if ($All) {
                $Script:QuickSearch[$CountryCode]
            } else {
                $Script:QuickSearch[$CountryCode].RegionInformation.EnglishName
            }
        } else {
            $Script:QuickSearch
        }
    } else {
        $Script:QuickSearch = [ordered] @{}
        $AllCultures = [cultureinfo]::GetCultures([System.Globalization.CultureTypes]::SpecificCultures)
        foreach ($Culture in $AllCultures) {

            $RegionInformation = [System.Globalization.RegionInfo]::new($Culture)
            $Script:QuickSearch[$RegionInformation.TwoLetterISORegionName] = @{
                'Culture'           = $Culture
                'RegionInformation' = $RegionInformation
            }
            $Script:QuickSearch[$RegionInformation.ThreeLetterISORegionName] = @{
                'Culture'           = $Culture
                'RegionInformation' = $RegionInformation
            }
        }
        if ($PSBoundParameters.ContainsKey('CountryCode')) {
            if ($All) {
                $Script:QuickSearch[$CountryCode]
            } else {
                $Script:QuickSearch[$CountryCode].RegionInformation.EnglishName
            }
        } else {
            $Script:QuickSearch
        }
    }
}