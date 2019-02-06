
function Find-ServerTypes {
    [cmdletbinding()]
    param(
        [string[]][ValidateSet('All', 'ADConnect', 'DomainController', 'Exchange', 'Hyper-V', 'RDSLicense', 'SQL', 'VirtualMachine')] $Type = 'All'
    )
    $Forest = Get-ADForest

    foreach ($Domain in $Forest.Domains) {
        try {
            $DomainInformation = Get-ADDomain -Server $Domain -ErrorAction Stop
        } catch {
            Write-Warning "Find-ServerTypes - Domain $Domain couldn't be reached. Skipping"
            continue
        }

        try {
            $ServiceConnectionPoint = Get-ADObject -Filter 'ObjectClass -eq "serviceConnectionPoint"' -ErrorAction Stop -Server $Domain
            foreach ($Point in $ServiceConnectionPoint) {  
                $Temporary = $Point.DistinguishedName.split(",")            
                $DistinguishedName = $Temporary[1..$Temporary.Count] -join ","    
                $Point | Add-Member -MemberType 'NoteProperty' -Name 'DN' -Value $DistinguishedName -Force
            }
        } catch {
            Write-Error "Find-ServerTypes - Get-ADObject command failed. Terminating. Error $_"
            return
        }

        $ADConnect = Find-ADConnectServer
        $Computers = Get-ADComputer -Filter * -Properties Name, DNSHostName, OperatingSystem, DistinguishedName, ServicePrincipalName -Server $Domain
        $Servers = foreach ($Computer in $Computers) {
            $Services = foreach ($Service in $Computer.servicePrincipalName) {
                ($Service -split '/')[0]
            }
            [PSCustomObject] @{
                Name                   = $Computer.Name
                FQDN                   = $Computer.DNSHostName
                OperatingSystem        = $Computer.OperatingSystem
                DistinguishedName      = $Computer.DistinguishedName
                Enabled                = $Computer.Enabled
                IsExchange             = if ($Services -like '*ExchangeMDB*' -or $Services -like '*ExchangeRFR*') { $true } else { $false }
                IsSql                  = if ($Services -like '*MSSql*') { $true } else { $false }
                IsVM                   = if ($ServiceConnectionPoint.DN -eq $Computer.DistinguishedName -and $ServiceConnectionPoint.Name -eq 'Windows Virtual Machine') { $true } else { $false } 
                IsHyperV               = if ($Services -like '*Hyper-V Replica*') { $true } else { $false }
                IsSPHyperV             = if ($ServiceConnectionPoint.DN -eq $Computer.DistinguishedName -and $ServiceConnectionPoint.Name -eq 'Microsoft Hyper-V') { $true } else { $false } 
                IsRDSLicense           = if ($ServiceConnectionPoint.DN -eq $Computer.DistinguishedName -and $ServiceConnectionPoint.Name -eq 'TermServLicensing') { $true } else { $false } 
                #IsDC                   = if ($Services -like '*ldap*' -and $Services -like '*DNS*') { $true } else { $false }
                IsDC                   = if ($DomainInformation.ReplicaDirectoryServers -contains $Computer.DNSHostName) { $true } else { $false }  
                IsADConnect            = if ($ADConnect.FQDN -eq $Computer.DNSHostName) { $true } else { $false }
                Forest                 = $Forest.Name
                Domain                 = $Domain
                ServicePrincipalName   = ($Services | Sort-Object -Unique) -Join ','
                ServiceConnectionPoint = ($ServiceConnectionPoint | Where-Object { $_.DN -eq $Computer.DistinguishedName }).Name -join ','
            }
        }
        if ($Type -eq 'All') {
            $Servers
        } else {
            if ($Type -contains 'SQL') {
                $Servers | Where-Object { $_.IsSql -eq $true }
            }
            if ($Type -contains 'Exchange' ) {
                $Servers | Where-Object { $_.IsExchange -eq $true } 
            }
            if ($Type -contains 'Hyper-V') {
                $Servers | Where-Object { $_.IsHyperV -eq $true -or $_.IsSPHyperV -eq $true } 
            }
            if ($Type -contains 'VirtualMachine') {
                $Servers | Where-Object { $_.IsVM -eq $true } 
            }
            if ($Type -contains 'RDSLicense') {
                $Servers | Where-Object { $_.IsRDSLicense -eq $true } 
            }
            if ($Type -contains 'DomainController') {
                $Servers | Where-Object { $_.IsDC -eq $true } 
            }
            if ($Type -contains 'DomainController') {
                $Servers | Where-Object { $_.IsDC -eq $true } 
            }
            if ($Type -contains 'ADConnect') {
                $Servers | Where-Object { $_.IsADConnect -eq $true } 
            }
        }
    }
}