Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$Path = Get-ChildItem '\\ad.evotec.xyz\SYSVOL\ad.evotec.xyz\scripts' -Recurse

Get-FilePermission -Path $Path | Format-Table