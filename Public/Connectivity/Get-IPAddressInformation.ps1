function Get-IPAddressInformation {
    <#
    .SYNOPSIS
    Retrieves detailed information about an IP address using the ip-api.com service.
    
    .DESCRIPTION
    This function retrieves detailed information about the specified IP address using the ip-api.com service. It provides details such as country, region, city, ISP, and more.
    
    .PARAMETER IP
    Specifies the IP address for which information needs to be retrieved.
    
    .EXAMPLE
    Get-IpAddressInformation -IP "8.8.8.8"
    Retrieves information about the IP address "8.8.8.8" using the ip-api.com service.
    
    .NOTES
    This function requires an active internet connection to retrieve IP address information from the ip-api.com service.
    #>
    [cmdletbinding()]
    param(
        [string] $IP
    )
    try {
        $Information = Invoke-RestMethod -Method get -Uri "http://ip-api.com/json/$ip"
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning "Get-IPAddressInformation - Error occured on IP $IP`: $ErrorMessage"
    }
    return $Information
}