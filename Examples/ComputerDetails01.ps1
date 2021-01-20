Import-Module .\PSSharedGoods.psd1 -Force

#Get-ComputerOperatingSystem -ComputerName AD1, AD2, AD3, DC1 -All #| ft -a *

Get-ComputerTask | Format-Table

#Get-ScheduledTask -TaskName 'Test' | fl *

#Get-ScheduledTaskInfo -TaskName 'Test' | fl *