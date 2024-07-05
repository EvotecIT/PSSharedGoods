function Remove-PrivateRegistry {
    <#
    .SYNOPSIS
    Removes a private registry key on a local or remote computer.

    .DESCRIPTION
    The Remove-PrivateRegistry function removes a registry key on a specified computer. It can be used to delete registry keys for a specific hive key, subkey, and key value.

    .PARAMETER Computer
    Specifies the name of the computer where the registry key will be removed.

    .PARAMETER Key
    Specifies the key value to be removed.

    .PARAMETER RegistryValue
    Specifies the registry key information to be removed. This should be an IDictionary object containing the hive key, subkey, and key value.

    .PARAMETER Remote
    Indicates whether the registry operation should be performed on a remote computer.

    .PARAMETER Suppress
    Suppresses the error message if set to true.

    .EXAMPLE
    Remove-PrivateRegistry -Computer 'Server01' -Key 'Version' -RegistryValue @{ HiveKey = 'LocalMachine'; SubKeyName = 'Software\MyApp' }

    Description:
    Removes the registry key 'Version' under 'LocalMachine\Software\MyApp' on the local computer 'Server01'.

    .EXAMPLE
    Remove-PrivateRegistry -Computer 'Workstation01' -Key 'Wallpaper' -RegistryValue @{ HiveKey = 'CurrentUser'; SubKeyName = 'Control Panel\Desktop' } -Remote

    Description:
    Removes the registry key 'Wallpaper' under 'CurrentUser\Control Panel\Desktop' on the remote computer 'Workstation01'.
    #>
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