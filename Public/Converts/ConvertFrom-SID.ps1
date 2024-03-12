function ConvertFrom-SID {
    <#
    .SYNOPSIS
    Small command that can resolve SID values

    .DESCRIPTION
    Small command that can resolve SID values

    .PARAMETER SID
    Value to resolve

    .PARAMETER OnlyWellKnown
    Only resolve SID when it's well know SID. Otherwise return $null

    .PARAMETER OnlyWellKnownAdministrative
    Only resolve SID when it's administrative well know SID. Otherwise return $null

    .PARAMETER DoNotResolve
    Uses only dicrionary values without querying AD

    .EXAMPLE
    ConvertFrom-SID -SID 'S-1-5-8', 'S-1-5-9', 'S-1-5-11', 'S-1-5-18', 'S-1-1-0' -DoNotResolve

    .NOTES
    General notes
    #>
    [cmdletbinding(DefaultParameterSetName = 'Standard')]
    param(
        [Parameter(ParameterSetName = 'Standard')]
        [Parameter(ParameterSetName = 'OnlyWellKnown')]
        [Parameter(ParameterSetName = 'OnlyWellKnownAdministrative')]
        [string[]] $SID,
        [Parameter(ParameterSetName = 'OnlyWellKnown')][switch] $OnlyWellKnown,
        [Parameter(ParameterSetName = 'OnlyWellKnownAdministrative')][switch] $OnlyWellKnownAdministrative,
        [Parameter(ParameterSetName = 'Standard')][switch] $DoNotResolve
    )
    # https://support.microsoft.com/en-au/help/243330/well-known-security-identifiers-in-windows-operating-systems
    $WellKnownAdministrative = @{
        'S-1-5-18'     = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\SYSTEM'
            SID        = 'S-1-5-18'
            DomainName = ''
            Type       = 'WellKnownAdministrative'
            Error      = ''
        }
        'S-1-5-32-544' = [PSCustomObject] @{
            Name       = 'BUILTIN\Administrators'
            SID        = 'S-1-5-32-544'
            DomainName = ''
            Type       = 'WellKnownAdministrative'
            Error      = ''
        }
    }
    $wellKnownSIDs = @{
        'S-1-0'                                                           = [PSCustomObject] @{
            Name       = 'Null AUTHORITY'
            SID        = 'S-1-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-0-0'                                                         = [PSCustomObject] @{
            Name       = 'NULL SID'
            SID        = 'S-1-0-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-1'                                                           = [PSCustomObject] @{
            Name       = 'WORLD AUTHORITY'
            SID        = 'S-1-1'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-1-0'                                                         = [PSCustomObject] @{
            Name       = 'Everyone'
            SID        = 'S-1-1-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-2'                                                           = [PSCustomObject] @{
            Name       = 'LOCAL AUTHORITY'
            SID        = 'S-1-2'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-2-0'                                                         = [PSCustomObject] @{
            Name       = 'LOCAL'
            SID        = 'S-1-2-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-2-1'                                                         = [PSCustomObject] @{
            Name       = 'CONSOLE LOGON'
            SID        = 'S-1-2-1'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-3'                                                           = [PSCustomObject] @{
            Name       = 'CREATOR AUTHORITY'
            SID        = 'S-1-3'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-3-0'                                                         = [PSCustomObject] @{
            Name       = 'CREATOR OWNER'
            SID        = 'S-1-3-0'
            DomainName = ''
            Type       = 'WellKnownAdministrative'
            Error      = ''
        }
        'S-1-3-1'                                                         = [PSCustomObject] @{
            Name       = 'CREATOR GROUP'
            SID        = 'S-1-3-1'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-3-2'                                                         = [PSCustomObject] @{
            Name       = 'CREATOR OWNER SERVER'
            SID        = 'S-1-3-2'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-3-3'                                                         = [PSCustomObject] @{
            Name       = 'CREATOR GROUP SERVER'
            SID        = 'S-1-3-3'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-3-4'                                                         = [PSCustomObject] @{
            Name       = 'OWNER RIGHTS'
            SID        = 'S-1-3-4'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-0'                                                      = [PSCustomObject] @{
            Name       = 'NT SERVICE\ALL SERVICES'
            SID        = 'S-1-5-80-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-4'                                                           = [PSCustomObject] @{
            Name       = 'Non-unique Authority'
            SID        = 'S-1-4'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5'                                                           = [PSCustomObject] @{
            Name       = 'NT AUTHORITY'
            SID        = 'S-1-5'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-1'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\DIALUP'
            SID        = 'S-1-5-1'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-2'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\NETWORK'
            SID        = 'S-1-5-2'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-3'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\BATCH'
            SID        = 'S-1-5-3'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-4'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\INTERACTIVE'
            SID        = 'S-1-5-4'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-6'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\SERVICE'
            SID        = 'S-1-5-6'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-7'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\ANONYMOUS LOGON'
            SID        = 'S-1-5-7'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-8'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\PROXY'
            SID        = 'S-1-5-8'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-9'                                                         = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS'
            SID        = 'S-1-5-9'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-10'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\SELF'
            SID        = 'S-1-5-10'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-11'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\Authenticated Users'
            SID        = 'S-1-5-11'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-12'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\RESTRICTED'
            SID        = 'S-1-5-12'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-13'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\TERMINAL SERVER USER'
            SID        = 'S-1-5-13'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-14'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\REMOTE INTERACTIVE LOGON'
            SID        = 'S-1-5-14'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-15'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\This Organization'
            SID        = 'S-1-5-15'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-17'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\IUSR'
            SID        = 'S-1-5-17'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-18'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\SYSTEM'
            SID        = 'S-1-5-18'
            DomainName = ''
            Type       = 'WellKnownAdministrative'
            Error      = ''
        }
        'S-1-5-19'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\LOCAL SERVICE'
            SID        = 'S-1-5-19'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-20'                                                        = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\NETWORK SERVICE'
            SID        = 'S-1-5-20'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-544'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Administrators'
            SID        = 'S-1-5-32-544'
            DomainName = ''
            Type       = 'WellKnownAdministrative'
            Error      = ''
        }
        'S-1-5-32-545'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Users'
            SID        = 'S-1-5-32-545'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-546'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Guests'
            SID        = 'S-1-5-32-546'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-547'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Power Users'
            SID        = 'S-1-5-32-547'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-548'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Account Operators'
            SID        = 'S-1-5-32-548'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-549'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Server Operators'
            SID        = 'S-1-5-32-549'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-550'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Print Operators'
            SID        = 'S-1-5-32-550'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-551'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Backup Operators'
            SID        = 'S-1-5-32-551'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-552'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Replicators'
            SID        = 'S-1-5-32-552'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-64-10'                                                     = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\NTLM Authentication'
            SID        = 'S-1-5-64-10'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-64-14'                                                     = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\SChannel Authentication'
            SID        = 'S-1-5-64-14'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-64-21'                                                     = [PSCustomObject] @{
            Name       = 'NT AUTHORITY\Digest Authentication'
            SID        = 'S-1-5-64-21'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80'                                                        = [PSCustomObject] @{
            Name       = 'NT SERVICE'
            SID        = 'S-1-5-80'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-83-0'                                                      = [PSCustomObject] @{
            Name       = 'NT VIRTUAL MACHINE\Virtual Machines'
            SID        = 'S-1-5-83-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-0'                                                        = [PSCustomObject] @{
            Name       = 'Untrusted Mandatory Level'
            SID        = 'S-1-16-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-4096'                                                     = [PSCustomObject] @{
            Name       = 'Low Mandatory Level'
            SID        = 'S-1-16-4096'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-8192'                                                     = [PSCustomObject] @{
            Name       = 'Medium Mandatory Level'
            SID        = 'S-1-16-8192'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-8448'                                                     = [PSCustomObject] @{
            Name       = 'Medium Plus Mandatory Level'
            SID        = 'S-1-16-8448'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-12288'                                                    = [PSCustomObject] @{
            Name       = 'High Mandatory Level'
            SID        = 'S-1-16-12288'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-16384'                                                    = [PSCustomObject] @{
            Name       = 'System Mandatory Level'
            SID        = 'S-1-16-16384'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-20480'                                                    = [PSCustomObject] @{
            Name       = 'Protected Process Mandatory Level'
            SID        = 'S-1-16-20480'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-16-28672'                                                    = [PSCustomObject] @{
            Name       = 'Secure Process Mandatory Level'
            SID        = 'S-1-16-28672'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-554'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Pre-Windows 2000 Compatible Access'
            SID        = 'S-1-5-32-554'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-555'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Remote Desktop Users'
            SID        = 'S-1-5-32-555'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-556'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Network Configuration Operators'
            SID        = 'S-1-5-32-556'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-557'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Incoming Forest Trust Builders'
            SID        = 'S-1-5-32-557'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-558'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Performance Monitor Users'
            SID        = 'S-1-5-32-558'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-559'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Performance Log Users'
            SID        = 'S-1-5-32-559'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-560'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Windows Authorization Access Group'
            SID        = 'S-1-5-32-560'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-561'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Terminal Server License Servers'
            SID        = 'S-1-5-32-561'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-562'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Distributed COM Users'
            SID        = 'S-1-5-32-562'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-568'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\IIS_IUSRS'
            SID        = 'S-1-5-32-568'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-569'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Cryptographic Operators'
            SID        = 'S-1-5-32-569'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-573'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Event Log Readers'
            SID        = 'S-1-5-32-573'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-574'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Certificate Service DCOM Access'
            SID        = 'S-1-5-32-574'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-575'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\RDS Remote Access Servers'
            SID        = 'S-1-5-32-575'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-576'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\RDS Endpoint Servers'
            SID        = 'S-1-5-32-576'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-577'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\RDS Management Servers'
            SID        = 'S-1-5-32-577'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-578'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Hyper-V Administrators'
            SID        = 'S-1-5-32-578'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-579'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Access Control Assistance Operators'
            SID        = 'S-1-5-32-579'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-32-580'                                                    = [PSCustomObject] @{
            Name       = 'BUILTIN\Remote Management Users'
            SID        = 'S-1-5-32-580'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-90-0'                                                      = [PSCustomObject] @{
            Name       = 'Window Manager\Window Manager Group'
            SID        = 'S-1-5-90-0'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420'  = [PSCustomObject] @{
            Name       = 'NT SERVICE\WdiServiceHost'
            SID        = 'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-3880718306-3832830129-1677859214-2598158968-1052248003' = [PSCustomObject] @{
            Name       = 'NT SERVICE\MSSQLSERVER'
            SID        = 'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-344959196-2060754871-2302487193-2804545603-1466107430'  = [PSCustomObject] @{
            Name       = 'NT SERVICE\SQLSERVERAGENT'
            SID        = 'S-1-5-80-344959196-2060754871-2302487193-2804545603-1466107430'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-2652535364-2169709536-2857650723-2622804123-1107741775' = [PSCustomObject] @{
            Name       = 'NT SERVICE\SQLTELEMETRY'
            SID        = 'S-1-5-80-2652535364-2169709536-2857650723-2622804123-1107741775'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-3245704983-3664226991-764670653-2504430226-901976451'   = [PSCustomObject] @{
            Name       = 'NT SERVICE\ADSync'
            SID        = 'S-1-5-80-3245704983-3664226991-764670653-2504430226-901976451'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }
        'S-1-5-80-4215458991-2034252225-2287069555-1155419622-2701885083' = [PSCustomObject] @{
            Name       = 'NT Service\himds'
            SID        = 'S-1-5-80-4215458991-2034252225-2287069555-1155419622-2701885083'
            DomainName = ''
            Type       = 'WellKnownGroup'
            Error      = ''
        }

        # 'S-1-5-113'                                                      = [PSCustomObject] @{
        #     Name       = 'NT AUTHORITY\Local account'
        #     SID        = 'S - 1 - 5 - 113'
        #     DomainName = ''
        #     Type       = 'WellKnownGroup'
        #     Error      = ''
        # }
        # 'S-1-5-114'                                                      = [PSCustomObject] @{
        #     Name       = 'NT AUTHORITY\Local account and member of Administrators group'
        #     SID        = 'S - 1 - 5 - 114'
        #     DomainName = ''
        #     Type       = 'WellKnownGroup'
        #     Error      = ''
        # }
    }
    foreach ($S in $SID) {
        if ($OnlyWellKnownAdministrative) {
            # In this case we only return very few high permissions, otherwise nothing
            if ($WellKnownAdministrative[$S]) {
                $WellKnownAdministrative[$S]
            }
        } elseif ($OnlyWellKnown) {
            # In this case we only return well known cases, otherwise nothing
            if ($wellKnownSIDs[$S]) {
                $wellKnownSIDs[$S]
            }
        } else {
            # In this case we return WellKnown, or try to resolve stuff
            if ($wellKnownSIDs[$S]) {
                $wellKnownSIDs[$S]
            } else {
                if ($DoNotResolve) {
                    if ($S -like "S-1-5-21-*-519" -or $S -like "S-1-5-21-*-512") {
                        # Domain Admins / Enterprise Admins
                        [PSCustomObject] @{
                            Name       = $S
                            SID        = $S
                            DomainName = '' # we don't know from SID which domain it is, without checking LDAP
                            Type       = 'Administrative'
                            Error      = ''
                        }
                    } else {
                        # Return unchanged object
                        [PSCustomObject] @{
                            Name       = $S
                            SID        = $S
                            DomainName = ''
                            Error      = ''
                            Type       = 'NotAdministrative'
                        }
                    }
                } else {
                    if (-not $Script:LocalComputerSID) {
                        $Script:LocalComputerSID = Get-LocalComputerSid
                    }
                    try {
                        if ($S.Length -le 18) {
                            $Type = 'NotAdministrative'
                            $Name = (([System.Security.Principal.SecurityIdentifier]::new($S)).Translate([System.Security.Principal.NTAccount])).Value
                            [PSCustomObject] @{
                                Name       = $Name
                                SID        = $S
                                DomainName = ''
                                Type       = $Type
                                Error      = ''
                            }
                        } else {
                            if ($S -like "S-1-5-21-*-519" -or $S -like "S-1-5-21-*-512") {
                                $Type = 'Administrative'
                            } else {
                                $Type = 'NotAdministrative'
                            }
                            $Name = (([System.Security.Principal.SecurityIdentifier]::new($S)).Translate([System.Security.Principal.NTAccount])).Value
                            [PSCustomObject] @{
                                Name       = $Name
                                SID        = $S
                                DomainName = if ($S -like "$Script:LocalComputerSID*") { '' } else { (ConvertFrom-NetbiosName -Identity $Name).DomainName }
                                Type       = $Type
                                Error      = ''
                            }
                        }
                    } catch {
                        # Return unchanged object
                        [PSCustomObject] @{
                            Name       = $S
                            SID        = $S
                            DomainName = ''
                            Error      = $_.Exception.Message -replace [environment]::NewLine, ' '
                            Type       = 'Unknown'
                        }
                    }
                }
            }
        }
    }
}