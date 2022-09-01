Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Convert-CountryToCountryCode -CountryName 'VIETNAM'
Convert-CountryToCountryCode -CountryName 'KOREA'
Convert-CountryToCountryCode -CountryName 'CZECH REPUBLIC'
Convert-CountryToCountryCode -CountryName 'VIET NAM'

Convert-CountryCodeToCountry 'VN'
Convert-CountryCodeToCountry 'KR'
Convert-CountryCodeToCountry 'CZ'
Convert-CountryCodeToCountry 'VN'