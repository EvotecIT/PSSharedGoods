Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Convert-CountryToCountryCode -CountryName 'Poland'
Convert-CountryToCountryCode -CountryName 'India'
Convert-CountryCodeToCountry -CountryCode 'PL'
Convert-CountryCodeToCountry -CountryCode 'POL'