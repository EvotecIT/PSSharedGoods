Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Get-FilePermissions -Path '\\ad.evotec.xyz\Netlogon\New folder' -Extended | Format-Table
Get-FilePermissions -Path '\\ad.evotec.pl\Netlogon\New folder (3)' -Extended | Format-Table
#Get-FilePermissions -Path '\\ad.evotec.xyz\Netlogon\Signatures' | Format-Table