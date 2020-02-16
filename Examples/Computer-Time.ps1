Import-Module .\PSsharedGoods.psd1 -Force

Get-ComputerTime -TimeTarget AD2, AD3, EVOWin | Format-Table