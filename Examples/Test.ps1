Clear-Host
Import-Module PSSharedGoods -Force

Split-array -inArray @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10) -size 3
Write-Color 'Test' -Color Red
Split-array -inArray @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10) -parts 3