Clear-Host
Get-Process | Select-Object -First 5 | Format-Stream * -Stream Host -ForegroundColor Green,Red, Yellow -ForegroundColorRow 2,4,5
Get-Process | Select-Object -First 5 | Format-Stream Name,ID -Stream Host -ForegroundColor Green,Red, Yellow -ForegroundColorRow 2,4,5
Get-Process | Select-Object -First 5 | Format-Stream Name,ID -Stream Host -List