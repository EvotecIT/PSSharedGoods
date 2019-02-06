function Find-ExchangeServer {
    <#
    .SYNOPSIS
    Find Exchange Servers in Active Directory
    
    .DESCRIPTION
    Find Exchange Servers in Active Directory
    
    .EXAMPLE
    Find-ExchangeServer

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(

    )
    $ExchangeServers = Get-ADGroup -Identity "Exchange Servers" | Get-ADGroupMember | Where-Object { $_.objectClass -eq 'computer' }
    foreach ($Server in $ExchangeServers) {
        $Data = Get-ADComputer -Identity $Server.SamAccountName -Properties Name, DNSHostName, OperatingSystem, DistinguishedName, ServicePrincipalName
        [PSCustomObject] @{
            Name              = $Data.Name
            FQDN              = $Data.DNSHostName
            OperatingSystem   = $Data.OperatingSystem
            DistinguishedName = $Data.DistinguishedName
            Enabled           = $Data.Enabled
        }
    }
}

Find-ExchangeServer | Format-Table -Autosize *