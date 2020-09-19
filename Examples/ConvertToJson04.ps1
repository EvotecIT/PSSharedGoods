Import-Module .\PSSharedGoods.psd1 -Force

Get-Process | Select-Object -First 2 -Property Threads, TotalProcessorTime | ConvertTo-JsonLiteral -Depth 3
#Get-Process | Select-Object -First 2 -Property Threads,TotalProcessorTime | ConvertTo-Json -Depth 1 | ConvertFrom-Json
$Test = Get-Process | Select-Object -First 2 -Property Threads, TotalProcessorTime | ConvertTo-JsonLiteral -Depth 2 | ConvertFrom-Json
$Test.Threads | Format-Table