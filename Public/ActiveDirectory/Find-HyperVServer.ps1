function Find-HyperVServer {            
    [cmdletbinding()]            
    param()            
    try {            
        $ADObjects = Get-ADObject -Filter 'ObjectClass -eq "serviceConnectionPoint" -and Name -eq "Microsoft Hyper-V"' -ErrorAction Stop            
    } catch {            
        Write-Error "Error: $_"            
    }            
    foreach ($Server in $ADObjects) {            
        $Temporary = $Server.DistinguishedName.split(",")            
        $DistinguishedName = $Temporary[1..$Temporary.Count] -join ","        
        $Data = Get-ADComputer -Identity $DistinguishedName -Properties Name, DNSHostName, OperatingSystem, DistinguishedName, ServicePrincipalName       
        [PSCustomObject] @{
            Name              = $Data.Name
            FQDN              = $Data.DNSHostName
            OperatingSystem   = $Data.OperatingSystem
            DistinguishedName = $Data.DistinguishedName
            Enabled           = $Data.Enabled
        }
    }      
}
