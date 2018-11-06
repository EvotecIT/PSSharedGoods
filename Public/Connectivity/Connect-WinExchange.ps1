function Connect-WinExchange {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Exchange',
        [string] $ConnectionURI = 'http://ex2013x3.ad.evotec.xyz/Powershell', # https://outlook.office365.com/powershell-liveid/
        [ValidateSet("Basic", "Kerberos")][String] $Authentication = 'Kerberos',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [string] $Prefix,
        [switch] $Output
    )
    $Object = @()
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
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -contains 'Available') {
        foreach ($Session in $ExistingSession) {
            if ($Session.Availability -eq 'Available') {
                if ($Output) {
                    $Object += @{ Status = $true; Output = $SessionName; Extended = "Will reuse established session to $($Session.ComputerName)" }
                } else {
                    Write-Verbose "Connect-WinExchange - reusing session $($Session.ComputerName)"
                }
            }
        }
    } else {
        Write-Verbose "Connect-WinExchange - Creating Session to URI: $ConnectionURI"
        $SessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck -Verbose:$false
        try {
            if ($Credentials) {
                Write-Verbose 'Connect-WinExchange - Creating new session using Credentials'
                $Session = New-PSSession -Credential $Credentials -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -ErrorAction Stop -Verbose:$false
            } else {
                Write-Verbose 'Connect-WinExchange - Creating new session without Credentials'
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -Verbose:$false -ErrorAction Stop
            }
        } catch {
            $Session = $null
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                return $Object
            } else {
                Write-Warning "Connect-WinExchange - Failed with error message: $ErrorMessage"
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
        #Write-Verbose "Prefix used $Prefix"
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Prefix -Verbose:$false) -Global -Prefix $Prefix
    } else {
        #Write-Verbose "Prefix used - None"
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
    }
    $VerbosePreference = $CurrentVerbosePreference
    $WarningPreference = $CurrentWarningPreference

    ## Verify Connectivity
    #$CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)MailContact", "Get-$($Prefix)Mailbox"
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
    }

    return $Object


}