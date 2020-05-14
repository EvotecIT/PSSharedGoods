Import-Module .\PSsharedGoods.psd1 -Force

$ForestInformation = Get-WinADForestDetails -Extended #-IncludeDomains 'ad.evotec.pl' -ExcludeDomainControllers adpreview2019
#$ForestInformation.ForestDomainControllers | ft -AutoSize
$F2 = Copy-Dictionary $ForestInformation

$F = Get-WinADForestDetails -ExtendedForestInformation $ForestInformation -IncludeDomains 'ad.evotec.pl' -ExcludeDomainControllers adpreview2019
$F.ForestDomainControllers | Format-Table -AutoSize

$F2 = Copy-Dictionary $F

Get-WinADForestDetails -ExtendedForestInformation $F2 #-IncludeDomains 'ad.evotec.pl' -ExcludeDomainControllers adpreview2019