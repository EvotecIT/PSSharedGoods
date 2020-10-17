function Set-DnsServerIpAddress {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    ComputerName/ServerName where to Set DNS Server

    .PARAMETER NicName
    Service is the name of the Network Card (takes wildcard)

    .PARAMETER IpAddresses
    IpAddresses can be one or more values

    .EXAMPLE
    Set-DnsServerIpAddress -ComputerName $ServerName -NicName "Service*" -IpAddresses '8.8.8.8','8.8.4.4','8.8.8.1'

    .NOTES
    Probably needs a rewrite
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