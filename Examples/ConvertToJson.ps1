Import-Module .\PSSharedGoods.psd1 -Force

$Test = [PSCustomObject] @{
    Test  = 1
    Test1 = $false
}
$Test, $Test, $Test | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table

$Processes = Get-Process | Select-Object -First 2
$Processes | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table

ConvertTo-JsonLiteral -Object $Processes | ConvertFrom-Json | Format-TableD