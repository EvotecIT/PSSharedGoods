function Connect-WinService {
    [CmdletBinding()]
    param (
        [Object] $Credentials,
        [Object] $Service,
        [string] $Type,
        [switch] $Output
    )
    $Object = @()
    if ($Service.Use) {
        switch ($Type) {
            'ActiveDirectory' {
                # Prepare Data AD
                $CheckAvailabilityCommandsAD = Test-AvailabilityCommands -Commands 'Get-ADForest', 'Get-ADDomain', 'Get-ADRootDSE', 'Get-ADGroup', 'Get-ADUser', 'Get-ADComputer'
                if ($CheckAvailabilityCommandsAD -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = 'ActiveDirectory'; Extended = 'Commands unavailable.' }
                        return $Object
                    } else {
                        Write-Warning "Active Directory documentation can't be started as commands are unavailable. Check if you have Active Directory module available (part of RSAT) and try again."
                        return
                    }
                } else {
                    #if ($Output) {
                    #    $Object += @{ Status = $true; Output = 'ActiveDirectory'; Extended = 'Commands available.' }
                    #}
                }
                if (-not (Test-ForestConnectivity)) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = 'ActiveDirectory'; Extended = 'No connectivity to forest/domain.' }
                        return $Object
                    } else {
                        Write-Warning 'Active Directory - No connectivity to forest/domain.'
                        return
                    }
                } else {
                    #if ($Output) {
                    #$Object += @{ Status = $true; Output = 'ActiveDirectory'; Extended = 'Connectivity to forest/domain available.' }
                    #}
                }
                if ($Output) {
                    $Object += @{ Status = $true; Output = 'ActiveDirectory'; Extended = 'Connection Established.' }
                    return $Object
                }
            }
            'Azure' {
                # Check Credentials
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = "Azure"; Extended = 'Credentials configuration is incomplete.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $Session = Connect-WinAzure -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile

                if (-not $Session) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = 'Azure'; Extended = 'Connection Failed.' }
                        return $Object
                    } else {
                        return
                    }
                }

                if ($Output) {
                    $Object += @{ Status = $true; Output = 'Azure'; Extended = 'Connection Established.' }
                    return $Object
                }
            }
            'AzureAD' {

            }
            'Exchange' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Document.DocumentExchange.Configuration -AllowEmptyKeys 'Username', 'Password'
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = "Exchange"; Extended = 'Credentials configuration is incomplete.' }
                        return $Object
                    } else {
                        return
                    }
                }
                $Session = Connect-WinExchange -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile


                $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
                if ($CheckAvailabilityCommands -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = 'Exchange'; Extended = 'Commands unavailable.' }
                        return $Object
                    } else {
                        return
                    }
                }

                if ($Output) {
                    $Object += @{ Status = $true; Output = 'Exchange'; Extended = 'Connection Established.' }
                    return $Object
                }
            }
            'ExchangeOnline' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = "ExchangeOnline"; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $Session = Connect-WinExchange -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile

                # Failed connecting to session
                if (-not $Session) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = 'ExchangeOnline'; Extended = 'Connection failed.' }
                        return $Object
                    } else {
                        return
                    }
                }

                # Import Session
                $CurrentVerbosePreference = $VerbosePreference; $VerbosePreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
                $CurrentWarningPreference = $WarningPreference; $WarningPreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
                if ($Service.Prefix) {
                    Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Service.Prefix -Verbose:$false) -Global
                } else {
                    Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
                }
                $VerbosePreference = $CurrentVerbosePreference
                $WarningPreference = $CurrentWarningPreference

                ## Verify Connectivity
                $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)MailContact", "Get-$($Service.Prefix)CalendarProcessing"
                if ($CheckAvailabilityCommands -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = 'ExchangeOnline'; Extended = 'Commands unavailable.' }
                        return $Object
                    } else {
                        return
                    }
                }

                if ($Output) {
                    $Object += @{ Status = $true; Output = 'ExchangeOnline'; Extended = 'Connection Established.' }
                    return $Object
                }
            }
        }

    }
}