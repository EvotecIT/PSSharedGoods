Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$MaximumSize = '40000000'
#$ComputerName = $EnV:COMPUTERNAME
$LogName = 'Internet Explorer'
#$ComputerName = ''
#$ComputerName = 'AD1'

Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -ComputerName $ComputerName
#Set-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -ComputerName $ComputerName -Key 'MaxSize' -Value $MaximumSize -Type REG_DWORD


Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\$LogName"
Get-PSRegistry -RegistryPath "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName"