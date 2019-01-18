function Connect-WinSecurityCompliance {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Security and Compliance',
        [string] $ConnectionURI,
        [ValidateSet("Basic", "Kerberos")][String] $Authentication = 'Basic',
        [alias('UserPrincipalName')][string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [string] $Prefix,
        [switch] $Output
    )
    $Object = @()
    if ($MultiFactorAuthentication) {
        Write-Verbose 'Connect-WinSecurityCompliance - Using MFA option'
        try {
            Import-Module $((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | ? { $_ -notmatch "_none_" } | select -First 1)
        } catch {
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed. Couldn't find Exchange Online module to load." }
                return $Object
            } else {
                Write-Warning -Message "Connect-WinSecurityCompliance - Connection failed. Couldn't find Exchange Online module to load."
                return
            }
        }
    } else {
        Write-Verbose 'Connect-WinSecurityCompliance - Using Non-MFA option'
        if ($Authentication -ne 'Kerberos') {
            $Credentials = Request-Credentials -UserName $Username `
                -Password $Password `
                -AsSecure:$AsSecure `
                -FromFile:$FromFile `
                -Service $SessionName `
                -Output

            if ($Credentials -isnot [PSCredential]) {
                if ($Output) {
                    return $Credentials
                } else {
                    return
                }
            }
        } else {
            # Credentials should be null for Kerberos - Current user will run it
            $Credentials = $null
        }
    }
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -contains 'Available') {
        foreach ($UsedSession in $ExistingSession) {
            if ($UsedSession.Availability -eq 'Available') {
                if ($Output) {
                    $Object += @{ Status = $true; Output = $SessionName; Extended = "Will reuse established session to $($Session.ComputerName)" }
                } else {
                    Write-Verbose -Message "Connect-WinSecurityCompliance - reusing session $($Session.ComputerName)"
                }
                $Session = $UsedSession
                break
            }
        }
    } else {
        if ($MultiFactorAuthentication) {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Establishing MFA Connection"
            $PSSessionOption = New-PSSessionOption -ProxyAccessType IEConfig
            try {
                $Session = New-ExoPSSession -UserPrincipalName $UserName -PSSessionOption $PSSessionOption
                $Session.Name = $SessionName
            } catch {
                $Session = $null
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($Output) {
                    $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                    return $Object
                } else {
                    Write-Warning -Message "Connect-WinSecurityCompliance - Failed with error message: $ErrorMessage"
                    return
                }
            }
        } else {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Creating Session to URI: $ConnectionURI"
            $SessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck -Verbose:$false
            try {
                if ($Credentials) {
                    Write-Verbose 'Connect-WinSecurityCompliance - Creating new session using Credentials'
                    $Session = New-PSSession -Credential $Credentials -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -ErrorAction Stop -Verbose:$false
                } else {
                    Write-Verbose 'Connect-WinSecurityCompliance - Creating new session without Credentials'
                    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -Verbose:$false -ErrorAction Stop
                }
            } catch {
                $Session = $null
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($Output) {
                    $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                    return $Object
                } else {
                    Write-Warning "Connect-WinSecurityCompliance - Failed with error message: $ErrorMessage"
                    return
                }
            }
        }
    }


    # Failed connecting to session
    if (-not $Session) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Connection failed.' }
            return $Object
        } else {
            return
        }
    }


    $CurrentVerbosePreference = $VerbosePreference; $VerbosePreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    $CurrentWarningPreference = $WarningPreference; $WarningPreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    if ($Prefix) {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Prefix -Verbose:$false) -Global -Prefix $Prefix
    } else {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
    }
    $VerbosePreference = $CurrentVerbosePreference
    $WarningPreference = $CurrentWarningPreference

    ## Verify Connectivity
    #$CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)ProtectionAlert"
    if ($CheckAvailabilityCommands -contains $false) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Commands unavailable.' }
            return $Object
        } else {
            return
        }
    }

    if ($Output) {
        if ($Prefix) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: $Prefix" }
        } else {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: n/a" }
        }
        return $Object
    } else {
        if ($Prefix) {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Connection established $($Session.ComputerName) - prefix: $Prefix"
        } else {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Connection established $($Session.ComputerName) - prefix: n/a"
        }
    }
    return $Object
}