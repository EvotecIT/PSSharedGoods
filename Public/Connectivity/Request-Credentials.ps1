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
                $Object = @{ Status = $false; Output = $Service; Extended = 'File with password unreadable.' }
                return $Object
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
                    $Object = @{ Status = $false; Output = $Service; Extended = "Couldn't use credentials provided. Most likely using credentials from other user/session/computer." }
                    return $Object
                } else {
                    Write-Warning -Message "Request-Credentials - Couldn't use credentials provided. Most likely using credentials from other user/session/computer."
                    return
                }
            } else {
                if ($Output) {
                    $Object = @{ Status = $false; Output = $Service; Extended = $ErrorMessage }
                    return $Object
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
            #Write-Verbose "Request-Credentials - Using AsSecure option with Username $Username and password: $NewPassword"
        } else {
            Try {
                $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($ErrorMessage -like '*Key not valid for use in specified state*') {
                    if ($Output) {
                        $Object = @{ Status = $false; Output = $Service; Extended = "Couldn't use credentials provided. Most likely using credentials from other user/session/computer." }
                        return $Object
                    } else {
                        Write-Warning -Message "Request-Credentials - Couldn't use credentials provided. Most likely using credentials from other user/session/computer."
                        return
                    }
                } else {
                    if ($Output) {
                        $Object = @{ Status = $false; Output = $Service; Extended = $ErrorMessage }
                        return $Object
                    } else {
                        Write-Warning -Message "Request-Credentials - $ErrorMessage"
                        return
                    }
                }
            }
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
            #Write-Verbose "Request-Credentials - Using AsSecure option with Username $Username and password: $NewPassword converted to $SecurePassword"
        }
    } else {
        if ($Output) {
            $Object = @{ Status = $false; Output = $Service; Extended = 'Username or/and Password is empty' }
            return $Object
        } else {
            Write-Warning -Message 'Request-Credentials - UserName or Password are empty.'
            return
        }
    }
    if ($NetworkCredentials) {
        $RewritePassword = $Credentials.GetNetworkCredential()
        #Get-ObjectType $RewritePassword -VerboseOnly -Verbose
        return $RewritePassword
    } else {
        #Get-ObjectType $Credentials -VerboseOnly -Verbose
        return $Credentials
    }
}
