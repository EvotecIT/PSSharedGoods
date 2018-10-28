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
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Commands unavailable.' }
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
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'No connectivity to forest/domain.' }
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
                    $Object += @{ Status = $true; Output = $Service.SessionName; Extended = 'Connection Established.' }
                    return $Object
                }
            }
            'Azure' {
                # Check Credentials
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }

                $OutputCommand = Connect-WinAzure -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -Output
                return $OutputCommand
            }
            'AzureAD' {
                # Check Credentials
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                $OutputCommand = Connect-WinAzureAD -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -Output
                return $OutputCommand
            }
            'Exchange' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Document.DocumentExchange.Configuration -AllowEmptyKeys 'Username', 'Password'
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                $OutputCommand = Connect-WinExchange -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand
            }
            'ExchangeOnline' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $OutputCommand = Connect-WinExchange -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand

            }
        }

    }
}