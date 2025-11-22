function Get-WinADForestControllers {
    <#
    .SYNOPSIS
    Retrieves information about domain controllers in the specified domain(s).

    .DESCRIPTION
    This function retrieves detailed information about domain controllers in the specified domain(s), including hostname, IP addresses, roles, and other relevant details.

    .PARAMETER TestAvailability
    Specifies whether to test the availability of domain controllers.

    .EXAMPLE
    Get-WinADForestControllers -TestAvailability
    Tests the availability of domain controllers in the forest.

    .EXAMPLE
    Get-WinADDomainControllers
    Retrieves information about all domain controllers in the forest.

    .EXAMPLE
    Get-WinADDomainControllers -Credential $Credential
    Retrieves information about all domain controllers in the forest using specified credentials.

    .PARAMETER Credential
    Alternate credentials for forest and domain controller discovery.

    .EXAMPLE
    Get-WinADDomainControllers | Format-Table *
    Displays detailed information about all domain controllers in a tabular format.

    Output:
    Domain        HostName          Forest        IPV4Address     IsGlobalCatalog IsReadOnly SchemaMaster DomainNamingMasterMaster PDCEmulator RIDMaster InfrastructureMaster Comment
    ------        --------          ------        -----------     --------------- ---------- ------------ ------------------------ ----------- --------- -------------------- -------
    ad.evotec.xyz AD1.ad.evotec.xyz ad.evotec.xyz 192.168.240.189            True      False         True                     True        True      True                 True
    ad.evotec.xyz AD2.ad.evotec.xyz ad.evotec.xyz 192.168.240.192            True      False        False                    False       False     False                False
    ad.evotec.pl                    ad.evotec.xyz                                                   False                    False       False     False                False Unable to contact the server. This may be becau...

    .NOTES
    This function provides essential information about domain controllers in the forest.
    #>
    [alias('Get-WinADDomainControllers')]
    [CmdletBinding()]
    param(
        [string[]] $Domain,
        [switch] $TestAvailability,
        [switch] $SkipEmpty,
        [pscredential] $Credential
    )
    $credentialSplat = @{}
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $credentialSplat['Credential'] = $Credential
    }
    try {
        $Forest = Get-ADForest @credentialSplat
        if (-not $Domain) {
            $Domain = $Forest.Domains
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning "Get-WinADForestControllers - Couldn't use Get-ADForest feature. Error: $ErrorMessage"
        return
    }
    $Servers = foreach ($D in $Domain) {
        try {
            $LocalServer = Get-ADDomainController -Discover -DomainName $D -ErrorAction Stop -Writable @credentialSplat
            $DC = Get-ADDomainController -Server $LocalServer.HostName[0] -Filter * -ErrorAction Stop @credentialSplat
            foreach ($S in $DC) {
                $Server = [ordered] @{
                    Domain               = $D
                    HostName             = $S.HostName
                    Name                 = $S.Name
                    Forest               = $Forest.RootDomain
                    IPV4Address          = $S.IPV4Address
                    IPV6Address          = $S.IPV6Address
                    IsGlobalCatalog      = $S.IsGlobalCatalog
                    IsReadOnly           = $S.IsReadOnly
                    Site                 = $S.Site
                    SchemaMaster         = ($S.OperationMasterRoles -contains 'SchemaMaster')
                    DomainNamingMaster   = ($S.OperationMasterRoles -contains 'DomainNamingMaster')
                    PDCEmulator          = ($S.OperationMasterRoles -contains 'PDCEmulator')
                    RIDMaster            = ($S.OperationMasterRoles -contains 'RIDMaster')
                    InfrastructureMaster = ($S.OperationMasterRoles -contains 'InfrastructureMaster')
                    LdapPort             = $S.LdapPort
                    SslPort              = $S.SslPort
                    Pingable             = $null
                    Comment              = ''
                }
                if ($TestAvailability) {
                    $Server['Pingable'] = foreach ($_ in $Server.IPV4Address) {
                        Test-Connection -Count 1 -Server $_ -Quiet -ErrorAction SilentlyContinue
                    }
                }
                [PSCustomObject] $Server
            }
        } catch {
            [PSCustomObject]@{
                Domain                   = $D
                HostName                 = ''
                Name                     = ''
                Forest                   = $Forest.RootDomain
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
                Comment                  = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            }
        }
    }
    if ($SkipEmpty) {
        return $Servers | Where-Object { $_.HostName -ne '' }
    }
    return $Servers
}
