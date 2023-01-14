function Request-Credentials {
    [CmdletBinding()]
    param(
        [string] $UserName,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [switch] $Output,
        [switch] $NetworkCredentials,
        [string] $Service
    )
    if ($FromFile) {
        if (($Password -ne '') -and (Test-Path $Password)) {
            # File is there and we are reading it into Password
            Write-Verbose "Request-Credentials - Reading password from file $Password"
            $Password = Get-Content -Path $Password
        } else {
            # File is not there or couldn't be read
            if ($Output) {
                return @{ Status = $false; Output = $Service; Extended = 'File with password unreadable.' }
            } else {
                Write-Warning "Request-Credentials - Secure password from file couldn't be read. File not readable. Terminating."
                return
            }
        }
    }
    if ($AsSecure) {
        try {
            $NewPassword = $Password | ConvertTo-SecureString -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($ErrorMessage -like '*Key not valid for use in specified state*') {
                if ($Output) {
                    return @{ Status = $false; Output = $Service; Extended = "Couldn't use credentials provided. Most likely using credentials from other user/session/computer." }
                } else {
                    Write-Warning -Message "Request-Credentials - Couldn't use credentials provided. Most likely using credentials from other user/session/computer."
                    return
                }
            } else {
                if ($Output) {
                    return @{ Status = $false; Output = $Service; Extended = $ErrorMessage }
                } else {
                    Write-Warning -Message "Request-Credentials - $ErrorMessage"
                    return
                }
            }
        }

    } else {
        $NewPassword = $Password
    }
    if ($UserName -and $NewPassword) {
        if ($AsSecure) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $NewPassword)
        } else {
            Try {
                $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($ErrorMessage -like '*Key not valid for use in specified state*') {
                    if ($Output) {
                        return  @{ Status = $false; Output = $Service; Extended = "Couldn't use credentials provided. Most likely using credentials from other user/session/computer." }
                    } else {
                        Write-Warning -Message "Request-Credentials - Couldn't use credentials provided. Most likely using credentials from other user/session/computer."
                        return
                    }
                } else {
                    if ($Output) {
                        return @{ Status = $false; Output = $Service; Extended = $ErrorMessage }
                    } else {
                        Write-Warning -Message "Request-Credentials - $ErrorMessage"
                        return
                    }
                }
            }
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
        }
    } else {
        if ($Output) {
            return @{ Status = $false; Output = $Service; Extended = 'Username or/and Password is empty' }
        } else {
            Write-Warning -Message 'Request-Credentials - UserName or Password are empty.'
            return
        }
    }
    if ($NetworkCredentials) {
        return $Credentials.GetNetworkCredential()
    } else {
        return $Credentials
    }
}