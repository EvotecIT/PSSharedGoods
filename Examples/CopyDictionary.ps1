Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$ExtendedForestInformation = Get-WinADForestDetails -Extended
$ExtendedForestInformation | Format-Table
$New = Copy-Dictionary -Dictionary $ExtendedForestInformation
$New | Format-Table