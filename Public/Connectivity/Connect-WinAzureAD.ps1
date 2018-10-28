function Connect-WinAzureAD {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure AD',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [switch] $Output
    )
    $Object = @()
    if ($FromFile) {
        if (Test-Path $Password) {
            Write-Verbose "Connect-WinAzureAD - Reading password from file $Password"
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
                Write-Warning "Connect-WinAzureAD - Secure password from file couldn't be read. File not readable. Terminating."
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
            Write-Warning 'Connect-WinAzureAD - UserName or/and Password are empty.'
            return
        }
    }
    try {
        $Session = Connect-AzureAD -Credential $Credentials -ErrorAction Stop
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
            return $Object
        } else {
            Write-Warning "Connect-WinAzureAD - Failed with error message: $ErrorMessage"
            return
        }
    }
    if (-not $Session) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
            return $Object
        } else {
            return
        }
    }
    if ($Output) {
        $Object += @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
        return $Object
    }
}