function Get-WinADForestDetails {
    [CmdletBinding()]
    param(
        [string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain')][string[]] $IncludeDomains,
        [alias('DomainControllers')][string[]] $IncludeDomainControllers,
        [switch] $SkipRODC,
        [string] $Filter = '*',
        [switch] $TestAvailability,
        [ValidateSet('All', 'Ping', 'WinRM', 'PortOpen', 'Ping+WinRM', 'Ping+PortOpen', 'WinRM+PortOpen')] $Test = 'All',
        [int[]] $Ports = 135,
        [int] $PortsTimeout = 100,
        [int] $PingCount = 1
    )
    if ($Global:ProgressPreference -ne 'SilentlyContinue') {
        $TemporaryProgress = $Global:ProgressPreference
        $Global:ProgressPreference = 'SilentlyContinue'
    }

    $Findings = [ordered] @{ }

    if ($Forest) {
        $DC = Get-ADDomainController -Discover -DomainName $Forest
        $ForestInformation = Get-ADForest -ErrorAction Stop -Server $DC.HostName[0] -Identity $Forest
    } else {
        $DC = Get-ADDomainController -Discover
        $ForestInformation = Get-ADForest -ErrorAction Stop -Server $DC.HostName[0]
    }
    $Findings['Forest'] = $ForestInformation
    $Findings.Domains = foreach ($_ in $ForestInformation.Domains) {
        if ($IncludeDomains) {
            if ($_ -in $IncludeDomains) {
                $_.ToLower()
            }
            # We skip checking for exclusions
            continue
        }
        if ($_ -notin $ExcludeDomains) {
            $_.ToLower()
        }
    }
    foreach ($Domain in $Findings.Domains) {
        $DC = Get-ADDomainController -DomainName $Domain -Discover
        [Array] $AllDC = try {
            $DomainControllers = Get-ADDomainController -Filter $Filter -Server $DC.HostName[0]
            foreach ($S in $DomainControllers) {
                if ($IncludeDomainControllers.Count -gt 0) {
                    if ($S.HostName -notin $IncludeDomainControllers) {
                        continue
                    }
                }
                if ($S.HostName -in $ExcludeDomainControllers) {
                    continue
                }
                $Server = [ordered] @{
                    Domain                 = $Domain
                    HostName               = $S.HostName
                    Name                   = $S.Name
                    Forest                 = $ForestInformation.RootDomain
                    Site                   = $S.Site
                    IPV4Address            = $S.IPV4Address
                    IPV6Address            = $S.IPV6Address
                    IsGlobalCatalog        = $S.IsGlobalCatalog
                    IsReadOnly             = $S.IsReadOnly
                    IsSchemaMaster         = ($S.OperationMasterRoles -contains 'SchemaMaster')
                    IsDomainNamingMaster   = ($S.OperationMasterRoles -contains 'DomainNamingMaster')
                    IsPDC                  = ($S.OperationMasterRoles -contains 'PDCEmulator')
                    IsRIDMaster            = ($S.OperationMasterRoles -contains 'RIDMaster')
                    IsInfrastructureMaster = ($S.OperationMasterRoles -contains 'InfrastructureMaster')
                    LdapPort               = $S.LdapPort
                    SslPort                = $S.SslPort
                    Pingable               = $null
                    WinRM                  = $null
                    PortOpen               = $null
                    Comment                = ''
                }
                if ($TestAvailability) {
                    if ($Test -eq 'All' -or $Test -like 'Ping*') {
                        $Server.Pingable = Test-Connection -ComputerName $Server.IPV4Address -Quiet -Count $PingCount
                    }
                    if ($Test -eq 'All' -or $Test -like '*WinRM*') {
                        $Server.WinRM = (Test-WinRM -ComputerName $Server.HostName).Status
                    }
                    if ($Test -eq 'All' -or '*PortOpen*') {
                        $Server.PortOpen = (Test-ComputerPort -Server $Server.HostName -PortTCP $Ports -Timeout $PortsTimeout).Status
                    }
                }
                [PSCustomObject] $Server
            }
        } catch {
            [PSCustomObject]@{
                Domain                   = $Domain
                HostName                 = ''
                Name                     = ''
                Forest                   = $ForestInformation.RootDomain
                IPV4Address              = ''
                IPV6Address              = ''
                IsGlobalCatalog          = ''
                IsReadOnly               = ''
                Site                     = ''
                SchemaMaster             = $false
                DomainNamingMasterMaster = $false
                PDCEmulator              = $false
                RIDMaster                = $false
                InfrastructureMaster     = $false
                LdapPort                 = ''
                SslPort                  = ''
                Pingable                 = $null
                WinRM                    = $null
                PortOpen                 = $null
                Comment                  = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            }
        }
        if ($SkipRODC) {
            $Findings[$Domain] = $AllDC | Where-Object { $_.IsReadOnly -eq $false }
        } else {
            $Findings[$Domain] = $AllDC
        }
    }
    # Bring back setting as per default
    if ($TemporaryProgress) {
        $Global:ProgressPreference = $TemporaryProgress
    }

    $Findings
}
<#
$F = Get-WinADForest -SkipRODC -ExcludeDomainControllers 'AD1.ad.evotec.xyz' #-TestAvailability #-IncludeDomains 'ad.evotec.xyz'
$F | Format-Table -AutoSize

$F.'ad.evotec.xyz' | Format-Table -AutoSize *
$F.'ad.evotec.pl' | Format-Table -AutoSize *
#>