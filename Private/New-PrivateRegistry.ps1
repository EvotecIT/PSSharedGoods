function New-PrivateRegistry {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $RegistryValue,
        [string] $Computer,
        [switch] $Remote
    )
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
            Write-Warning "New-PSRegistry - Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind) on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
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
            }
        }
    } else {
        try {
            if ($PSCmdlet.ShouldProcess($Computer, "Creating registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)")) {
                $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                if (-not $SubKey) {
                    $SubKeysSplit = $RegistryValue.SubKeyName.Split('\')
                    $SubKey = $BaseHive.OpenSubKey($SubKeysSplit[0], $true)
                    if (-not $SubKey) {
                        $SubKey = $BaseHive.CreateSubKey($SubKeysSplit[0])
                    }
                    $SubKey = $BaseHive.OpenSubKey($SubKeysSplit[0], $true)
                    foreach ($S in $SubKeysSplit | Select-Object -Skip 1) {
                        $SubKey = $SubKey.CreateSubKey($S)
                    }
                    $PSError = $false
                    $PSErrorMessage = $null
                } else {
                    $PSError = $false
                    $PSErrorMessage = "$($RegistryValue.SubKeyName) already exists."
                }
            } else {
                $PSError = $true
                $PSErrorMessage = "WhatIf was used. No changes done."
            }
            if (-not $Suppress) {
                [PSCustomObject] @{
                    PSComputerName = $Computer
                    PSConnection   = $PSConnection
                    PSError        = $PSError
                    PSErrorMessage = $PSErrorMessage
                    Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
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
                Write-Warning "New-PSRegistry - Creating registry $RegistryPath on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
            }
            if (-not $Suppress) {
                [PSCustomObject] @{
                    PSComputerName = $Computer
                    PSConnection   = $PSConnection
                    PSError        = $true
                    PSErrorMessage = $($_.Exception.Message)
                    Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
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