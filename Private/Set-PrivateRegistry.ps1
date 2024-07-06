function Set-PrivateRegistry {
    <#
    .SYNOPSIS
    Sets a registry value on a local or remote computer.

    .DESCRIPTION
    The Set-PrivateRegistry function sets a registry value on a specified computer. It can be used to create new registry keys and values, update existing ones, or delete them.

    .PARAMETER RegistryValue
    Specifies the registry value to be set. This parameter should be an IDictionary object containing the following properties:
        - HiveKey: The registry hive key (e.g., 'LocalMachine', 'CurrentUser').
        - SubKeyName: The subkey path where the value will be set.
        - Key: The name of the registry value.
        - Value: The data to be stored in the registry value.
        - ValueKind: The type of data being stored (e.g., String, DWord, MultiString).

    .PARAMETER Computer
    Specifies the name of the computer where the registry value will be set.

    .PARAMETER Remote
    Indicates that the registry value should be set on a remote computer.

    .PARAMETER Suppress
    Suppresses error messages and warnings.

    .EXAMPLE
    Set-PrivateRegistry -RegistryValue @{HiveKey='LocalMachine'; SubKeyName='SOFTWARE\MyApp'; Key='Version'; Value='1.0'; ValueKind='String'} -Computer 'Server01'
    Sets the registry value 'Version' under 'HKEY_LOCAL_MACHINE\SOFTWARE\MyApp' to '1.0' on the local computer 'Server01'.

    .EXAMPLE
    Set-PrivateRegistry -RegistryValue @{HiveKey='CurrentUser'; SubKeyName='Environment'; Key='Path'; Value='C:\MyApp'; ValueKind='String'} -Computer 'Server02' -Remote
    Sets the registry value 'Path' under 'HKEY_CURRENT_USER\Environment' to 'C:\MyApp' on the remote computer 'Server02'.

    .NOTES
    File Name      : Set-PrivateRegistry.ps1
    Prerequisite   : This function requires administrative privileges to modify the registry.
    #>
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $RegistryValue,
        [string] $Computer,
        [switch] $Remote,
        [switch] $Suppress
    )
    Write-Verbose -Message "Set-PSRegistry - Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind) on $Computer"
    if ($RegistryValue.ComputerName) {
        if ($RegistryValue.ComputerName -ne $Computer) {
            return
        }
    }
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
            Write-Warning "Set-PSRegistry - Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind) on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
        }
    }
    if ($PSCmdlet.ShouldProcess($Computer, "Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind)")) {
        if ($PSError) {
            if (-not $Suppress) {
                [PSCustomObject] @{
                    PSComputerName = $Computer
                    PSConnection   = $PSConnection
                    PSError        = $true
                    PSErrorMessage = $PSError
                    Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                    Key            = $RegistryValue.Key
                    Value          = $RegistryValue.Value
                    Type           = $RegistryValue.ValueKind
                }
            }
        } else {
            try {
                #$BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($RegistryValue.HiveKey, 0 )
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
                }
                if ($RegistryValue.ValueKind -eq [Microsoft.Win32.RegistryValueKind]::MultiString) {
                    $SubKey.SetValue($RegistryValue.Key, [string[]] $RegistryValue.Value, $RegistryValue.ValueKind)
                } elseif ($RegistryValue.ValueKind -in [Microsoft.Win32.RegistryValueKind]::None, [Microsoft.Win32.RegistryValueKind]::Binary) {
                    $SubKey.SetValue($RegistryValue.Key, [byte[]] $RegistryValue.Value, $RegistryValue.ValueKind)
                } else {
                    $SubKey.SetValue($RegistryValue.Key, $RegistryValue.Value, $RegistryValue.ValueKind)
                }
                if (-not $Suppress) {
                    [PSCustomObject] @{
                        PSComputerName = $Computer
                        PSConnection   = $PSConnection
                        PSError        = $false
                        PSErrorMessage = $null
                        Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                        Key            = $RegistryValue.Key
                        Value          = $RegistryValue.Value
                        Type           = $RegistryValue.ValueKind
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
                    Write-Warning "Set-PSRegistry - Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind) on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
                if (-not $Suppress) {
                    [PSCustomObject] @{
                        PSComputerName = $Computer
                        PSConnection   = $PSConnection
                        PSError        = $true
                        PSErrorMessage = $_.Exception.Message
                        Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                        Key            = $RegistryValue.Key
                        Value          = $RegistryValue.Value
                        Type           = $RegistryValue.ValueKind
                    }
                }
            }
        }
    } else {
        if (-not $Suppress) {
            [PSCustomObject] @{
                PSComputerName = $Computer
                PSConnection   = $PSConnection
                PSError        = $true
                PSErrorMessage = if ($PSError) { $PSError } else { "WhatIf used - skipping registry setting" }
                Path           = "$($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)"
                Key            = $RegistryValue.Key
                Value          = $RegistryValue.Value
                Type           = $RegistryValue.ValueKind
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