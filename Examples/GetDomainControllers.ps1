Import-Module .\PSsharedGoods.psd1 -Force

$ForestInformation = Get-WinADForestDetails #-IncludeDomains 'ad.evotec.pl' -ExcludeDomainControllers adpreview2019
#$ForestInformation.ForestDomainControllers | ft -AutoSize

$F = Get-WinADForestDetails -ExtendedForestInformation $ForestInformation -IncludeDomains 'ad.evotec.pl' -ExcludeDomainControllers adpreview2019
$F.ForestDomainControllers | Format-Table -AutoSize