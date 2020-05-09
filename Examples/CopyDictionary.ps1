Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$ExtendedForestInformation = Get-WinADForestDetails -Extended
Copy-Dictionary -Dictionary $ExtendedForestInformation