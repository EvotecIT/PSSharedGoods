function ConvertFrom-SID {
    [cmdletbinding()]
    param(
        [string[]] $SID,
        [switch] $OnlyWellKnown,
        [switch] $OnlyWellKnownAdministrative
    )
    # https://support.microsoft.com/en-au/help/243330/well-known-security-identifiers-in-windows-operating-systems
    $WellKnownAdministrative = @{
        'S-1-5-18' = 'NT AUTHORITY\SYSTEM'
    }
    $wellKnownSIDs = @{
        'S-1-0'        = 'Null AUTHORITY'
        'S-1-0-0'      = 'NULL SID'
        'S-1-1'        = 'WORLD AUTHORITY'
        'S-1-1-0'      = 'Everyone'
        'S-1-2'        = 'LOCAL AUTHORITY'
        'S-1-2-0'      = 'LOCAL'
        'S-1-2-1'      = 'CONSOLE LOGON'
        'S-1-3'        = 'CREATOR AUTHORITY'
        'S-1-3-0'      = 'CREATOR OWNER'
        'S-1-3-1'      = 'CREATOR GROUP'
        'S-1-3-2'      = 'CREATOR OWNER SERVER'
        'S-1-3-3'      = 'CREATOR GROUP SERVER'
        'S-1-3-4'      = 'OWNER RIGHTS'
        'S-1-5-80-0'   = 'NT SERVICE\ALL SERVICES'
        'S-1-4'        = 'Non-unique Authority'
        'S-1-5'        = 'NT AUTHORITY'
        'S-1-5-1'      = 'NT AUTHORITY\DIALUP'
        'S-1-5-2'      = 'NT AUTHORITY\NETWORK'
        'S-1-5-3'      = 'NT AUTHORITY\BATCH'
        'S-1-5-4'      = 'NT AUTHORITY\INTERACTIVE'
        'S-1-5-6'      = 'NT AUTHORITY\SERVICE'
        'S-1-5-7'      = 'NT AUTHORITY\ANONYMOUS LOGON'
        'S-1-5-8'      = 'NT AUTHORITY\PROXY'
        'S-1-5-9'      = 'NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS'
        'S-1-5-10'     = 'NT AUTHORITY\SELF'
        'S-1-5-11'     = 'NT AUTHORITY\Authenticated Users'
        'S-1-5-12'     = 'NT AUTHORITY\RESTRICTED'
        'S-1-5-13'     = 'NT AUTHORITY\TERMINAL SERVER USER'
        'S-1-5-14'     = 'NT AUTHORITY\REMOTE INTERACTIVE LOGON'
        'S-1-5-15'     = 'NT AUTHORITY\This Organization'
        'S-1-5-17'     = 'NT AUTHORITY\IUSR'
        'S-1-5-18'     = 'NT AUTHORITY\SYSTEM'
        'S-1-5-19'     = 'NT AUTHORITY\NETWORK SERVICE'
        'S-1-5-20'     = 'NT AUTHORITY\NETWORK SERVICE'
        'S-1-5-32-544' = 'BUILTIN\Administrators'
        'S-1-5-32-545' = 'BUILTIN\Users'
        'S-1-5-32-546' = 'BUILTIN\Guests'
        'S-1-5-32-547' = 'BUILTIN\Power Users'
        'S-1-5-32-548' = 'BUILTIN\Account Operators'
        'S-1-5-32-549' = 'BUILTIN\Server Operators'
        'S-1-5-32-550' = 'BUILTIN\Print Operators'
        'S-1-5-32-551' = 'BUILTIN\Backup Operators'
        'S-1-5-32-552' = 'BUILTIN\Replicators'
        'S-1-5-64-10'  = 'NT AUTHORITY\NTLM Authentication'
        'S-1-5-64-14'  = 'NT AUTHORITY\SChannel Authentication'
        'S-1-5-64-21'  = 'NT AUTHORITY\Digest Authentication'
        'S-1-5-80'     = 'NT SERVICE'
        'S-1-5-83-0'   = 'NT VIRTUAL MACHINE\Virtual Machines'
        'S-1-16-0'     = 'Untrusted Mandatory Level'
        'S-1-16-4096'  = 'Low Mandatory Level'
        'S-1-16-8192'  = 'Medium Mandatory Level'
        'S-1-16-8448'  = 'Medium Plus Mandatory Level'
        'S-1-16-12288' = 'High Mandatory Level'
        'S-1-16-16384' = 'System Mandatory Level'
        'S-1-16-20480' = 'Protected Process Mandatory Level'
        'S-1-16-28672' = 'Secure Process Mandatory Level'
        'S-1-5-32-554' = 'BUILTIN\Pre-Windows 2000 Compatible Access'
        'S-1-5-32-555' = 'BUILTIN\Remote Desktop Users'
        'S-1-5-32-556' = 'BUILTIN\Network Configuration Operators'
        'S-1-5-32-557' = 'BUILTIN\Incoming Forest Trust Builders'
        'S-1-5-32-558' = 'BUILTIN\Performance Monitor Users'
        'S-1-5-32-559' = 'BUILTIN\Performance Log Users'
        'S-1-5-32-560' = 'BUILTIN\Windows Authorization Access Group'
        'S-1-5-32-561' = 'BUILTIN\Terminal Server License Servers'
        'S-1-5-32-562' = 'BUILTIN\Distributed COM Users'
        'S-1-5-32-569' = 'BUILTIN\Cryptographic Operators'
        'S-1-5-32-573' = 'BUILTIN\Event Log Readers'
        'S-1-5-32-574' = 'BUILTIN\Certificate Service DCOM Access'
        'S-1-5-32-575' = 'BUILTIN\RDS Remote Access Servers'
        'S-1-5-32-576' = 'BUILTIN\RDS Endpoint Servers'
        'S-1-5-32-577' = 'BUILTIN\RDS Management Servers'
        'S-1-5-32-578' = 'BUILTIN\Hyper-V Administrators'
        'S-1-5-32-579' = 'BUILTIN\Access Control Assistance Operators'
        'S-1-5-32-580' = 'BUILTIN\Remote Management Users'
    }
    foreach ($S in $SID) {
        if ($OnlyWellKnownAdministrative) {
            # In this case we only return very few high permissions, otherwise nothing
            if ($WellKnownAdministrative[$S]) {
                [PSCustomObject] @{
                    Name  = $WellKnownAdministrative[$S]
                    SID   = $S
                    Type  = 'WellKnownAdministrative'
                    Error = ''
                }
            }
        } elseif ($OnlyWellKnown) {
            # In this case we only return well known cases, otherwise nothing
            if ($wellKnownSIDs[$S]) {
                [PSCustomObject] @{
                    Name  = $wellKnownSIDs[$S]
                    SID   = $S
                    Type  = 'WellKnownGroup'
                    Error = ''
                }
            }
        } else {
            # In this case we return WellKnown, or try to resolve stuff
            if ($wellKnownSIDs[$S]) {
                [PSCustomObject] @{
                    Name  = $wellKnownSIDs[$S]
                    SID   = $S
                    Type  = 'WellKnownGroup'
                    Error = ''
                }
            } else {
                try {
                    [PSCustomObject] @{
                        Name  = (([System.Security.Principal.SecurityIdentifier]::new($S)).Translate([System.Security.Principal.NTAccount])).Value
                        SID   = $S
                        Type  = 'Standard'
                        Error = ''
                    }
                } catch {
                    # Return unchanged object
                    [PSCustomObject] @{
                        Name  = $S
                        SID   = $S
                        Error = $_.Exception.Message -replace [environment]::NewLine, ' '
                        Type  = 'Unknown'
                    }
                }
            }
        }
    }
}