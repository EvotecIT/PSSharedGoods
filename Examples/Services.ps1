Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$DomainController = 'ad1.ad.evotec.xyz', 'ad2'
$Services = @('ADWS', 'DNS', 'DFS', 'DFSR', 'Eventlog', 'EventSystem', 'KDC', 'LanManWorkstation', 'LanManServer', 'NetLogon', 'NTDS', 'RPCSS', 'SAMSS', 'Spooler', 'W32Time', 'XblGameSave', 'XblAuthManager')
Get-PSService -Computers $DomainController -Services $Services | Format-Table