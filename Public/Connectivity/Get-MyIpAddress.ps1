function Get-MyIpAddress {
    <#
    .SYNOPSIS
    Retrieves the public IP address of the current machine using OpenDNS.

    .DESCRIPTION
    This function retrieves the public IP address of the current machine by querying OpenDNS servers. It returns the IP address as a string.

    .EXAMPLE
    Get-MyIpAddress
    Retrieves the public IP address of the current machine.

    .NOTES
    Author: Your Name
    Date: Current Date
    #>
    [alias('Get-MyIP')]
    [CmdletBinding()]
    param()
    $DNSParam = @{
        Name    = 'myip.opendns.com'
        Server  = 'resolver1.opendns.com'
        DnsOnly = $true
    }
    return Resolve-DnsName @DNSParam | ForEach-Object IPAddress
}