<p align="center">
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
