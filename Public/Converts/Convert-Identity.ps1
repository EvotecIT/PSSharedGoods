function Convert-Identity {
    [cmdletBinding(DefaultParameterSetName = 'Identity')]
    param(
        [parameter(ParameterSetName = 'Identity', Position = 0)][string[]] $Identity,
        [parameter(ParameterSetName = 'SID', Mandatory)][System.Security.Principal.SecurityIdentifier[]] $SID,
        [parameter(ParameterSetName = 'Name', Mandatory)][string[]] $Name
    )
    Begin {
        # [System.Security.Principal.WellKnownSidType]::BuiltinAccountOperatorsSid
        if (-not $Script:GlobalCacheSidConvert) {
            $Script:GlobalCacheSidConvert = @{

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
                <#
                'S-1-5-32-548' = [ordered] @{
                    Name  = 'BUILTIN\Account Operators'
                    SID   = 'S-1-5-32-549'
                    Type  = 'WellKnown'
                    Error = ''
                }
                #>
                'S-1-5-32-549' = 'BUILTIN\Server Operators'
                <#
                'S-1-5-32-549' = [ordered] @{
                    Name  = 'BUILTIN\Server Operators'
                    SID   = 'S-1-5-32-549'
                    Type  = 'WellKnown'
                    Error = ''
                }
                #>
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
            #$Script:GlobalCacheSidConvert = @{ }
        }
        $wellKnownSIDs = @{
            'S-1-0'        = 'WellKnown' #'Null Authority'
            'S-1-0-0'      = 'WellKnown' #'Nobody'
            'S-1-1'        = 'WellKnown' #'World Authority'
            'S-1-1-0'      = 'WellKnown' #'Everyone'
            'S-1-2'        = 'WellKnown' #'Local Authority'
            'S-1-2-0'      = 'WellKnown' #'Local'
            'S-1-2-1'      = 'WellKnown' #'Console Logon'
            'S-1-3'        = 'WellKnown' #'Creator Authority'
            'S-1-3-0'      = 'WellKnown' #'Creator Owner'
            'S-1-3-1'      = 'WellKnown' #'Creator Group'
            'S-1-3-2'      = 'WellKnown' #'Creator Owner Server'
            'S-1-3-3'      = 'WellKnown' #'Creator Group Server'
            'S-1-3-4'      = 'WellKnown' #'Owner Rights'
            'S-1-5-80-0'   = 'WellKnown' #'All Services'
            'S-1-4'        = 'WellKnown' #'Non-unique Authority'
            'S-1-5'        = 'WellKnown' #'NT AUTHORITY'
            'S-1-5-1'      = 'WellKnown' #'NT AUTHORITY\DIALUP'
            'S-1-5-2'      = 'WellKnown' #'NT AUTHORITY\NETWORK'
            'S-1-5-3'      = 'WellKnown' #'NT AUTHORITY\BATCH'
            'S-1-5-4'      = 'WellKnown' #'NT AUTHORITY\INTERACTIVE'
            'S-1-5-6'      = 'WellKnown' #'Service'
            'S-1-5-7'      = 'WellKnown' #'Anonymous'
            'S-1-5-8'      = 'WellKnown' #'Proxy'
            'S-1-5-9'      = 'WellKnown' #'Enterprise Domain Controllers'
            'S-1-5-10'     = 'WellKnown' #'Principal Self'
            'S-1-5-11'     = 'WellKnown' #'Authenticated Users'
            'S-1-5-12'     = 'WellKnown' #'Restricted Code'
            'S-1-5-13'     = 'WellKnown' #'Terminal Server Users'
            'S-1-5-14'     = 'WellKnown' #'Remote Interactive Logon'
            'S-1-5-15'     = 'WellKnown' #'This Organization'
            'S-1-5-17'     = 'WellKnown' #'This Organization'
            'S-1-5-18'     = 'WellKnownAdministrative' #'NT AUTHORITY\SYSTEM'
            'S-1-5-19'     = 'WellKnown' #'NT AUTHORITY\NETWORK SERVICE'
            'S-1-5-20'     = 'WellKnown' #'NT AUTHORITY\NETWORK SERVICE'
            'S-1-5-32-544' = 'WellKnownAdministrative' #'BUILTIN\Administrators'
            'S-1-5-32-545' = 'WellKnown' #'BUILTIN\Users'
            'S-1-5-32-546' = 'WellKnown' #'Guests'
            'S-1-5-32-547' = 'WellKnown' #'Power Users'
            'S-1-5-32-548' = 'WellKnown' #'Account Operators'
            'S-1-5-32-549' = 'WellKnown' #'Server Operators'
            'S-1-5-32-550' = 'WellKnown' #'Print Operators'
            'S-1-5-32-551' = 'WellKnown' #'Backup Operators'
            'S-1-5-32-552' = 'WellKnown' #'Replicators'
            'S-1-5-64-10'  = 'WellKnown' #'NTLM Authentication'
            'S-1-5-64-14'  = 'WellKnown' #'SChannel Authentication'
            'S-1-5-64-21'  = 'WellKnown' #'Digest Authority'
            'S-1-5-80'     = 'WellKnown' #'NT SERVICE'
            'S-1-5-83-0'   = 'WellKnown' #'NT VIRTUAL MACHINE\Virtual Machines'
            'S-1-16-0'     = 'WellKnown' #'Untrusted Mandatory Level'
            'S-1-16-4096'  = 'WellKnown' #'Low Mandatory Level'
            'S-1-16-8192'  = 'WellKnown' #'Medium Mandatory Level'
            'S-1-16-8448'  = 'WellKnown' #'Medium Plus Mandatory Level'
            'S-1-16-12288' = 'WellKnown' #'High Mandatory Level'
            'S-1-16-16384' = 'WellKnown' #'System Mandatory Level'
            'S-1-16-20480' = 'WellKnown' #'Protected Process Mandatory Level'
            'S-1-16-28672' = 'WellKnown' #'Secure Process Mandatory Level'
            'S-1-5-32-554' = 'WellKnown' #'BUILTIN\Pre-Windows 2000 Compatible Access'
            'S-1-5-32-555' = 'WellKnown' #'BUILTIN\Remote Desktop Users'
            'S-1-5-32-556' = 'WellKnown' #'BUILTIN\Network Configuration Operators'
            'S-1-5-32-557' = 'WellKnown' #'BUILTIN\Incoming Forest Trust Builders'
            'S-1-5-32-558' = 'WellKnown' #'BUILTIN\Performance Monitor Users'
            'S-1-5-32-559' = 'WellKnown' #'BUILTIN\Performance Log Users'
            'S-1-5-32-560' = 'WellKnown' #'BUILTIN\Windows Authorization Access Group'
            'S-1-5-32-561' = 'WellKnown' #'BUILTIN\Terminal Server License Servers'
            'S-1-5-32-562' = 'WellKnown' #'BUILTIN\Distributed COM Users'
            'S-1-5-32-569' = 'WellKnown' #'BUILTIN\Cryptographic Operators'
            'S-1-5-32-573' = 'WellKnown' #'BUILTIN\Event Log Readers'
            'S-1-5-32-574' = 'WellKnown' #'BUILTIN\Certificate Service DCOM Access'
            'S-1-5-32-575' = 'WellKnown' #'BUILTIN\RDS Remote Access Servers'
            'S-1-5-32-576' = 'WellKnown' #'BUILTIN\RDS Endpoint Servers'
            'S-1-5-32-577' = 'WellKnown' #'BUILTIN\RDS Management Servers'
            'S-1-5-32-578' = 'WellKnown' #'BUILTIN\Hyper-V Administrators'
            'S-1-5-32-579' = 'WellKnown' #'BUILTIN\Access Control Assistance Operators'
            'S-1-5-32-580' = 'WellKnown' #'BUILTIN\Remote Management Users'
        }

    }
    Process {
        if ($Identity) {
            foreach ($Ident in $Identity) {
                # regex check if SID .. do something
                if ([Regex]::IsMatch($Ident, "S-\d-\d+-(\d+-){1,14}\d+")) {
                    if ($Script:GlobalCacheSidConvert[$Ident]) {
                        Write-Verbose "Convert-Identity - Processing SID $Ident from cache."
                        if ($Script:GlobalCacheSidConvert[$Ident] -is [string]) {
                            # I could have built full blown $Script:GlobalCacheSidConvert cache but opted to built it manually here
                            # basically Server Operators or Account Operators won't be resolved by SID on non-domain controllers so we need to build it manually
                            [PSCustomObject] @{
                                Name       = $Script:GlobalCacheSidConvert[$Ident]
                                SID        = $Ident
                                DomainName = (ConvertFrom-NetbiosName -Identity $Ident).DomainName
                                Type       = $wellKnownSIDs[$Ident]
                                Error      = ''
                            }
                        } else {
                            $Script:GlobalCacheSidConvert[$Ident]
                        }
                    } else {
                        if ([Regex]::IsMatch($Ident, "^S-\d-\d+-(\d+-){1,14}\d+$")) {
                            # This is SID
                            Write-Verbose "Convert-Identity - Processing SID $Ident"
                            try {
                                [string] $Name = (([System.Security.Principal.SecurityIdentifier]::new($Ident)).Translate([System.Security.Principal.NTAccount])).Value
                                $ErrorMessage = ''
                                if ($Ident -like "S-1-5-21-*-519" -or $Ident -like "S-1-5-21-*-512") {
                                    $Type = 'Administrative'
                                } elseif ($wellKnownSIDs[$Ident]) {
                                    $Type = $wellKnownSIDs[$Ident]
                                } else {
                                    $Type = 'NotAdministrative'
                                }
                            } catch {
                                [string] $Name = ''
                                $ErrorMessage = $_.Exception.Message
                                $Type = 'Unknown'
                            }
                            $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                                Name       = $Name
                                SID        = $Ident
                                DomainName = if ($Name) { (ConvertFrom-NetbiosName -Identity $Name).DomainName } else { '' }
                                Type       = $Type
                                Error      = $ErrorMessage
                            }
                            $Script:GlobalCacheSidConvert[$Ident]
                        } else {
                            Write-Verbose "Convert-Identity - Processing SID within DN - $Ident"
                            # THis is SID within full string so we exctract it # 'CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz'
                            $Output = [Regex]::Matches($Ident, "S-\d-\d+-(\d+-){1,14}\d+")
                            if ($Output.Count -eq 1 -and $Output.Value) {
                                Convert-Identity -Identity $Output.Value
                            } else {
                                $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                                    Name       = ''
                                    SID        = $Ident
                                    DomainName = (ConvertFrom-NetbiosName -Identity $Name).DomainName
                                    Type       = 'Unknown'
                                    Error      = 'Unable to process properly. SID within DN not found.'
                                }
                            }
                        }
                    }
                } else {
                    Write-Verbose "Convert-Identity - Processing $Ident (not regex)"
                    if ($Script:GlobalCacheSidConvert[$Ident]) {
                        #Write-Verbose "Convert-Identity - Processing $Ident (from cache)"
                        $Script:GlobalCacheSidConvert[$Ident]
                    } else {
                        if ($Ident -like '*DC=*') {
                            Write-Verbose "Convert-Identity - Processing DistinguishedName $Ident"
                            # DistinguishedName resolving
                            try {
                                <#
                                $Object = Get-ADObject -Identity $Ident -Properties objectSid
                                if ($Object) {
                                    # We resolved it, but now we want to give it name similar to other commands
                                    # This is so name like CN=S-1-5-21-1928204107-2710010574-1926425344-512,CN=ForeignSecurityPrincipals,DC=ad,DC=evotec,DC=xyz can be properly changed
                                    [string] $Name = (([System.Security.Principal.SecurityIdentifier]::new($Object.objectSid.Value)).Translate([System.Security.Principal.NTAccount])).Value
                                }
                                #>
                                $Object = [adsi]"LDAP://$($Ident)"
                                if ($Object) {
                                    $SIDValue = [System.Security.Principal.SecurityIdentifier]::new($Object.objectSid.Value, 0).Value
                                    [string] $Name = (([System.Security.Principal.SecurityIdentifier]::new($SIDValue)).Translate([System.Security.Principal.NTAccount])).Value
                                    #if ($Object.SchemaClassName -eq 'foreignSecurityPrincipal') {
                                    #    [string] $Name = (([System.Security.Principal.SecurityIdentifier]::new($SIDValue)).Translate([System.Security.Principal.NTAccount])).Value
                                    #} else {
                                    #    [string] $Name = $Object.Name.Value
                                    #}
                                } else {
                                    [string] $Name = $Ident
                                    $SIDValue = $null
                                }
                                $ErrorMessage = ''
                                if ($Ident -like "S-1-5-21-*-519" -or $Ident -like "S-1-5-21-*-512") {
                                    $Type = 'Administrative'
                                } elseif ($wellKnownSIDs[$Ident]) {
                                    $Type = $wellKnownSIDs[$Ident]
                                } else {
                                    $Type = 'NotAdministrative'
                                }
                                #$SIDValue = $Object.objectSid.Value
                            } catch {
                                [string] $Name = $Ident
                                $Type = 'Unknown'
                                $ErrorMessage = $_.Exception.Message
                                $SIDValue = $null
                            }
                            $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                                Name       = $Name
                                SID        = $SIDValue
                                DomainName = (ConvertFrom-NetbiosName -Identity $Name).DomainName
                                Type       = $Type
                                Error      = $ErrorMessage
                            }
                            $Script:GlobalCacheSidConvert[$Ident]
                        } else {
                            try {
                                $SIDValue = ([System.Security.Principal.NTAccount] $Ident).Translate([System.Security.Principal.SecurityIdentifier]).Value
                                if ($SIDValue -like "S-1-5-21-*-519" -or $SIDValue -like "S-1-5-21-*-512") {
                                    $Type = 'Administrative'
                                } elseif ($wellKnownSIDs[$SIDValue]) {
                                    $Type = $wellKnownSIDs[$SIDValue]
                                } else {
                                    $Type = 'NotAdministrative'
                                }
                                $ErrorMessage = ''
                            } catch {
                                $Type = 'Unknown'
                                $ErrorMessage = $_.Exception.Message
                            }
                            if ($Type -in 'WellKnown', 'WellKnownAdministrative') {
                                # If we query for things like 'NT AUTHORITY\NETWORK' it will take very long time to process
                                $DomainName = ''
                            } else {
                                if ($Ident -like '*@*') {
                                    $DomainName = ''
                                } else {
                                    $DomainName = (ConvertFrom-NetbiosName -Identity $Ident).DomainName
                                }
                            }
                            $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                                Name       = $Ident
                                SID        = $SIDValue
                                DomainName = $DomainName
                                Type       = $Type
                                Error      = $ErrorMessage
                            }
                            $Script:GlobalCacheSidConvert[$Ident]
                        }
                    }
                }
            }
        } else {
            if ($SID) {
                foreach ($S in $SID) {
                    if ($Script:GlobalCacheSidConvert[$S]) {
                        $Script:GlobalCacheSidConvert[$S]
                    } else {
                        $Script:GlobalCacheSidConvert[$S] = (([System.Security.Principal.SecurityIdentifier]::new($S)).Translate([System.Security.Principal.NTAccount])).Value
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
    End {

    }
}