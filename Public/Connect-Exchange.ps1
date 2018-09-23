function Connect-Exchange {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Evotec',
        [string] $ConnectionURI = 'http://ex2013x3.ad.evotec.xyz/Powershell', # https://outlook.office365.com/powershell-liveid/
        [ValidateSet("Basic", "Kerberos")][String] $Authentication = 'Kerberos',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile
    )

    if ($FromFile) {
        if (Test-Path $Password) {
            Write-Verbose "Connect-Exchange - Reading password from file $Password"
            if ($AsSecure) {
                $NewPassword = Get-Content $Password | ConvertTo-SecureString
                #Write-Verbose "Connect-Exchange - Password to use: $Password"
            } else {
                $NewPassword = Get-Content $Password
                #Write-Verbose "Connect-Exchange - Password to use: $Password"
            }
        } else {
            Write-Warning "Connect-Exchange - Secure password from file couldn't be read. File not readable. Terminating."
            return
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
    }
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -eq 'Available') {
        foreach ($Session in $ExistingSession) {
            if ($Session.Availability -eq 'Available') {
                Write-Verbose "Connect-Exchange - reusing session $($ExistingSession.ComputerName)"
                return $Session
            }
        }
    } else {
        Write-Verbose "Connect-Exchange - Creating Session to URI: $ConnectionURI"
        $SessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck -Verbose:$false
        try {
            if ($Credentials) {
                Write-Verbose 'Connect-Exchange - Creating new session using Credentials'
                $Session = New-PSSession -Credential $Credentials -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -ErrorAction Stop -Verbose:$false
            } else {
                Write-Verbose 'Connect-Exchange - Creating new session without Credentials'
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -Verbose:$false -ErrorAction Stop
            }
        } catch {
            $Session = $null
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning "Connect-Exchange - Failed with error message: $ErrorMessage"
        }
        return $Session
    }
}