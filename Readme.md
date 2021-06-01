<p align="center">
  <a href="https://dev.azure.com/evotecpl/PSSharedGoods/_build/latest?definitionId=3"><img src="https://dev.azure.com/evotecpl/PSSharedGoods/_apis/build/status/EvotecIT.PSSharedGoods"></a>
  <a href="https://www.powershellgallery.com/packages/PSSharedGoods"><img src="https://img.shields.io/powershellgallery/v/PSSharedGoods.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSSharedGoods"><img src="https://img.shields.io/powershellgallery/vpre/PSSharedGoods.svg?label=powershell%20gallery%20preview&colorB=yellow"></a>
  <a href="https://github.com/EvotecIT/PSSharedGoods"><img src="https://img.shields.io/github/license/EvotecIT/PSSharedGoods.svg"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSSharedGoods"><img src="https://img.shields.io/powershellgallery/p/PSSharedGoods.svg"></a>
  <a href="https://github.com/EvotecIT/PSSharedGoods"><img src="https://img.shields.io/github/languages/top/evotecit/PSSharedGoods.svg"></a>
  <a href="https://github.com/EvotecIT/PSSharedGoods"><img src="https://img.shields.io/github/languages/code-size/evotecit/PSSharedGoods.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSSharedGoods"><img src="https://img.shields.io/powershellgallery/dt/PSSharedGoods.svg"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=social"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn"></a>
</p>

# PSSharedGoods - PowerShell Module

PSSharedGoods is a little PowerShell Module that primary purpose is to be useful for multiple tasks, unrelated to each other. I've created this module as "a glue" between my other modules. I've noticed the more I build my modules, the more I use the same stuff and it became apparent I've two choices. Keep 3 or more versions of the same function across all my modules or export functions to separate module and bundle this module together. I chose the second option. This module currently is used by following modules

- [PSWriteWord](https://evotec.xyz/hub/scripts/pswriteword-powershell-module/) - module to create Microsoft Word documents without Word being installed.
- [PSWriteExcel](https://evotec.xyz/hub/scripts/pswriteexcel-powershell-module/) - cross-platform module to create Microsoft Excel documents without Excel being installed.
- [PSWinDocumentation](https://evotec.xyz/hub/scripts/pswindocumentation-powershell-module/) - module to build documentation for Active Directory, Office 365 (Azure AD, Exchange Online), Exchange, Teams
- [PSWinReporting](https://evotec.xyz/hub/scripts/pswinreporting-powershell-module/) - module to create reports and provide monitoring of Security Events
- [PSAutomator](https://evotec.xyz/hub/scripts/psautomator-powershell-module/) - proof-of-concept module for onboarding, offboarding and business as usual
- Many others - just review other GitHub projects of mine

More information can be found on a dedicated page for [PSSharedGoods](https://evotec.xyz/hub/scripts/pssharedgoods-powershell-module/) module.

## Changelog

- 0.0.203 - 2021.06.01
  - 💡 Improved `Join-UriQuery`
- 0.0.202 - 2021.06.01
  - 💡 Improved `Join-UriQuery`
- 0.0.201 - 2021.05.19
  - 📦 Added `Convert-DomainFqdnToNetBIOS`
  - 📦 Added `Convert-DomainToSid`
  - 📦 Improved `Get-OperatingSystem`
- 0.0.200 - 2021.05.19
  - 📦 Added `Convert-ExchangeRecipient` (replacement to `Convert-ExchangeRecipientDetails` which will be removed in the future (too slow))
  - 📦 Added `Get-OperatingSystem`
  - 💡 Improved `Convert-Office365License` by adding licenses: FORMS_PRO, CCIBOTS_PRIVPREV_VIRAL [#19](https://github.com/EvotecIT/PSSharedGoods/pull/19) - tnx diecknet
  - 💡 Improved `Remove-EmptyValue` by adding ability to disable removing of different object types
  - 🐛 Fixes `ConvertTo-JsonLiteral` when dealing with array of double, decimal values
  - 💡 Improved `ConvertTo-OperatingSystem`
- 0.0.199 - 2021.04.12
  - 📦 Added `Join-Uri` - Provides ability to join two Url paths together
  - 📦 Added `Join-UriQuery` - Provides ability to join two Url paths together including advanced querying which is useful for RestAPI/GraphApi calls
- 0.0.198 - 2021.03.12
  - Improved `ConvertTo-JsonLiteral`
    - [x] Added `AdvancedReplace` parameter to be able to fix strings like `@{ '.' = '\.'; '$' = '\$' }` which break JSON, but useful for other stuff
    - [x] Moved enum/numeric conversions around to prevent issues with arrays
- 0.0.197 - 2021.02.21
  - Improved `ConvertTo-JsonLiteral` - `ArrayJoin` and `ArrayJoinString` to better control `JavaScript` output
- 0.0.196 - 2021.02.11
  - Fixed `ConvertFrom-Color` when using multiple hex colors
- 0.0.195 - 2021.01.26
  - Improved/Fixed `Invoke-CommandCustom` to catch errors properly
- 0.0.194 - 2021.01.20
  - Fixed `Get-WinADForestControllers` to discover only writable DCs
- 0.0.193 - 2021.01.14
  - Added `Invoke-CommandCustom`
  - Fixed actions property in `Get-ComputerTask`
- 0.0.192 - 2020.12.16
  - Improved `Get-PSService`
  - Improved `Get-CimData`
- 0.0.191 - 2020.12.16
  - Improved `Set-PasswordRemotly` with more secure approach and autodetect DC
- 0.0.190 - 2020.12.07
  - Improved `Get-Computer`
  - Improved `Get-ComputerNetwork`
  - Improved `Get-ComputerStartup`
  - Improved `Get-ComputerApplication` (renamed from `Get-ComputerApplications`, but alias left in place)
  - Improved `Get-ComputerTask` (renamed from `Get-ComputerTasks`, but alias left in place)
- 0.0.189 - 2020.11.29
  - Improved `Get-ComputerWindowsFeatures`
  - Improved `Get-ComputerRoles`
- 0.0.188 - 2020.11.12
  - Improved `Set-FileOwner`
- 0.0.187
  - Added tests for `Copy-Dictionary`
  - Improved `Get-FilePermission`
- 0.0.186 - 2020.10.22
  - Disabled progress for `Get-GitHubLatestRelease`
- 0.0.185 - 2020.10.21
  - Improvements to `ConvertTo-JsonLiteral`
- 0.0.184 - 2020.10.20
  - Improvements to `ConvertTo-JsonLiteral`
- 0.0.183 - 2020.10.18
  - Update to `ConvertFrom-SID`
  - Update to `Get-FilePermission`
- 0.0.182 - 2020.10.18
  - Improvements to `ConvertTo-JsonLiteral`
  - Rewritten `Get-PSService` to CIM, small change on output parameter
  - Added `Get-ComputerDevice`
  - Added `Get-ComputerRAM`
  - Improved `Get-ComputerBIOS`
  - Moved `Get-ComputerSplit` to private functions as it shouldn't be used outside
  - Added `Get-Computer`
  - Improvements to other `Get-Computer*` cmdlets
- 0.0.180 - 2020.09.20
  - Updates to `Convert-Identity`
  - Updated PSD1 to better version
- 0.0.179 - 2020.09.17
  - Rewritten `Convert-Identity` and added tests for it - basic ones as no AD in Cloud
  - Rewritten `ConvertTo-SID` and added tests for it
- 0.0.178 - 2020.09.12
  - Updated `Get-ADTrustAttributes` with more attributes, renamed some
  - Added `Get-ADEncryptionTypes`
- 0.0.177 - 2020.09.11
  - Fixed `ConvertTo-DistinguishedName`
- 0.0.176 - 2020.09.07
  - Improvements `ConvertTo-JsonLiteral`
- 0.0.175 - 2020.09.06
  - Added `ConvertTo-JsonLiteral`
- 0.0.174 - 2020.09.06
  - Removed from PSGallery
- 0.0.173 - 2020.09.06
  - `Send-Email` more fixes to encoding
- 0.0.172 - 2020.09.05
  - `Send-Email` now sets encoding utf-8 for AlternativeView (inline attachments)
- 0.0.171 - 2020.09.05
  - Small updates to email commands but those will be removed in future
    - Need to migrate them to modules that use them
    - Only Send-Email will be left
- 0.0.170 - 2020.09.01
  - Added `Test-IsDistinguishedName`
  - Added `ConvertFrom-NetbiosName`
  - Improvements to `Convert-Identity`
  - Improvements to `Get-Colors`
- 0.0.169 - 2020.08.27
  - Added `ConvertTo-DistinguishedName`
  - Updated `ConvertFrom-DistinguishedName`
  - Added tests for both
- 0.0.168 - 2020.08.25
  - `Convert-UserAccountControl` - alterntive to `Convert-UAC`, should be faster
- 0.0.167 - 2020.08.23
  - `Select-Properties` updated to skip some types
- 0.0.166 - 2020.08.03
  - `Remove-EmptyValue` fix for bool values
- 0.0.165 - 2020.07.31
  - `Format-ToTitleCase` updates
  - `Remove-EmptyValue` fix for ILIST 0
- 0.0.163 - 2020.07.31
  - `Remove-EmptyValue` fix for ILIST
- 0.0.162 - 2020.07.31
  - `Format-ToTitleCase` updates
- 0.0.161 - 2020.07.23
  - Updated `Get-FilePermission`
  - Updated `Get-FileOwner`
- 0.0.160 - 2020.07.21
  - Updated `Get-FileMetaData`
- 0.0.159 - 2020.07.20
  - Updated `ConvertTo-OperatingSystem`
  - Update SKU mapping table $O365SKU for `Convert-Office365License` #12 tnx diecknet
- 0.0.158 - 2020.07.06
  - Update `Convert-Identity`
- 0.0.157 - 2020.07.03
  - Improvements to `Remove-EmptyValue`
  - Accidentally `Get-FileMetaData` would run during import
- 0.0.156 - 2020.07.02
  - Improvements to `Convert-Identity`
- 0.0.155 - 2020.06.25
  - Improvements to `Convert-Office365License`
- 0.0.154 - 2020.06.25
  - Improvements to `Get-FileMetaData` to not-existing files
- 0.0.153 - 2020.06.21
  - Added `HashAlgorithm` parameter to `Get-FileMetaData`
- 0.0.152 - 2020.06.20
  - Improvements to `Get-FileMetaData`
- 0.0.151 - 2020.06.20
  - Improvements to `Get-FileMetaData`
- 0.0.150 - 2020.06.20
  - Bugfix `Get-FileMetaData`
- 0.0.149 - 2020.06.20
  - Added `Get-FileMetaData`
- 0.0.148 - 2020.06.19
  - Fixes for nuget versioning [#11](https://github.com/EvotecIT/PSSharedGoods/issues/11)
  - `Send-Email` now returns [PSCustomObject] instead of hashtable. Makes it easier to process in loops
- 0.0.146 - 2020.06.11
  - Improved `Get-Colors`
  - Improved `ConvertFrom-Color`
- 0.0.144 - 2020.05.31
  - Improved `Get-WinADForestDetails`
- 0.0.143 - 2020.05.17
  - Improved `Get-WinADForestDetails`
  - Added `Copy-DictionaryManual`, alternative to `Copy-Dictionary` which is driving me nuts - tnx joel~!
- 0.0.142 - 2020.05.14
  - Improved `Get-WinADForestDetails`
- 0.0.141 - 2020.05.14
  - Improved `Set-FileOwner`
  - Improved `Get-WinADForestDetails`
- 0.0.140 - 2020.05.10
  - Improved `Get-FilePermission`
- 0.0.139 - 2020.05.09
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

- 0.0.138 - 2020.04.26
  - [x] ConvertFrom-DistinguishedName added switch `ToDomainCN`

    ```powershell
    $Oops = 'cn={55FB3860-74C9-4262-AD77-30197EAB9999},cn=policies,cn=system,DC=ad,DC=evotec,DC=xyz'
    ConvertFrom-DistinguishedName -DistinguishedName $Oops -ToDomainCN
    ```

    ```output
    ad.evotec.xyz
    ```

- 0.0.137 - 2020.04.24
  - [x] Removed aliases for `Set-FileInheritance`, `Set-FilePermission`, `Remove-FilePermission`

- 0.0.136 - 2020.04.24
  - [x] Added `OnlyWellKnownAdministrative` switch to `ConvertFrom-SID`

- 0.0.135 - 2020.04.19
  - [x] Improvements to Get-WinADForestDetails
  - [x] Added `OnlyWellKnown` switch to `ConvertFrom-SID`

- 0.0.134 - 2020.04.09
  - [x] Improvements to Get-WinADForestDetails

- 0.0.133 - 2020.04.03
  - [x] Improvements to Get-WinADForestDetails

- 0.0.132 - 2020.03.19
  - [x] Improvements to Get-WinADForestDetails

- 0.0.131 - 2020.03.18
  - [x] Improvements to Get-WinADForestDetails for subsequent use, fix for excluding d
  - [x Copy-Dictionary added

- 0.0.130 - 2020.03.14
  - [x] Small update to Get-WinADForestDetails

- 0.0.129 - 2020.03.13
  - [x] Typo fix for string

- 0.0.128 - 2020.03.05
  - [x] Small update to Get-WinADForestDetails

- 0.0.127 - 2020.02.27
  - [x] Fix for ConvertFrom-DistinguishedName

- 0.0.126 - 2020.02.27
  - [x] Added Get-FilePermissions
  - [x] Improved ConvertFrom-SID

- 0.0.125 - 2020.02.17
  - [x] Improvments to Get-ComputerSMBSharePermissions
- 0.0.124 - 2020.02.17
  - [x] Added Get-ComputerSMBSharePermissions
- 0.0.123 - 2020.02.16
  - [x] Updates to Get-PSRegistry/Set-PSRegistry/Get-CimData
  - [x] Added Get-ComputerSplit for easiedr use of above functions but also for future use

- 0.0.122 - 2020.01.26
  - [x] Fix for ConvertFrom-DistinguishedName to cover OU/DC properly (wrong regex)
