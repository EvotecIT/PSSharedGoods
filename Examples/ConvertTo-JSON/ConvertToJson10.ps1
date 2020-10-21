Import-Module .\PSSharedGoods.psd1 -Force

$T = Get-HotFix -ComputerName AD1 | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1

$T | ConvertTo-Json
$T | ConvertTo-JsonLiteral