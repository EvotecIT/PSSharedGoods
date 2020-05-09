Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

#Get-ChildItem -Path '\\ad1\c$\Windows\SYSVOL\sysvol\ad.evotec.xyz\scripts\Signatures\New folder' | ForEach-Object {
#    Get-FilePermission -path $_ -ResolveTypes
#} | Format-Table *
$Test = '\\ad1\c$\Windows\SYSVOL\sysvol\ad.evotec.xyz\scripts\Signatures\New folder'
$Test = '\\ad.evotec.xyz\NETLOGON'

Get-FileOwner -Path $Test -Resolve
Get-FilePermission -Path $Test -Resolve -IncludeACLObject | Format-Table *
#Get-WinADShare -Path $Test | Format-Table *

#Get-WinADShare -Type NetLogon -Owner | Format-Table *