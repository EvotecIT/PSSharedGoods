function Connect-WinAzure {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure MSOL',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [switch] $Output
    )
    $Object = @()
    if ($FromFile) {
        if (($Password -ne '') -and (Test-Path $Password)) {
            Write-Verbose "Connect-Azure - Reading password from file $Password"
            if ($AsSecure) {
                $NewPassword = Get-Content $Password | ConvertTo-SecureString
                # Write-Verbose "Connect-Azure - Password to use: $Password"
            } else {
                $NewPassword = Get-Content $Password
                #Write-Verbose "Connect-Azure - Password to use: $Password"
            }
        } else {
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = 'File with password unreadable.' }
                return $Object
            } else {
                Write-Warning "Connect-WinAzure - Secure password from file couldn't be read. File not readable. Terminating."
                return
            }
        }
    } else {
        $NewPassword = $Password
    }
    if ($UserName -and $NewPassword) {
        if ($AsSecure) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $NewPassword)
            #Write-Verbose "Connect-Azure - Using AsSecure option with Username $Username and password: $NewPassword"
        } else {
            $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
            #Write-Verbose "Connect-Azure - Using AsSecure option with Username $Username and password: $NewPassword converted to $SecurePassword"
        }
    } else {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Username or/and Password is empty' }
            return $Object
        } else {
            Write-Warning 'Connect-WinAzure - UserName or/and Password are empty.'
            return
        }
    }
    try {
        Connect-MsolService -Credential $Credentials -ErrorAction Stop
        $Connected = $true
    } catch {
        $Connected = $false
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
            return $Object
        } else {
            Write-Warning "Connect-WinAzure - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Connected -eq $false) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
            return $Object
        } else {
            return
        }
    } else {
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
            return $Object
        } else {
            return
        }
    }
}