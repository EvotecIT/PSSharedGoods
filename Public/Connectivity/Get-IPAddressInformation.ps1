function Get-IPAddressInformation {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER IP
    Parameter description
    
    .EXAMPLE
    Get-IpAddressInformation -IP 1.1.1.1

    
    .NOTES
    General notes
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