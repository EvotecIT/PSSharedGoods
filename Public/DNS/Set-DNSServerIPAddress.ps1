function Set-DnsServerIpAddress {
    <#
    .SYNOPSIS
    Sets the DNS server IP addresses on a specified computer for a given network interface.

    .DESCRIPTION
    This function allows you to set the DNS server IP addresses on a specified computer for a given network interface. It checks if the computer is online before attempting to set the DNS server addresses.

    .PARAMETER ComputerName
    Specifies the name of the computer where the DNS server IP addresses will be set.

    .PARAMETER NicName
    Specifies the name of the network interface (NIC) where the DNS server IP addresses will be set. Supports wildcard characters.

    .PARAMETER IpAddresses
    Specifies one or more IP addresses of the DNS servers to be set on the specified network interface.

    .EXAMPLE
    Set-DnsServerIpAddress -ComputerName "Server01" -NicName "Ethernet*" -IpAddresses '8.8.8.8','8.8.4.4','8.8.8.1'
    Sets the DNS server IP addresses '8.8.8.8', '8.8.4.4', and '8.8.8.1' on the network interface starting with "Ethernet" on the computer "Server01".

    .NOTES
    This function may require further enhancements for specific use cases.
    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName,
        [string] $NicName,
        [string] $IpAddresses
    )
    if (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet) {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock { param ($ComputerName, $NicName, $IpAddresses)
            Write-Host "Setting on $ComputerName on interface $NicName a new set of DNS Servers $IpAddresses"
            Set-DnsClientServerAddress -InterfaceAlias $NicName -ServerAddresses $IpAddresses
        } -ArgumentList $ComputerName, $NicName, $IpAddresses
    } else {
        Write-Warning "Set-DnsServerIpAddress - Can't access $ComputerName. Computer is not online."
    }
}