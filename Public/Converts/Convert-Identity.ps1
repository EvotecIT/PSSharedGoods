function Convert-Identity {
    <#
    .SYNOPSIS
    Small command that tries to resolve any given object

    .DESCRIPTION
    Small command that tries to resolve any given object - be it SID, DN, FSP or Netbiosname

    .PARAMETER Identity
    Type to resolve in form of Identity, DN, SID

    .PARAMETER SID
    Allows to pass SID directly, rather then going thru verification process

    .PARAMETER Name
    Allows to pass Name directly, rather then going thru verification process

    .PARAMETER Force
    Allows to clear cache, useful when you want to force refresh

    .EXAMPLE
    $Identity = @(
        'S-1-5-4'
        'S-1-5-4'
        'S-1-5-11'
        'S-1-5-32-549'
        'S-1-5-32-550'
        'S-1-5-32-548'
        'S-1-5-64-10'
        'S-1-5-64-14'
        'S-1-5-64-21'
        'S-1-5-18'
        'S-1-5-19'
        'S-1-5-32-544'
        'S-1-5-20-20-10-51' # Wrong SID
        'S-1-5-21-853615985-2870445339-3163598659-512'
        'S-1-5-21-3661168273-3802070955-2987026695-512'
        'S-1-5-21-1928204107-2710010574-1926425344-512'
        'CN=Test Test 2,OU=Users,OU=Production,DC=ad,DC=evotec,DC=pl'
        'Test Local Group'
        'przemyslaw.klys@evotec.pl'
        'test2'
        'NT AUTHORITY\NETWORK'
        'NT AUTHORITY\SYSTEM'
        'S-1-5-21-853615985-2870445339-3163598659-519'
        'TEST\some'
        'EVOTECPL\Domain Admins'
        'NT AUTHORITY\INTERACTIVE'
        'INTERACTIVE'
        'EVOTEC\Domain Admins'
        'EVOTECPL\Domain Admins'
        'Test\Domain Admins'
        'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' # Valid
        'CN=S-1-5-21-1928204107-2710010574-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' # not valid
        'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz' # cached
    )

    $TestOutput = Convert-Identity -Identity $Identity -Verbose

    Output:

    Name                                 SID                                            DomainName     Type                    Error
    ----                                 ---                                            ----------     ----                    -----
    NT AUTHORITY\INTERACTIVE             S-1-5-4                                                       WellKnownGroup
    NT AUTHORITY\INTERACTIVE             S-1-5-4                                                       WellKnownGroup
    NT AUTHORITY\Authenticated Users     S-1-5-11                                                      WellKnownGroup
    BUILTIN\Server Operators             S-1-5-32-549                                                  WellKnownGroup
    BUILTIN\Print Operators              S-1-5-32-550                                                  WellKnownGroup
    BUILTIN\Account Operators            S-1-5-32-548                                                  WellKnownGroup
    NT AUTHORITY\NTLM Authentication     S-1-5-64-10                                                   WellKnownGroup
    NT AUTHORITY\SChannel Authentication S-1-5-64-14                                                   WellKnownGroup
    NT AUTHORITY\Digest Authentication   S-1-5-64-21                                                   WellKnownGroup
    NT AUTHORITY\SYSTEM                  S-1-5-18                                                      WellKnownAdministrative
    NT AUTHORITY\NETWORK SERVICE         S-1-5-19                                                      WellKnownGroup
    BUILTIN\Administrators               S-1-5-32-544                                                  WellKnownAdministrative
    S-1-5-20-20-10-51                    S-1-5-20-20-10-51                                             Unknown                 Exception calling "Translate" with "1" argument(s): "Some or all identity references could not be translated."
    EVOTEC\Domain Admins                 S-1-5-21-853615985-2870445339-3163598659-512   ad.evotec.xyz  Administrative
    EVOTECPL\Domain Admins               S-1-5-21-3661168273-3802070955-2987026695-512  ad.evotec.pl   Administrative
    TEST\Domain Admins                   S-1-5-21-1928204107-2710010574-1926425344-512  test.evotec.pl Administrative
    EVOTECPL\TestingAD                   S-1-5-21-3661168273-3802070955-2987026695-1111 ad.evotec.pl   NotAdministrative
    EVOTEC\Test Local Group              S-1-5-21-853615985-2870445339-3163598659-3610  ad.evotec.xyz  NotAdministrative
    EVOTEC\przemyslaw.klys               S-1-5-21-853615985-2870445339-3163598659-1105  ad.evotec.xyz  NotAdministrative
    test2                                                                                              Unknown                 Exception calling "Translate" with "1" argument(s): "Some or all identity references could not be translated."
    NT AUTHORITY\NETWORK                 S-1-5-2                                                       WellKnownGroup
    NT AUTHORITY\SYSTEM                  S-1-5-18                                                      WellKnownAdministrative
    EVOTEC\Enterprise Admins             S-1-5-21-853615985-2870445339-3163598659-519   ad.evotec.xyz  Administrative
    TEST\some                            S-1-5-21-1928204107-2710010574-1926425344-1106 test.evotec.pl NotAdministrative
    EVOTECPL\Domain Admins               S-1-5-21-3661168273-3802070955-2987026695-512  ad.evotec.pl   Administrative
    NT AUTHORITY\INTERACTIVE             S-1-5-4                                                       WellKnownGroup
    NT AUTHORITY\INTERACTIVE             S-1-5-4                                                       WellKnownGroup
    EVOTEC\Domain Admins                 S-1-5-21-853615985-2870445339-3163598659-512   ad.evotec.xyz  Administrative
    EVOTECPL\Domain Admins               S-1-5-21-3661168273-3802070955-2987026695-512  ad.evotec.pl   Administrative
    TEST\Domain Admins                   S-1-5-21-1928204107-2710010574-1926425344-512  test.evotec.pl Administrative
    TEST\Domain Admins                   S-1-5-21-1928204107-2710010574-1926425344-512  test.evotec.pl Administrative
    S-1-5-21-1928204107-2710010574-512   S-1-5-21-1928204107-2710010574-512                            Unknown                 Exception calling "Translate" with "1" argument(s): "Some or all identity references could not be translated."
    TEST\Domain Admins                   S-1-5-21-1928204107-2710010574-1926425344-512  test.evotec.pl Administrative

    .NOTES
    General notes
    #>
    [cmdletBinding(DefaultParameterSetName = 'Identity')]
    param(
        [parameter(ParameterSetName = 'Identity', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)][string[]] $Identity,
        [parameter(ParameterSetName = 'SID', Mandatory)][System.Security.Principal.SecurityIdentifier[]] $SID,
        [parameter(ParameterSetName = 'Name', Mandatory)][string[]] $Name,
        [switch] $Force
    )
    Begin {
        # [System.Security.Principal.WellKnownSidType]::BuiltinAccountOperatorsSid
        if (-not $Script:GlobalCacheSidConvert -or $Force) {
            $Script:GlobalCacheSidConvert = @{
                # We probably don't need to build it up because4 we will be able to find it, but sometimes some of them are not available
                'NT AUTHORITY\SYSTEM'                         = [PSCustomObject] @{
                    Name       = 'BUILTIN\Administrators'
                    SID        = 'S-1-5-18'
                    DomainName = ''
                    Type       = 'WellKnownAdministrative'
                    Error      = ''
                }
                # 'NT AUTHORITY\NETWORK SERVICE'                = [PSCustomObject] @{
                #     Name       = 'NT AUTHORITY\NETWORK SERVICE'
                #     SID        = 'S-1-5-20' # or  'S-1-5-19'
                #     DomainName = ''
                #     Type       = 'WellKnownAdministrative'
                #     Error      = ''
                #}
                'BUILTIN\Administrators'                      = [PSCustomObject] @{
                    Name       = 'BUILTIN\Administrators'
                    SID        = 'S-1-5-32-544'
                    DomainName = ''
                    Type       = 'WellKnownAdministrative'
                    Error      = ''
                }
                'BUILTIN\Users'                               = [PSCustomObject] @{
                    Name       = 'BUILTIN\Users'
                    SID        = 'S-1-5-32-545'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Guests'                              = [PSCustomObject] @{
                    Name       = 'BUILTIN\Guests'
                    SID        = 'S-1-5-32-546'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Power Users'                         = [PSCustomObject] @{
                    Name       = 'BUILTIN\Power Users'
                    SID        = 'S-1-5-32-547'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Account Operators'                   = [PSCustomObject] @{
                    Name       = 'BUILTIN\Account Operators'
                    SID        = 'S-1-5-32-548'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Server Operators'                    = [PSCustomObject] @{
                    Name       = 'BUILTIN\Server Operators'
                    SID        = 'S-1-5-32-549'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Print Operators'                     = [PSCustomObject] @{
                    Name       = 'BUILTIN\Print Operators'
                    SID        = 'S-1-5-32-550'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Backup Operators'                    = [PSCustomObject] @{
                    Name       = 'BUILTIN\Backup Operators'
                    SID        = 'S-1-5-32-551'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Replicator'                          = [PSCustomObject] @{
                    Name       = 'BUILTIN\Replicators'
                    SID        = 'S-1-5-32-552'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Pre-Windows 2000 Compatible Access'  = [PSCustomObject] @{
                    Name       = 'BUILTIN\Pre-Windows 2000 Compatible Access'
                    SID        = 'S-1-5-32-554'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Remote Desktop Users'                = [PSCustomObject] @{
                    Name       = 'BUILTIN\Remote Desktop Users'
                    SID        = 'S-1-5-32-555'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Network Configuration Operators'     = [PSCustomObject] @{
                    Name       = 'BUILTIN\Network Configuration Operators'
                    SID        = 'S-1-5-32-556'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Incoming Forest Trust Builders'      = [PSCustomObject] @{
                    Name       = 'BUILTIN\Incoming Forest Trust Builders'
                    SID        = 'S-1-5-32-557'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Performance Monitor Users'           = [PSCustomObject] @{
                    Name       = 'BUILTIN\Performance Monitor Users'
                    SID        = 'S-1-5-32-558'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Performance Log Users'               = [PSCustomObject] @{
                    Name       = 'BUILTIN\Performance Log Users'
                    SID        = 'S-1-5-32-559'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Windows Authorization Access Group'  = [PSCustomObject] @{
                    Name       = 'BUILTIN\Windows Authorization Access Group'
                    SID        = 'S-1-5-32-560'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Terminal Server License Servers'     = [PSCustomObject] @{
                    Name       = 'BUILTIN\Terminal Server License Servers'
                    SID        = 'S-1-5-32-561'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Distributed COM Users'               = [PSCustomObject] @{
                    Name       = 'BUILTIN\Distributed COM Users'
                    SID        = 'S-1-5-32-562'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\IIS_IUSRS'                           = [PSCustomObject] @{
                    Name       = 'BUILTIN\IIS_IUSRS'
                    SID        = 'S-1-5-32-568'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Cryptographic Operators'             = [PSCustomObject] @{
                    Name       = 'BUILTIN\Cryptographic Operators'
                    SID        = 'S-1-5-32-569'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Event Log Readers'                   = [PSCustomObject] @{
                    Name       = 'BUILTIN\Event Log Readers'
                    SID        = 'S-1-5-32-573'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Certificate Service DCOM Access'     = [PSCustomObject] @{
                    Name       = 'BUILTIN\Certificate Service DCOM Access'
                    SID        = 'S-1-5-32-574'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\RDS Remote Access Servers'           = [PSCustomObject] @{
                    Name       = 'BUILTIN\RDS Remote Access Servers'
                    SID        = 'S-1-5-32-575'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\RDS Endpoint Servers'                = [PSCustomObject] @{
                    Name       = 'BUILTIN\RDS Endpoint Servers'
                    SID        = 'S-1-5-32-576'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\RDS Management Servers'              = [PSCustomObject] @{
                    Name       = 'BUILTIN\RDS Management Servers'
                    SID        = 'S-1-5-32-577'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Hyper-V Administrators'              = [PSCustomObject] @{
                    Name       = 'BUILTIN\Hyper-V Administrators'
                    SID        = 'S-1-5-32-578'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Access Control Assistance Operators' = [PSCustomObject] @{
                    Name       = 'BUILTIN\Access Control Assistance Operators'
                    SID        = 'S-1-5-32-579'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'BUILTIN\Remote Management Users'             = [PSCustomObject] @{
                    Name       = 'BUILTIN\Remote Management Users'
                    SID        = 'S-1-5-32-580'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'Window Manager\Window Manager Group'         = [PSCustomObject] @{
                    Name       = 'Window Manager\Window Manager Group'
                    SID        = 'S-1-5-90-0'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
                'NT SERVICE\WdiServiceHost'                   = [PSCustomObject] @{
                    Name       = 'NT SERVICE\WdiServiceHost'
                    SID        = 'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420'
                    DomainName = ''
                    Type       = 'WellKnownGroup'
                    Error      = ''
                }
            }
        }
    }
    Process {
        if ($Identity) {
            foreach ($Ident in $Identity) {
                $MatchRegex = [Regex]::Matches($Ident, "S-\d-\d+-(\d+-|){1,14}\d+")
                if ($Script:GlobalCacheSidConvert[$Ident]) {
                    # If we cached it, lets return it right away
                    Write-Verbose "Convert-Identity - Processing $Ident (Cache)"
                    $Script:GlobalCacheSidConvert[$Ident]
                } elseif ($MatchRegex.Success) {
                    # regex check if SID .. do something
                    #$MatchRegex = [Regex]::IsMatch($Ident, "S-\d-\d+-(\d+-){1,14}\d+")
                    #$MatchRegex = [Regex]::Matches($Ident, "S-\d-\d+-(\d+-){1,4}\d+")
                    Write-Verbose "Convert-Identity - Processing $Ident (SID)"
                    if ($MatchRegex.Value -ne $Ident) {
                        $Script:GlobalCacheSidConvert[$Ident] = ConvertFrom-SID -SID $MatchRegex.Value
                    } else {
                        $Script:GlobalCacheSidConvert[$Ident] = ConvertFrom-SID -SID $Ident
                    }
                    $Script:GlobalCacheSidConvert[$Ident]
                } elseif ($Ident -like '*DC=*') {
                    # check if DN
                    Write-Verbose "Convert-Identity - Processing $Ident (DistinguishedName)"
                    try {
                        $Object = [adsi]"LDAP://$($Ident)"
                        $SIDValue = [System.Security.Principal.SecurityIdentifier]::new($Object.objectSid.Value, 0).Value
                        $Script:GlobalCacheSidConvert[$Ident] = ConvertFrom-SID -SID $SIDValue
                    } catch {
                        $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                            Name       = $Ident
                            SID        = $null
                            DomainName = ''
                            Type       = 'Unknown'
                            Error      = $_.Exception.Message -replace [environment]::NewLine, ' '
                        }
                    }
                    $Script:GlobalCacheSidConvert[$Ident]
                } else {
                    # Other types
                    Write-Verbose "Convert-Identity - Processing $Ident (Other)"
                    try {
                        $SIDValue = ([System.Security.Principal.NTAccount] $Ident).Translate([System.Security.Principal.SecurityIdentifier]).Value
                        $Script:GlobalCacheSidConvert[$Ident] = ConvertFrom-SID -SID $SIDValue
                    } catch {
                        $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                            Name       = $Ident
                            SID        = $null
                            DomainName = ''
                            Type       = 'Unknown'
                            Error      = $_.Exception.Message -replace [environment]::NewLine, ' '
                        }
                    }
                    $Script:GlobalCacheSidConvert[$Ident]
                }
            }
        } else {
            if ($SID) {
                foreach ($S in $SID) {
                    if ($Script:GlobalCacheSidConvert[$S]) {
                        $Script:GlobalCacheSidConvert[$S]
                    } else {
                        $Script:GlobalCacheSidConvert[$S] = ConvertFrom-SID -SID $S
                        $Script:GlobalCacheSidConvert[$S]
                    }
                }
            } else {
                foreach ($Ident in $Name) {
                    if ($Script:GlobalCacheSidConvert[$Ident]) {
                        $Script:GlobalCacheSidConvert[$Ident]
                    } else {
                        $Script:GlobalCacheSidConvert[$Ident] = ([System.Security.Principal.NTAccount] $Ident).Translate([System.Security.Principal.SecurityIdentifier]).Value
                        $Script:GlobalCacheSidConvert[$Ident]
                    }
                }
            }
        }
    }
    End {}
}