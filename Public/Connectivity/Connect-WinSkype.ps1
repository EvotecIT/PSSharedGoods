function Connect-WinSkype {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft Skype',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
        Write-Verbose "Connect-WinSkype - Running connectivity without MFA"
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
    }
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -contains 'Available') {
        foreach ($UsedSession in $ExistingSession) {
            if ($UsedSession.Availability -eq 'Available') {
                if ($Output) {
                    $Object += @{ Status = $true; Output = $SessionName; Extended = "Will reuse established session to $($Session.ComputerName)" }
                } else {
                    Write-Verbose -Message "Connect-WinSkype - reusing session $($Session.ComputerName)"
                }
                $Session = $UsedSession
                break
            }
        }
    } else {
        try {
            $Session = New-CsOnlineSession -Credential $Credentials -ErrorAction Stop
            $Session.Name = $SessionName
        } catch {
            $Session = $null
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                return $Object
            } else {
                Write-Warning -Message "Connect-WinSkype - Failed with error message: $ErrorMessage"
                return
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
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)CsExternalAccessPolicy"
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
            Write-Verbose -Message "Connect-WinSkype - Connection established $($Session.ComputerName) - prefix: $Prefix"
        } else {
            Write-Verbose -Message "Connect-WinSkype - Connection established $($Session.ComputerName) - prefix: n/a"
        }
    }
    return $Object
}