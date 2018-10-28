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
        if ($FromFile) {
            if (($Password -ne '') -and (Test-Path $Password)) {
                Write-Verbose "Connect-WinExchange - Reading password from file $Password"
                if ($AsSecure) {
                    $NewPassword = Get-Content $Password | ConvertTo-SecureString
                    #Write-Verbose "Connect-Exchange - Password to use: $Password"
                } else {
                    $NewPassword = Get-Content $Password
                    #Write-Verbose "Connect-Exchange - Password to use: $Password"
                }
            } else {
                if ($Output) {
                    $Object += @{ Status = $false; Output = "Exchange"; Extended = 'File with password unreadable.' }
                    return $Object
                } else {
                    Write-Warning "Connect-WinExchange - Secure password from file couldn't be read. File not readable. Terminating."
                    return
                }
            }
        } else {
            $NewPassword = $Password
        }
        if ($UserName -and $NewPassword) {
            if ($AsSecure) {
                $Credentials = New-Object System.Management.Automation.PSCredential($Username, $NewPassword)
                #Write-Verbose "Connect-Exchange - Using AsSecure option with Username $Username and password: $NewPassword"
            } else {
                $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force
                $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
                #Write-Verbose "Connect-Exchange - Using AsSecure option with Username $Username and password: $NewPassword converted to $SecurePassword"
            }
        } else {
            if ($Output) {
                $Object += @{ Status = $false; Output = "Exchange"; Extended = 'Username or/and Password is empty' }
                return $Object
            } else {
                Write-Warning 'Connect-WinExchange - UserName or Password are empty.'
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
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Prefix -Verbose:$false) -Global
    } else {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
    }
    $VerbosePreference = $CurrentVerbosePreference
    $WarningPreference = $CurrentWarningPreference

    ## Verify Connectivity
    #$CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)MailContact", "Get-$($Service.Prefix)Mailbox"
    if ($CheckAvailabilityCommands -contains $false) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Commands unavailable.' }
            return $Object
        } else {
            return
        }
    }

    if ($Output) {
        $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName)" }
        return $Object
    }

    return $Object


}