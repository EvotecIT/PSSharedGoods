#### 0.0.284 - 2024.04.09
- Improved `Get-ComputerInstalledUpdates` to support Credential parameter

#### 0.0.283 - 2024.04.09
- Added `Get-FileEncoding` to get file encoding

#### 0.0.282 - 2024.03.28
- Added `Convert-IpAddressToPtr` to convert IP Address to PTR record

#### 0.0.281 - 2024.03.25
- Improve `Get-ComputerWindowsUpdates`
- Added `Get-ComputerInstalledUpdates`

#### 0.0.280 - 2024.03.12
- Improve `Convert-Identity`
- Improve `ConvertFrom-SID`

#### 0.0.279 - 2024.03.12
- Improve `Convert-Identity`
- Improve `ConvertFrom-SID`

#### 0.0.278 - 2024.02.29
- Added `Get-ComputerMemory`
- Improved `Get-ComputerOperatingSystem`

#### 0.0.277 - 2024.02.13
- Added `Get-WinADDSAGuid` to get list of Domain Controllers and their DSA GUIDs/DSA Names
- Improved `Get-WinADForestDetails` to include `DSAGUID` and `DSANAME` for each DC

#### 0.0.276 - 2024.01.23
- Added `WindowsSecureTimeSeeding` to `Get-TimeSettings`

#### 0.0.275 - 2024.01.04
- Improved `Join-UriQuery`
- Improved `Get-ComputerSMBShareList`

#### 0.0.274 - 2023.12.21
- Improved `Get-ComputerSMBShareList` with ability to SkipDiskSpace

#### 0.0.273 - 2023.12.20
- Added `Get-ComputerSMBShareList` to get list of SMB Shares (`net view /all` replacement)

#### 0.0.271 - 2023.12.12
- Fixes `Get-WinADForestDetails` returning empty element for ForestDomainControllers in some cases

#### 0.0.270 - 2023.12.12
- Improve `Join-UriQuery`

#### 0.0.269 - 2023.11.22
- Small fixes to `ConvertTo-PrettyObject`
- Added tests for `ConvertTo-PrettyObject`

#### 0.0.268 - 2023.11.22
- Improved `Get-FileInformation` - added docs, and converted to PSCustomObject
- Added `ConvertTo-PrettyObject` as an alternative to `ConvertTo-JsonLiteral` for use in PSWriteHTML

#### 0.0.267 - 2023.10.28
- Added `Get-IPAddressRangeInformation`

#### 0.0.266 - 2023.09.16
- Update `Convert-Office365License` to support new licenses based on the website from Microsoft, rather than manual input

#### 0.0.265 - 2023.08.22
- Update `Copy-Dictionary` to support PS7.4 which disables BinaryFormatter by default (breaking change - the output may be different a bit)
- Update `Get-GitHubLatestRelease` fixes a typo
- Update `Get-GitHubVersion` to return unknown value
- Added `Format-Dictionary` to sort hashtable by key or by value

#### 0.0.264 - 2023.05.23
- Improve `ConvertTo-OperatingSystem`

#### 0.0.263 - 2023.05.08
- Improve `Select-Properties` null handling

#### 0.0.262 - 2023.05.03
- Improves handling of null in `Convert-CountryCodeToCountry`
- Remove `ReturnHashtable`  in `Convert-CountryToContinent` changing the behavior to always return hashtable of continents if country is not given

#### 0.0.261 - 2023.04.23
- Adds `Convert-CountryToContinent`

#### 0.0.260 - 2023.04.18
- Adds support for `HKUDUO` and `HKUDUDO` for `Get-PSRegistry`, `Set-PSRegistry`, `Remove-PSRegistry`, `New-PSRegistry` and `Test-PSRegistry`
  - `HKUDUO` - All users in HKEY_USERS that are non SPECIAL accounts excluding .DEFAULT / .DEFAULT_USER (auto mapped from NTUSER.DAT). But also including non-loaded users (not logged in) (auto mapped from NTUSER.DAT)
  - `HKUDUDO` - All users in HKEY_USERS that are non SPECIAL accounts including .DEFAULT_USER (auto mapped from NTUSER.DAT). But also including non-loaded users (not logged in) (auto mapped from NTUSER.DAT)
  - Improve `Get-WinADForestDetails` by adding switch `PreferWritable` which would use writable DCs for quering

#### 0.0.259 - 2023.03.08
- Improve `Get-ComputerSMBSharePermissions` with `Translated` switch
- Improve `Get-ComputerSMBShare` with `Translated` switch

#### 0.0.258 - 2023.02.04
- Fixes `ConvertFrom-SID` value for `NT AUTHORITY\LOCAL SERVICE`

#### 0.0.257 - 2023.01.15
- `ConvertFrom-HTML` removed (well moved to Private until final removal)

#### 0.0.256 - 2023.01.14
- Added more licenses/service plans `Convert-Office365License`
- Enhance generated string in `ConvertFrom-ObjectToString` by @danubie
- Removed dependency on `Connectimo` (moved one function), archived Connectimo repo

#### 0.0.255 - 2023.01.08
- Add `Get-GitHubVersion`

#### 0.0.254 - 2022.12.20
- Update Get-WinADForestControllers.ps1 by @ferwe in https://github.com/EvotecIT/PSSharedGoods/pull/32
- Added `Force` to Convert-Identity to clear cache when doing lots of lookups and creatiing new objects
- Improves `Convert-ADGuidToSchema`
- Improves `Convert-ADSchemaToGuidd`
- Improves `Convert-Identity`

#### 0.0.253 - 2022.12.14
- Fixes `ConvertFrom-SID` fixing one SID returning wrong value
- Improves `Convert-ADGuidToSchema`
- Improves `Convert-ADSchemaToGuidd`
- Improves `Get-WinADForestOptions`
- Improves `Get-WinADForestControllers` by @ferwe

#### 0.0.252 - 2022.11.20
- Updated `Convert-ExchangeRecipient`
- Removed `Convert-Convert-ExchangeRecipientDetails` (added as an alias to `Convert-ExchangeRecipient`)

#### 0.0.251 - 2022.11.07
- Fixes private function `Get-LocalComputerSid` solving [#34](https://github.com/EvotecIT/GPOZaurr/issues/34)

#### 0.0.250 - 2022.11.05
- Fixes `ConvertFrom-DistinguishedName` when using `ToCanonicalName` for domain name

#### 0.0.249 - 2022.11.01
- Improve `ConvertFrom-DistinguishedName` to allow `ToCanonicalName`

```powershell
ConvertFrom-DistinguishedName -DistinguishedName 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
ConvertFrom-DistinguishedName -DistinguishedName 'CN=test,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' -ToCanonicalName
```

#### 0.0.248 - 2022.10.24
- Added `ConvertFrom-ObjectToString` to help with converting objects into

#### 0.0.247 - 2022.10.05
- `Convert-ADSchemaToGuid` improved by adding `AsString`. By default returns Guid, but can return string.

#### 0.0.246 - 2022.09.19
- Fixes `Split-Array` in some rare cases

#### 0.0.245 - 2022.09.19
- Fixes `Split-Array` when there's a single array
#### 0.0.244 - 2022.09.19
- Improved `Split-Array`
- Removed `Split-ArrayEvery`

#### 0.0.243 - 2022.09.18
- Added `Convert-ADSchemaToGuid` and `Convert-ADGuidToSchema`
- Renamed `Get-WinADForestGUIDs` to `Convert-ADGuidToSchema`

#### 0.0.242 - 2022.09.01
- Adds some countries `Convert-CountryToCountryCode` and `Convert-CountryCodeToCountry` with some haardcoding

#### 0.0.241 - 2022.09.01
- Fixes `Convert-CountryToCountryCode` and `Convert-CountryCodeToCountry` for PS7
- Improved `Convert-CountryCodeToCountry` for 3 letter codes

#### 0.0.239 - 2022.08.31
- Improved `Convert-CountryToCountryCode` and `Convert-CountryCodeToCountry` by using cache for frequest queries

#### 0.0.238 - 2022.08.31
- Improved `Convert-CountryToCountryCode` to resolve country names to country codes from NativeName, DisplayName and ThreeLetterISORegionName as an addition to EnglishName

#### 0.0.237 - 2022.08.18
- Improved `ConvertTo-Json` to handle ArrayJoin feature for nested objects

#### 0.0.236 - 2022.08.14
- Improved `Convert-Identity` and `ConvertFrom-SID` - faster lookup for SIDs that are less than 19 chars

#### 0.0.236 - 2022.08.14
- Improved `Convert-Identity` and `ConvertFrom-SID` - faster lookup for `BUILTIN\IIS_IUSRS`

#### 0.0.235 - 2022.08.14
- Improved `Convert-Identity` and `ConvertFrom-SID` - faster lookup for `NT SERVICE\WdiServiceHost`

#### 0.0.234 - 2022.08.14
- Improved `Convert-Identity` and `ConvertFrom-SID` - faster local SID lookup and `Window Manager\Window Manager Group`

#### 0.0.233 - 2022.08.06
- Improves `Get-GitHubLatestRelease` to verify for internet connection.

#### 0.0.232 - 2022.07.16
- Fixes `Convert-CountryToCountryCode` usind DisplayNames instead of EnglishNames
#### 0.0.231 - 2022.07.06
- Fixes `Convert-CountryCodeToCountry` to output just country english name by default
- Fixes `Convert-CountryToCountryCode` to output region information rather than culture information.

#### 0.0.230 - 2022.07.05
- Added `Convert-CountryCodeToCountry`
- Added `Convert-CountryToCountryCode`

#### 0.0.229 - 2022.06.30
- Fixes `Compare-MultipleObjects` which would result in bad comparison from time to time

#### 0.0.228 - 2022.06.30
- Improved `ConvertTo-FlatObject` supporting `ExcludeProperty`
- Improved `Compare-MultipleObjects` supporting `ExcludeProperty`
- Removed `Set-WinAzureADUserStatus` - i think only used in PSAutomator which is experimantal and moved to that repo
- Removed `Set-WinAzureADUserLicense` - i think only used in PSAutomator which is experimantal and moved to that repo
- Removed `Set-WinAzureADUserField` - i think only used in PSAutomator which is experimantal and moved to that repo
- Removed `Set-SpecUser` - i have no clue where it was used, but PSSharedGoods is not a good place for it
- Removed `New-UserAdd` - i have no clue where it was used, but PSSharedGoods is not a good place for it
- Removed `Add-PropertyToList` - i have no clue where it was used, but PSSharedGoods is not a good place for it

#### 0.0.227 - 2022.06.17
- Improved `Convert-Office365License` - tnx diecknet

#### 0.0.226 - 2022.05.28
- Improved `Set-PSRegistry` - supports automapping of DEFAULT_USER (ntuser.dat), skips using .DEFAULT which is just an alias to SYSTEM account (S-1-5-18)
- Improved `Get-PSRegistry` - supports automapping of DEFAULT_USER (ntuser.dat), skips using .DEFAULT which is just an alias to SYSTEM account (S-1-5-18)
- Improved `New-PSRegistry` - supports automapping of DEFAULT_USER (ntuser.dat), add supports for virtual keys to Users, skips using .DEFAULT which is just an alias to SYSTEM account (S-1-5-18)
- Improved `Remove-PSRegistry` - supports automapping of DEFAULT_USER (ntuser.dat), add supports for virtual keys to Users, skips using .DEFAULT which is just an alias to SYSTEM account (S-1-5-18)
- Added `Mount-PSRegistryPath` - allows mapping of file NTUSER.DAT to a specific path in registry
- Added `Dismount-PSRegistryPath` - unmounts NTUSER.DAT from registry

#### 0.0.225 - 2022.04.30
- Rewritten `Set-PSRegistry` to use .net methods
- Rewritten `Get-PSRegistry` to use .net methods, adding more features
- Added `WhatIf` to `Set-PSRegistry`
- Added `Test-PSRegistry`
- Improvement to `Get-PSRegistry`
- Added `Remove-PSRegistry` to remove registry keys
- Added `New-PSRegistry` to create registry paths
- Improvement to `ConvertTo-FlatObject` to deal with `$null` objects
- Improvement to `Compare-MultipleObjects` to deal with `$null` objects and missing properties

#### 0.0.224 - 2022.03.02
- Improvement to `Compare-MultipleObjects`
#### 0.0.223 - 2022.02.25
- Improvement to `ConvertTo-FlatObject` which also improves `Compare-MultipleObjects`

#### 0.0.222 - 2022.02.24
- For publishing PSSharedGoods no longer requires PSWriteColor, Connectimo. It's still required during development
#### 0.0.221 - 2022.02.14
- Improvement to `Compare-MultipleObjects`
- Improvement to `ConvertTo-FlatObject`
#### 0.0.220 - 2022.02.13
- Improvement to `Compare-MultipleObjects`
- Improvement to `ConvertTo-FlatObject`
#### 0.0.219 - 2022.02.12
- Fixes `Compare-MuplipleObjects`
#### 0.0.218 - 2022.02.12
- Fixes `Compare-MuplipleObjects`
#### 0.0.217 - 2022.02.12
- Improvement to `Compare-MultipleObjects`
- Added `ConvertTo-FlatObject`
#### 0.0.216 - 2022.01.24
- 🐛 Fixes critical bug in `New-FileName` where it could lead to a lot of temporary files created by `New-FileName`
#### 0.0.215 - 2021.12.11
- ℹ Improved `Rename-LatinCharacters` with docs and cmdletbinding
- ℹ Improved `ConvertFrom-DistinguishedName` by adding `ToLastName` switch
#### 0.0.214 - 2021.10.23
- ℹ Improved error handling `Get-PSRegistry` and added new property
- ℹ Improved `ConvertTo-OperatingSystem` adding registry handling + few more systems
- Added `Get-ProtocolDefaults` to get default values for SSL/TLS protocols per system
#### 0.0.213 - 2021.10.22
- ℹ Fixes for forest domains handling `Get-WinADForestDetails`
#### 0.0.212 - 2021.09.30
- ℹ Improved detection of dead domains in `Get-WinADForestDetails`
#### 0.0.211 - 2021.08.25
- ℹ Improved `Join-UriQuery`
#### 0.0.210 - 2021.08.12
- ℹ Improved `Convert-OfficeLicense` - adds [more licenses](https://github.com/EvotecIT/PSSharedGoods/pull/26) license - tnx diecknet
#### 0.0.209 - 2021.08.08
- ℹ Improved `Convert-OfficeLicense` - adds [Dynamics 365 Business Central Essentials](https://github.com/EvotecIT/PSSharedGoods/pull/25) license - tnx diecknet
#### 0.0.208 - 2021.08.04
- ℹ Improved `Set-PasswordRemotely` to cleanup objects
- ℹ Improved `ConvertFrom-DistinguishedName`
#### 0.0.207 - 2021.07.05
- 📦 Added Principal.UserID for ScheduledTask (run as account) - tnx itpro-tips - [#20](https://github.com/EvotecIT/PSSharedGoods/pull/20)
- Renamed function `Get-TimeSetttings` to `Get-TimeSettings` - tnx rmbolger - [Extra 't' in Get-TimeSetttings #22](https://github.com/EvotecIT/PSSharedGoods/issues/22)
- ℹ Improved `Get-TimeSettings` to support 2 ways of flag definitions - tnx rmbolger - [#23](https://github.com/EvotecIT/PSSharedGoods/issues/23)
#### 0.0.206 - 2021.06.16
- ℹ Improved `Send-Email` to return object when using `WhatIf`
#### 0.0.205 - 2021.06.06
- ℹ Improved `ConvertTo-FlatHashtable`
#### 0.0.204 - 2021.06.05
- 📦 Added `ConvertTo-FlatHashtable`
#### 0.0.203 - 2021.06.01
- 💡 Improved `Join-UriQuery`
#### 0.0.202 - 2021.06.01
- 💡 Improved `Join-UriQuery`
#### 0.0.201 - 2021.05.19
- 📦 Added `Convert-DomainFqdnToNetBIOS`
- 📦 Added `Convert-DomainToSid`
- 📦 Improved `Get-OperatingSystem`
#### 0.0.200 - 2021.05.19
- 📦 Added `Convert-ExchangeRecipient` (replacement to `Convert-ExchangeRecipientDetails` which will be removed in the future (too slow))
- 📦 Added `Get-OperatingSystem`
- 💡 Improved `Convert-Office365License` by adding licenses: FORMS_PRO, CCIBOTS_PRIVPREV_VIRAL [#19](https://github.com/EvotecIT/PSSharedGoods/pull/19) - tnx diecknet
- 💡 Improved `Remove-EmptyValue` by adding ability to disable removing of different object types
- 🐛 Fixes `ConvertTo-JsonLiteral` when dealing with array of double, decimal values
- 💡 Improved `ConvertTo-OperatingSystem`
#### 0.0.199 - 2021.04.12
- 📦 Added `Join-Uri` - Provides ability to join two Url paths together
- 📦 Added `Join-UriQuery` - Provides ability to join two Url paths together including advanced querying which is useful for RestAPI/GraphApi calls
#### 0.0.198 - 2021.03.12
- Improved `ConvertTo-JsonLiteral`
  - ☑ Added `AdvancedReplace` parameter to be able to fix strings like `@{ '.' = '\.'; '$' = '\$' }` which break JSON, but useful for other stuff
  - ☑ Moved enum/numeric conversions around to prevent issues with arrays
#### 0.0.197 - 2021.02.21
- Improved `ConvertTo-JsonLiteral` - `ArrayJoin` and `ArrayJoinString` to better control `JavaScript` output
#### 0.0.196 - 2021.02.11
- Fixed `ConvertFrom-Color` when using multiple hex colors
#### 0.0.195 - 2021.01.26
- Improved/Fixed `Invoke-CommandCustom` to catch errors properly
#### 0.0.194 - 2021.01.20
- Fixed `Get-WinADForestControllers` to discover only writable DCs
#### 0.0.193 - 2021.01.14
- Added `Invoke-CommandCustom`
- Fixed actions property in `Get-ComputerTask`
#### 0.0.192 - 2020.12.16
- Improved `Get-PSService`
- Improved `Get-CimData`
#### 0.0.191 - 2020.12.16
- Improved `Set-PasswordRemotly` with more secure approach and autodetect DC
#### 0.0.190 - 2020.12.07
- Improved `Get-Computer`
- Improved `Get-ComputerNetwork`
- Improved `Get-ComputerStartup`
- Improved `Get-ComputerApplication` (renamed from `Get-ComputerApplications`, but alias left in place)
- Improved `Get-ComputerTask` (renamed from `Get-ComputerTasks`, but alias left in place)
#### 0.0.189 - 2020.11.29
- Improved `Get-ComputerWindowsFeatures`
- Improved `Get-ComputerRoles`
#### 0.0.188 - 2020.11.12
- Improved `Set-FileOwner`
#### 0.0.187
- Added tests for `Copy-Dictionary`
- Improved `Get-FilePermission`
#### 0.0.186 - 2020.10.22
- Disabled progress for `Get-GitHubLatestRelease`
#### 0.0.185 - 2020.10.21
- Improvements to `ConvertTo-JsonLiteral`
#### 0.0.184 - 2020.10.20
- Improvements to `ConvertTo-JsonLiteral`
#### 0.0.183 - 2020.10.18
- Update to `ConvertFrom-SID`
- Update to `Get-FilePermission`
#### 0.0.182 - 2020.10.18
- Improvements to `ConvertTo-JsonLiteral`
- Rewritten `Get-PSService` to CIM, small change on output parameter
- Added `Get-ComputerDevice`
- Added `Get-ComputerRAM`
- Improved `Get-ComputerBIOS`
- Moved `Get-ComputerSplit` to private functions as it shouldn't be used outside
- Added `Get-Computer`
- Improvements to other `Get-Computer*` cmdlets
#### 0.0.180 - 2020.09.20
- Updates to `Convert-Identity`
- Updated PSD1 to better version
#### 0.0.179 - 2020.09.17
- Rewritten `Convert-Identity` and added tests for it - basic ones as no AD in Cloud
- Rewritten `ConvertTo-SID` and added tests for it
#### 0.0.178 - 2020.09.12
- Updated `Get-ADTrustAttributes` with more attributes, renamed some
- Added `Get-ADEncryptionTypes`
#### 0.0.177 - 2020.09.11
- Fixed `ConvertTo-DistinguishedName`
#### 0.0.176 - 2020.09.07
- Improvements `ConvertTo-JsonLiteral`
#### 0.0.175 - 2020.09.06
- Added `ConvertTo-JsonLiteral`
#### 0.0.174 - 2020.09.06
- Removed from PSGallery
#### 0.0.173 - 2020.09.06
- `Send-Email` more fixes to encoding
#### 0.0.172 - 2020.09.05
- `Send-Email` now sets encoding utf-8 for AlternativeView (inline attachments)
#### 0.0.171 - 2020.09.05
- Small updates to email commands but those will be removed in future
  - Need to migrate them to modules that use them
  - Only Send-Email will be left
#### 0.0.170 - 2020.09.01
- Added `Test-IsDistinguishedName`
- Added `ConvertFrom-NetbiosName`
- Improvements to `Convert-Identity`
- Improvements to `Get-Colors`
#### 0.0.169 - 2020.08.27
- Added `ConvertTo-DistinguishedName`
- Updated `ConvertFrom-DistinguishedName`
- Added tests for both
#### 0.0.168 - 2020.08.25
- `Convert-UserAccountControl` - alterntive to `Convert-UAC`, should be faster
#### 0.0.167 - 2020.08.23
- `Select-Properties` updated to skip some types
#### 0.0.166 - 2020.08.03
- `Remove-EmptyValue` fix for bool values
#### 0.0.165 - 2020.07.31
- `Format-ToTitleCase` updates
- `Remove-EmptyValue` fix for ILIST 0
#### 0.0.163 - 2020.07.31
- `Remove-EmptyValue` fix for ILIST
#### 0.0.162 - 2020.07.31
- `Format-ToTitleCase` updates
#### 0.0.161 - 2020.07.23
- Updated `Get-FilePermission`
- Updated `Get-FileOwner`
#### 0.0.160 - 2020.07.21
- Updated `Get-FileMetaData`
#### 0.0.159 - 2020.07.20
- Updated `ConvertTo-OperatingSystem`
- Update SKU mapping table $O365SKU for `Convert-Office365License` #12 tnx diecknet
#### 0.0.158 - 2020.07.06
- Update `Convert-Identity`
#### 0.0.157 - 2020.07.03
- Improvements to `Remove-EmptyValue`
- Accidentally `Get-FileMetaData` would run during import
#### 0.0.156 - 2020.07.02
- Improvements to `Convert-Identity`
#### 0.0.155 - 2020.06.25
- Improvements to `Convert-Office365License`
#### 0.0.154 - 2020.06.25
- Improvements to `Get-FileMetaData` to not-existing files
#### 0.0.153 - 2020.06.21
- Added `HashAlgorithm` parameter to `Get-FileMetaData`
#### 0.0.152 - 2020.06.20
- Improvements to `Get-FileMetaData`
#### 0.0.151 - 2020.06.20
- Improvements to `Get-FileMetaData`
#### 0.0.150 - 2020.06.20
- Bugfix `Get-FileMetaData`
#### 0.0.149 - 2020.06.20
- Added `Get-FileMetaData`
#### 0.0.148 - 2020.06.19
- Fixes for nuget versioning [#11](https://github.com/EvotecIT/PSSharedGoods/issues/11)
- `Send-Email` now returns [PSCustomObject] instead of hashtable. Makes it easier to process in loops
#### 0.0.146 - 2020.06.11
- Improved `Get-Colors`
- Improved `ConvertFrom-Color`
#### 0.0.144 - 2020.05.31
- Improved `Get-WinADForestDetails`
#### 0.0.143 - 2020.05.17
- Improved `Get-WinADForestDetails`
- Added `Copy-DictionaryManual`, alternative to `Copy-Dictionary` which is driving me nuts - tnx joel~!
#### 0.0.142 - 2020.05.14
- Improved `Get-WinADForestDetails`
#### 0.0.141 - 2020.05.14
- Improved `Set-FileOwner`
- Improved `Get-WinADForestDetails`
#### 0.0.140 - 2020.05.10
- Improved `Get-FilePermission`
#### 0.0.139 - 2020.05.09
- Added `Convert-Identity`
- Improved `ConvertFrom-Sid`
- Improved `ConvertTo-Sid`
- Added `Get-FileOwner`
- Improved `Get-FilePermission`
- Improved `Remove-FilePermission`
- Added `Set-FileOwner`
- Improved `Set-FilePermission`
- Improved `Get-WinADForestDetails`
- Added `Get-ADAdministrativeGroups`

#### 0.0.138 - 2020.04.26
- ☑ ConvertFrom-DistinguishedName added switch `ToDomainCN`

    ```powershell
    $Oops = 'cn={55FB3860-74C9-4262-AD77-30197EAB9999},cn=policies,cn=system,DC=ad,DC=evotec,DC=xyz'
    ConvertFrom-DistinguishedName -DistinguishedName $Oops -ToDomainCN
    ```

    ```output
    ad.evotec.xyz
    ```

#### 0.0.137 - 2020.04.24
- ☑ Removed aliases for `Set-FileInheritance`, `Set-FilePermission`, `Remove-FilePermission`

#### 0.0.136 - 2020.04.24
- ☑ Added `OnlyWellKnownAdministrative` switch to `ConvertFrom-SID`

#### 0.0.135 - 2020.04.19
- ☑ Improvements to Get-WinADForestDetails
- ☑ Added `OnlyWellKnown` switch to `ConvertFrom-SID`

#### 0.0.134 - 2020.04.09
- ☑ Improvements to Get-WinADForestDetails

#### 0.0.133 - 2020.04.03
- ☑ Improvements to Get-WinADForestDetails

#### 0.0.132 - 2020.03.19
- ☑ Improvements to Get-WinADForestDetails

#### 0.0.131 - 2020.03.18
- ☑ Improvements to Get-WinADForestDetails for subsequent use, fix for excluding d
- ☑ Copy-Dictionary added

#### 0.0.130 - 2020.03.14
- ☑ Small update to Get-WinADForestDetails

#### 0.0.129 - 2020.03.13
- ☑ Typo fix for string

#### 0.0.128 - 2020.03.05
- ☑ Small update to Get-WinADForestDetails

#### 0.0.127 - 2020.02.27
- ☑ Fix for ConvertFrom-DistinguishedName

#### 0.0.126 - 2020.02.27
- ☑ Added Get-FilePermissions
- ☑ Improved ConvertFrom-SID

#### 0.0.125 - 2020.02.17
- ☑ Improvments to Get-ComputerSMBSharePermissions
#### 0.0.124 - 2020.02.17
- ☑ Added Get-ComputerSMBSharePermissions
#### 0.0.123 - 2020.02.16
- ☑ Updates to Get-PSRegistry/Set-PSRegistry/Get-CimData
- ☑ Added Get-ComputerSplit for easiedr use of above functions but also for future use

#### 0.0.122 - 2020.01.26
- ☑ Fix for ConvertFrom-DistinguishedName to cover OU/DC properly (wrong regex)
