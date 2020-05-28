function Get-WinADForestDetails {
    [CmdletBinding()]
    param(
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [alias('DomainControllers', 'ComputerName')][string[]] $IncludeDomainControllers,
        [switch] $SkipRODC,
        [string] $Filter = '*',
        [switch] $TestAvailability,
        [ValidateSet('All', 'Ping', 'WinRM', 'PortOpen', 'Ping+WinRM', 'Ping+PortOpen', 'WinRM+PortOpen')] $Test = 'All',
        [int[]] $Ports = 135,
        [int] $PortsTimeout = 100,
        [int] $PingCount = 1,
        [switch] $Extended,
        [System.Collections.IDictionary] $ExtendedForestInformation
    )
    if ($Global:ProgressPreference -ne 'SilentlyContinue') {
        $TemporaryProgress = $Global:ProgressPreference
        $Global:ProgressPreference = 'SilentlyContinue'
    }

    if (-not $ExtendedForestInformation) {
        # standard situation, building data from AD
        $Findings = [ordered] @{ }
        try {
            if ($Forest) {
                $ForestInformation = Get-ADForest -ErrorAction Stop -Identity $Forest
            } else {
                $ForestInformation = Get-ADForest -ErrorAction Stop
            }
            <#
            $ForestInformation = [ordered] @{
                ApplicationPartitions = $ForestInf.ApplicationPartitions | ForEach-Object -Process { $_ } # : {DC=DomainDnsZones,DC=ad,DC=evotec,DC=xyz, DC=DomainDnsZones,DC=ad,DC=evotec,DC=pl, DC=ForestDnsZones,DC=ad,DC=evotec,DC=xyz}
                CrossForestReferences = $ForestInf.CrossForestReferences | ForEach-Object -Process { $_ } # : {}
                DomainNamingMaster    = $ForestInf.DomainNamingMaster    # : AD1.ad.evotec.xyz
                Domains               = $ForestInf.Domains | ForEach-Object -Process { $_ }              # : {ad.evotec.xyz, ad.evotec.pl}
                ForestMode            = $ForestInf.ForestMode            # : Windows2012R2Forest
                GlobalCatalogs        = $ForestInf.GlobalCatalogs | ForEach-Object -Process { $_ }        # : {AD1.ad.evotec.xyz, AD2.ad.evotec.xyz, ADRODC.ad.evotec.pl, AD3.ad.evotec.xyz...}
                Name                  = $ForestInf.Name                  # : ad.evotec.xyz
                PartitionsContainer   = $ForestInf.PartitionsContainer   # : CN=Partitions,CN=Configuration,DC=ad,DC=evotec,DC=xyz
                RootDomain            = $ForestInf.RootDomain            # : ad.evotec.xyz
                SchemaMaster          = $ForestInf.SchemaMaster          # : AD1.ad.evotec.xyz
                Sites                 = $ForestInf.Sites | ForEach-Object -Process { $_ }                # : {KATOWICE-1, KATOWICE-2}
                SPNSuffixes           = $ForestInf.SPNSuffixes | ForEach-Object -Process { $_ }         # : {}
                UPNSuffixes           = $ForestInf.UPNSuffixes | ForEach-Object -Process { $_ }          # : {myneva.eu, single.evotec.xyz, newUPN@com, evotec.xyz...}
            }
            #>
        } catch {
            Write-Warning "Get-WinADForestDetails - Error discovering DC for Forest - $($_.Exception.Message)"
            return
        }
        if (-not $ForestInformation) {
            return
        }
        $Findings['Forest'] = $ForestInformation
        $Findings['ForestDomainControllers'] = @()
        $Findings['QueryServers'] = @{ }
        $Findings['DomainDomainControllers'] = @{ }
        [Array] $Findings['Domains'] = foreach ($_ in $ForestInformation.Domains) {
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
        # We want to have QueryServers always available for all domains
        foreach ($Domain in $ForestInformation.Domains) {
            try {
                $DC = Get-ADDomainController -DomainName $Domain -Discover -ErrorAction Stop

                $OrderedDC = [ordered] @{
                    Domain      = $DC.Domain
                    Forest      = $DC.Forest
                    HostName    = [Array] $DC.HostName
                    IPv4Address = $DC.IPv4Address
                    IPv6Address = $DC.IPv6Address
                    Name        = $DC.Name
                    Site        = $DC.Site
                }

            } catch {
                Write-Warning "Get-WinADForestDetails - Error discovering DC for domain $Domain - $($_.Exception.Message)"
                continue
            }
            if ($Domain -eq $Findings['Forest']['Name']) {
                $Findings['QueryServers']['Forest'] = $OrderedDC
            }
            $Findings['QueryServers']["$Domain"] = $OrderedDC
        }


        [Array] $Findings['ForestDomainControllers'] = foreach ($Domain in $Findings.Domains) {
            <#
            try {
                $DC = Get-ADDomainController -DomainName $Domain -Discover -ErrorAction Stop

                $OrderedDC = [ordered] @{
                    Domain      = $DC.Domain
                    Forest      = $DC.Forest
                    HostName    = [Array] $DC.HostName
                    IPv4Address = $DC.IPv4Address
                    IPv6Address = $DC.IPv6Address
                    Name        = $DC.Name
                    Site        = $DC.Site
                }

            } catch {
                Write-Warning "Get-WinADForestDetails - Error discovering DC for domain $Domain - $($_.Exception.Message)"
                continue
            }
            if ($Domain -eq $Findings['Forest']['Name']) {
                $Findings['QueryServers']['Forest'] = $OrderedDC
            }
            $Findings['QueryServers']["$Domain"] = $OrderedDC
            #>
            $QueryServer = $Findings['QueryServers'][$Domain]['HostName'][0]

            [Array] $AllDC = try {
                try {
                    $DomainControllers = Get-ADDomainController -Filter $Filter -Server $QueryServer -ErrorAction Stop
                } catch {
                    Write-Warning "Get-WinADForestDetails - Error listing DCs for domain $Domain - $($_.Exception.Message)"
                    continue
                }
                foreach ($S in $DomainControllers) {
                    if ($IncludeDomainControllers.Count -gt 0) {
                        If (-not $IncludeDomainControllers[0].Contains('.')) {
                            if ($S.Name -notin $IncludeDomainControllers) {
                                continue
                            }
                        } else {
                            if ($S.HostName -notin $IncludeDomainControllers) {
                                continue
                            }
                        }
                    }
                    if ($ExcludeDomainControllers.Count -gt 0) {
                        If (-not $ExcludeDomainControllers[0].Contains('.')) {
                            if ($S.Name -in $ExcludeDomainControllers) {
                                continue
                            }
                        } else {
                            if ($S.HostName -in $ExcludeDomainControllers) {
                                continue
                            }
                        }
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
                        OperatingSystem        = $S.OperatingSystem
                        OperatingSystemVersion = $S.OperatingSystemVersion
                        OperatingSystemLong    = ConvertTo-OperatingSystem -OperatingSystem $S.OperatingSystem -OperatingSystemVersion $S.OperatingSystemVersion
                        LdapPort               = $S.LdapPort
                        SslPort                = $S.SslPort
                        DistinguishedName      = $S.ComputerObjectDN
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
                    DistinguishedName        = ''
                    Pingable                 = $null
                    WinRM                    = $null
                    PortOpen                 = $null
                    Comment                  = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                }
            }
            if ($SkipRODC) {
                [Array] $Findings['DomainDomainControllers'][$Domain] = $AllDC | Where-Object { $_.IsReadOnly -eq $false }
                #$Findings[$Domain] = $AllDC | Where-Object { $_.IsReadOnly -eq $false }
            } else {
                [Array] $Findings['DomainDomainControllers'][$Domain] = $AllDC
                #$Findings[$Domain] = $AllDC
            }
            # Building all DCs for whole Forest
            [Array] $Findings['DomainDomainControllers'][$Domain]
        }
        if ($Extended) {
            $Findings['DomainsExtended'] = @{ }
            $Findings['DomainsExtendedNetBIOS'] = @{ }
            foreach ($DomainEx in $Findings['Domains']) {
                try {
                    #$Findings['DomainsExtended'][$DomainEx] = Get-ADDomain -Server $Findings['QueryServers'][$DomainEx].HostName[0]

                    $Findings['DomainsExtended'][$DomainEx] = Get-ADDomain -Server $Findings['QueryServers'][$DomainEx].HostName[0] | ForEach-Object {
                        # We need to use ForEach-Object to convert ADPropertyValueCollection to normal strings. Otherwise Copy-Dictionary fails
                        #True     False    ADPropertyValueCollection                System.Collections.CollectionBase

                        [ordered] @{
                            AllowedDNSSuffixes                 = $_.AllowedDNSSuffixes | ForEach-Object -Process { $_ }                #: { }
                            ChildDomains                       = $_.ChildDomains | ForEach-Object -Process { $_ }                      #: { }
                            ComputersContainer                 = $_.ComputersContainer                 #: CN = Computers, DC = ad, DC = evotec, DC = xyz
                            DeletedObjectsContainer            = $_.DeletedObjectsContainer            #: CN = Deleted Objects, DC = ad, DC = evotec, DC = xyz
                            DistinguishedName                  = $_.DistinguishedName                  #: DC = ad, DC = evotec, DC = xyz
                            DNSRoot                            = $_.DNSRoot                            #: ad.evotec.xyz
                            DomainControllersContainer         = $_.DomainControllersContainer         #: OU = Domain Controllers, DC = ad, DC = evotec, DC = xyz
                            DomainMode                         = $_.DomainMode                         #: Windows2012R2Domain
                            DomainSID                          = $_.DomainSID.Value                        #: S - 1 - 5 - 21 - 853615985 - 2870445339 - 3163598659
                            ForeignSecurityPrincipalsContainer = $_.ForeignSecurityPrincipalsContainer #: CN = ForeignSecurityPrincipals, DC = ad, DC = evotec, DC = xyz
                            Forest                             = $_.Forest                             #: ad.evotec.xyz
                            InfrastructureMaster               = $_.InfrastructureMaster               #: AD1.ad.evotec.xyz
                            LastLogonReplicationInterval       = $_.LastLogonReplicationInterval       #:
                            LinkedGroupPolicyObjects           = $_.LinkedGroupPolicyObjects | ForEach-Object -Process { $_ }           #:
                            LostAndFoundContainer              = $_.LostAndFoundContainer              #: CN = LostAndFound, DC = ad, DC = evotec, DC = xyz
                            ManagedBy                          = $_.ManagedBy                          #:
                            Name                               = $_.Name                               #: ad
                            NetBIOSName                        = $_.NetBIOSName                        #: EVOTEC
                            ObjectClass                        = $_.ObjectClass                        #: domainDNS
                            ObjectGUID                         = $_.ObjectGUID                         #: bc875580 - 4c70-41ad-a487-c57337e26024
                            ParentDomain                       = $_.ParentDomain                       #:
                            PDCEmulator                        = $_.PDCEmulator                        #: AD1.ad.evotec.xyz
                            PublicKeyRequiredPasswordRolling   = $_.PublicKeyRequiredPasswordRolling | ForEach-Object -Process { $_ }   #:
                            QuotasContainer                    = $_.QuotasContainer                    #: CN = NTDS Quotas, DC = ad, DC = evotec, DC = xyz
                            ReadOnlyReplicaDirectoryServers    = $_.ReadOnlyReplicaDirectoryServers | ForEach-Object -Process { $_ }    #: { }
                            ReplicaDirectoryServers            = $_.ReplicaDirectoryServers | ForEach-Object -Process { $_ }           #: { AD1.ad.evotec.xyz, AD2.ad.evotec.xyz, AD3.ad.evotec.xyz }
                            RIDMaster                          = $_.RIDMaster                          #: AD1.ad.evotec.xyz
                            SubordinateReferences              = $_.SubordinateReferences | ForEach-Object -Process { $_ }            #: { DC = ForestDnsZones, DC = ad, DC = evotec, DC = xyz, DC = DomainDnsZones, DC = ad, DC = evotec, DC = xyz, CN = Configuration, DC = ad, DC = evotec, DC = xyz }
                            SystemsContainer                   = $_.SystemsContainer                   #: CN = System, DC = ad, DC = evotec, DC = xyz
                            UsersContainer                     = $_.UsersContainer                     #: CN = Users, DC = ad, DC = evotec, DC = xyz
                        }
                    }

                    $NetBios = $Findings['DomainsExtended'][$DomainEx]['NetBIOSName']
                    $Findings['DomainsExtendedNetBIOS'][$NetBios] = $Findings['DomainsExtended'][$DomainEx]
                } catch {
                    Write-Warning "Get-WinADForestDetails - Error gathering Domain Information for domain $DomainEx - $($_.Exception.Message)"
                    continue
                }
            }
        }
        # Bring back setting as per default
        if ($TemporaryProgress) {
            $Global:ProgressPreference = $TemporaryProgress
        }

        $Findings
    } else {
        # this takes care of limiting output to only what we requested, but based on prior input
        # this makes sure we ask once for all AD stuff and then subsequent calls just filter out things
        # this should be much faster then asking again and again for stuff from AD
        $Findings = Copy-DictionaryManual -Dictionary $ExtendedForestInformation
        [Array] $Findings['Domains'] = foreach ($_ in $Findings.Domains) {
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
        # Now that we have Domains we need to remove all DCs that are not from domains we excluded or included
        foreach ($_ in [string[]] $Findings.DomainDomainControllers.Keys) {
            if ($_ -notin $Findings.Domains) {
                $Findings.DomainDomainControllers.Remove($_)
            }
        }
        # Same as above but for query servers - we don't remove queried servers
        #foreach ($_ in [string[]] $Findings.QueryServers.Keys) {
        #    if ($_ -notin $Findings.Domains -and $_ -ne 'Forest') {
        #        $Findings.QueryServers.Remove($_)
        #    }
        #}
        # Now that we have Domains we need to remove all Domains that are excluded or included
        foreach ($_ in [string[]] $Findings.DomainsExtended.Keys) {
            if ($_ -notin $Findings.Domains) {
                $Findings.DomainsExtended.Remove($_)
                $NetBiosName = $Findings.DomainsExtended.$_.'NetBIOSName'
                if ($NetBiosName) {
                    $Findings.DomainsExtendedNetBIOS.Remove($NetBiosName)
                }
            }
        }
        [Array] $Findings['ForestDomainControllers'] = foreach ($Domain in $Findings.Domains) {
            [Array] $AllDC = foreach ($S in $Findings.DomainDomainControllers["$Domain"]) {
                if ($IncludeDomainControllers.Count -gt 0) {
                    If (-not $IncludeDomainControllers[0].Contains('.')) {
                        if ($S.Name -notin $IncludeDomainControllers) {
                            continue
                        }
                    } else {
                        if ($S.HostName -notin $IncludeDomainControllers) {
                            continue
                        }
                    }
                }
                if ($ExcludeDomainControllers.Count -gt 0) {
                    If (-not $ExcludeDomainControllers[0].Contains('.')) {
                        if ($S.Name -in $ExcludeDomainControllers) {
                            continue
                        }
                    } else {
                        if ($S.HostName -in $ExcludeDomainControllers) {
                            continue
                        }
                    }
                }
                $S
            }
            if ($SkipRODC) {
                [Array] $Findings['DomainDomainControllers'][$Domain] = $AllDC | Where-Object { $_.IsReadOnly -eq $false }
            } else {
                [Array] $Findings['DomainDomainControllers'][$Domain] = $AllDC
            }
            # Building all DCs for whole Forest
            [Array] $Findings['DomainDomainControllers'][$Domain]
        }
        $Findings
    }
}

#$F = Get-WinADForestDetails -Forest 'test.evotec.pl'
#$F

#$F.DomainDomainControllers['ad.evotec.xyz'] | Format-Table -AutoSize
#$F

<#
$F = Get-WinADForestDetails -SkipRODC -ExcludeDomainControllers 'AD1.ad.evotec.xyz' #-TestAvailability #-IncludeDomains 'ad.evotec.xyz'
$F | Format-Table -AutoSize

$F.'ad.evotec.xyz' | Format-Table -AutoSize *
$F.'ad.evotec.pl' | Format-Table -AutoSize *

#>