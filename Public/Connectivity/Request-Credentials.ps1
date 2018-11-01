function Request-Credentials {
    param(
        [string] $UserName,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [switch] $Output,
        [string] $Service
    )

    [string] $NewPassword
    if ($FromFile) {
        if (($Password -ne '') -and (Test-Path $Password)) {
            Write-Verbose "Request-Credentials - Reading password from file $Password"
            if ($AsSecure) {
                $NewPassword = Get-Content $Password | ConvertTo-SecureString
                #Write-Verbose "Connect-Exchange - Password to use: $Password"
            } else {
                $NewPassword = Get-Content $Password
                #Write-Verbose "Connect-Exchange - Password to use: $Password"
            }
        } else {
            if ($Output) {
                $Object = @{ Status = $false; Output = $Service; Extended = 'File with password unreadable.' }
                return $Object
            } else {
                Write-Warning "Request-Credentials - Secure password from file couldn't be read. File not readable. Terminating."
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
            $Object = @{ Status = $false; Output = $Service; Extended = 'Username or/and Password is empty' }
            return $Object
        } else {
            Write-Warning 'Request-Credentials - UserName or Password are empty.'
            return
        }
    }
    return $Credentials
}
