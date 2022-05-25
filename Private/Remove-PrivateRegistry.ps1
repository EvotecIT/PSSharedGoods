function Remove-PrivateRegistry {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [string] $Computer,
        [string] $Key,
        [System.Collections.IDictionary] $RegistryValue,
        [switch] $Remote,
        [switch] $Suppress
    )
    $PSConnection = $null
    $PSError = $null
    $PSErrorMessage = $null
    try {
        if ($Remote) {
            $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryValue.HiveKey, $Computer, 0 )
        } else {
            $BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($RegistryValue.HiveKey, 0 )
        }
        $PSConnection = $true
        $PSError = $null
    } catch {
        $PSConnection = $false
        $PSError = $($_.Exception.Message)
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            if ($null -ne $BaseHive) {
                $BaseHive.Close()
                $BaseHive.Dispose()
            }
            throw
        } else {
            Write-Warning "Remove-PSRegistry - Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) key $($RegistryValue.Key) on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
        }
    }
    if ($PSError) {
        if (-not $Suppress) {
            [PSCustomObject] @{
                PSComputerName = $Computer
                PSConnection   = $PSConnection
                PSError        = $true
                PSErrorMessage = $PSError
                Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                Key            = $RegistryValue.Key
            }
        }
    } else {
        try {
            if ($Key) {
                $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                if ($PSCmdlet.ShouldProcess($Computer, "Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) key $($RegistryValue.Key)")) {
                    if ($SubKey) {
                        $SubKey.DeleteValue($RegistryValue.Key, $true)
                    }
                } else {
                    $PSError = $true
                    $PSErrorMessage = "WhatIf was used. No changes done."
                }
            } else {
                if ($PSCmdlet.ShouldProcess($Computer, "Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) folder")) {
                    if ($BaseHive) {
                        if ($Recursive) {
                            $BaseHive.DeleteSubKeyTree($RegistryValue.SubKeyName, $true)
                        } else {
                            $BaseHive.DeleteSubKey($RegistryValue.SubKeyName, $true)
                        }
                    }
                } else {
                    $PSError = $true
                    $PSErrorMessage = "WhatIf was used. No changes done."
                }
            }
            if (-not $Suppress) {
                [PSCustomObject] @{
                    PSComputerName = $Computer
                    PSConnection   = $PSConnection
                    PSError        = $PSError
                    PSErrorMessage = $PSErrorMessage
                    Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                    Key            = $RegistryValue.Key
                }
            }
        } catch {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                if ($null -ne $SubKey) {
                    $SubKey.Close()
                    $SubKey.Dispose()
                }
                if ($null -ne $BaseHive) {
                    $BaseHive.Close()
                    $BaseHive.Dispose()
                }
                throw
            } else {
                Write-Warning "Remove-PSRegistry - Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) key $($RegistryValue.Key) on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
            }
            if (-not $Suppress) {
                [PSCustomObject] @{
                    PSComputerName = $Computer
                    PSConnection   = $PSConnection
                    PSError        = $true
                    PSErrorMessage = $_.Exception.Message
                    Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                    Key            = $RegistryValue.Key
                }
            }
        }
    }
    if ($null -ne $SubKey) {
        $SubKey.Close()
        $SubKey.Dispose()
    }
    if ($null -ne $BaseHive) {
        $BaseHive.Close()
        $BaseHive.Dispose()
    }
}