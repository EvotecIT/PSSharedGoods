<#
# Where $ServerName can be set as needed
# Where Service is the name of the Network Card (takes wildcard)
# Where IpAddresses are given in brackets
Set-DnsServerIpAddress -ComputerName $ServerName -NicName "Service*" -IpAddresses '8.8.8.8','8.8.4.4','8.8.8.1'
#>

function Set-DnsServerIpAddress {
    [CmdletBinding()]
    param(
        [string] $ComputerName,
        [string] $NicName,
        [string] $IpAddresses
    )
    if (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet) {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock { param ($ComputerName, $NicName, $IpAddresses)
            write-host "Setting on $ComputerName on interface $NicName a new set of DNS Servers $IpAddresses"
            Set-DnsClientServerAddress -InterfaceAlias $NicName -ServerAddresses $IpAddresses

        } -ArgumentList $ComputerName, $NicName, $IpAddresses

    } else {
        write-host "Can't access $ComputerName. Computer is not online."
    }
}