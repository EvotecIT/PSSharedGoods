function New-PrivateRegistry {
    <#
    .SYNOPSIS
    Creates or updates a private registry key on a local or remote computer.

    .DESCRIPTION
    The New-PrivateRegistry function creates or updates a registry key on a specified computer. It can be used to set registry values for a specific hive key, subkey, value name, value data, and value kind.

    .PARAMETER RegistryValue
    Specifies the registry value to be set. This should be an IDictionary object containing the hive key, subkey, value name, value data, and value kind.

    .PARAMETER Computer
    Specifies the name of the computer where the registry key will be created or updated.

    .PARAMETER Remote
    Indicates whether the registry operation should be performed on a remote computer.

    .EXAMPLE
    New-PrivateRegistry -RegistryValue @{ HiveKey = 'LocalMachine'; SubKeyName = 'Software\MyApp'; Value = 'Version'; ValueData = '1.0'; ValueKind = 'String' } -Computer 'Server01'

    Description:
    Creates a registry key 'Version' with value '1.0' under 'LocalMachine\Software\MyApp' on the local computer 'Server01'.

    .EXAMPLE
    New-PrivateRegistry -RegistryValue @{ HiveKey = 'CurrentUser'; SubKeyName = 'Control Panel\Desktop'; Value = 'Wallpaper'; ValueData = 'C:\Wallpapers\image.jpg'; ValueKind = 'String' } -Computer 'Workstation01' -Remote

    Description:
    Creates a registry key 'Wallpaper' with value 'C:\Wallpapers\image.jpg' under 'CurrentUser\Control Panel\Desktop' on the remote computer 'Workstation01'.

    #>
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