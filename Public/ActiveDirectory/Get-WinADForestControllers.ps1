function Get-WinADForestControllers {
    [alias('Get-WinADDomainControllers')]
    <#
    .SYNOPSIS

    .DESCRIPTION
    Long description

    .PARAMETER TestAvailability
    Parameter description

    .EXAMPLE
    Get-WinADForestControllers -TestAvailability | Format-Table

    .EXAMPLE
    Get-WinADDomainControllers

    .EXAMPLE
    Get-WinADDomainControllers -Credential $Credential

    .EXAMPLE
    Get-WinADDomainControllers | Format-Table *

    Output:

    Domain        HostName          Forest        IPV4Address     IsGlobalCatalog IsReadOnly SchemaMaster DomainNamingMasterMaster PDCEmulator RIDMaster InfrastructureMaster Comment
    ------        --------          ------        -----------     --------------- ---------- ------------ ------------------------ ----------- --------- -------------------- -------
    ad.evotec.xyz AD1.ad.evotec.xyz ad.evotec.xyz 192.168.240.189            True      False         True                     True        True      True                 True
    ad.evotec.xyz AD2.ad.evotec.xyz ad.evotec.xyz 192.168.240.192            True      False        False                    False       False     False                False
    ad.evotec.pl                    ad.evotec.xyz                                                   False                    False       False     False                False Unable to contact the server. This may be becau...

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string[]] $Domain,
        [switch] $TestAvailability,
        [switch] $SkipEmpty,
        [pscredential] $Credential
    )
    try {
        if($Credential){
            $Forest = Get-ADForest -Credential $Credential
        }
        else{
            $Forest = Get-ADForest
        }
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
            $LocalServer = Get-ADDomainController -Discover -DomainName $D -ErrorAction Stop -Writable
            if($Credential){
                $DC = Get-ADDomainController -Server $LocalServer.HostName[0] -Credential $Credential -Filter * -ErrorAction Stop
            }
            else{
               $DC = Get-ADDomainController -Server $LocalServer.HostName[0] -Filter * -ErrorAction Stop 
            }
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
